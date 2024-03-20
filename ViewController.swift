//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource {
    
    // Declare a UIRefreshControl property
    private let refreshControl = UIRefreshControl()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TumblrCell", for: indexPath) as! TumblrCell
        
        // Get the post associated with this row
        let post = posts[indexPath.row]
        
        // Reset the content of the cell
        cell.tumblrCellLabel.text = nil
        cell.tumblrCellImage.image = nil
        
        // Set the summary text from post to tumblrCaptionLabel
        cell.tumblrCellLabel.text = post.summary
        
        // Load image using Nuke from the first photo in the post's photos array
        if let photo = post.photos.first {
            let imageUrl = photo.originalSize.url
            
            // Use options to ignore cache
            let options = ImageLoadingOptions(transition: .fadeIn(duration: 0.3), contentModes: .init(success: .scaleAspectFill, failure: .center, placeholder: .center))
            Nuke.loadImage(with: imageUrl, options: options, into: cell.tumblrCellImage)
        }
        
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        // Add the refresh control to the table view
        tableView.refreshControl = refreshControl
        
        // Set the color of the refresh control to white
        refreshControl.tintColor = .white
        
        // Configure the refresh control with a target-action pair
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        fetchPosts()
    }
    
    // Action method to handle the refresh event
    @objc private func refreshData() {
        fetchPosts()
    }
    
    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/peacecorps/posts/photo?api_key=tRXIXW87WW0tHZer7kERBvi47xl3WD2pXuD4TlHbHnijxQdS5n")!
        let session = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }
            
            guard let data = data else {
                print("❌ Data is NIL")
                return
            }
            
            // Print the response data
            if let responseDataString = String(data: data, encoding: .utf8) {
                print("Response Data: \(responseDataString)")
            }
            
            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)
                DispatchQueue.main.async {
                    self.posts = blog.response.posts
                    self.tableView.reloadData()
                    
                    print(self.posts)
                    
                    // End refreshing state of the refresh control
                    self.refreshControl.endRefreshing()
                }
            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
}
