//
//  TagsTableViewCell.swift
//  VideoSnapChat
//
//  Created by Anton Ivanov on 11/8/16.
//  Copyright © 2016 Ahmed. All rights reserved.
//

import UIKit

class TagsTableViewCell: UITableViewCell {

     var onPlayiconTapped : (() -> Void)? = nil
    
    @IBOutlet weak var btnPlayicon: UIButton!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtDescription: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnPlayiconClick(_ sender: AnyObject) {
        
        if let onPlayiconTapped = self.onPlayiconTapped {
            onPlayiconTapped()
        }

    }

}
