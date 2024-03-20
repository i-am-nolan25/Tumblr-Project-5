//
//  TumblrCell.swift
//  ios101-project5-tumblr
//
//  Created by Naing Oo Lwin on 3/20/24.
//

import UIKit

class TumblrCell: UITableViewCell {
    
    @IBOutlet weak var tumblrCellImage: UIImageView!
    
    @IBOutlet weak var tumblrCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
