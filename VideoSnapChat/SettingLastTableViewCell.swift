//
//  SettingLastTableViewCell.swift
//  VideoSnapChat
//
//  Created by Anton Ivanov on 11/10/16.
//  Copyright © 2016 Ahmed. All rights reserved.
//

import UIKit

class SettingLastTableViewCell: UITableViewCell {

    @IBOutlet weak var btnDelete: UIButton!
    
    var attrs = [
        NSFontAttributeName : UIFont.systemFont(ofSize: 19.0),
        NSForegroundColorAttributeName : UIColor.red,
        NSUnderlineStyleAttributeName : 1] as [String : Any]
    
    var attributedString = NSMutableAttributedString(string:"")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let buttonTitleStr = NSMutableAttributedString(string:"Delete my account", attributes:attrs)
        attributedString.append(buttonTitleStr)
        btnDelete.setAttributedTitle(attributedString, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
