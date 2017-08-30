//
//  HomeVideoTableViewCell.swift
//  VideoSnapChat
//
//  Created by Sergey Kulish on 10/15/16.
//  Copyright © 2016 Ahmed. All rights reserved.
//

import UIKit

class HomeVideoTableViewCell: UITableViewCell {

    var onPlayiconTapped : (() -> Void)? = nil
    
    var onFeedbackButtonTapped : (() -> Void)? = nil
    var onFollowButtonTapped : (() -> Void)? = nil
    var onHomeMenuButtonTapped : (() -> Void)? = nil
    
    var onPoperLikeButtonTapped : (() -> Void)? = nil
    var onPoperCommentButtonTapped : (() -> Void)? = nil
    var onPoperContributeButtonTapped : (() -> Void)? = nil
    var onPoperRecordButtonTapped : (() -> Void)? = nil
    
    @IBOutlet weak var poperView: UIView!
    @IBOutlet weak var playicon: UIImageView!
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var txtDescription: UILabel!
    @IBOutlet weak var txtPostingFriendName: UILabel!
    @IBOutlet weak var videoPlayView: UIView!
    @IBOutlet weak var txtLikeNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.poperView.isHidden = true
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func btnCommentClick(_ sender: AnyObject) {
        
        if let onFeedbackButtonTapped = self.onFeedbackButtonTapped {
            onFeedbackButtonTapped()
        }

    }
    
    
    @IBAction func btnFollowClick(_ sender: AnyObject) {
        
        if let onFollowButtonTapped = self.onFollowButtonTapped {
            onFollowButtonTapped()
        }

    }
    
    
    @IBAction func btnMenuClick(_ sender: AnyObject) {
        
        if let onMenuButtonTapped = self.onHomeMenuButtonTapped {
            onMenuButtonTapped()
        }
        
    }
    
    func showAnimate()
    {
        self.poperView.isHidden = false
        self.poperView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.poperView.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.poperView.alpha = 1.0
            self.poperView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.poperView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.poperView.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.poperView.isHidden = true
                }
        });
    }
    
    
    @IBAction func btnPoperLikeClick(_ sender: AnyObject) {
        
        if let onPoperLikeButtonTapped = self.onPoperLikeButtonTapped {
            onPoperLikeButtonTapped()
        }

        
        removeAnimate()
    }
    
    @IBAction func btnPoperCommentClick(_ sender: AnyObject) {
        
        if let onPoperCommentButtonTapped = self.onPoperCommentButtonTapped {
            onPoperCommentButtonTapped()
        }
        
        removeAnimate()
    
    }
    
    @IBAction func btnPoperContributeClick(_ sender: AnyObject){
        
        if let onPoperContributeButtonTapped = self.onPoperContributeButtonTapped {
            onPoperContributeButtonTapped()
        }
        
        removeAnimate()
    }

    @IBAction func btnPoperRecordClick(_ sender: AnyObject) {
        
        if let onPoperRecordButtonTapped = self.onPoperRecordButtonTapped {
            onPoperRecordButtonTapped()
        }
        
        removeAnimate()
    }

    @IBAction func btnPlayiconClick(_ sender: AnyObject) {
        
        if let onPlayiconTapped = self.onPlayiconTapped {
            onPlayiconTapped()
        }

    }
}
