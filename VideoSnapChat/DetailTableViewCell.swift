//
//  DetailTableViewCell.swift
//  VideoSnapChat
//
//  Created by Anton Ivanov on 11/7/16.
//  Copyright © 2016 Ahmed. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtComment: UILabel!
    @IBOutlet weak var txtTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
