//
//  HomeViewController.swift
//  VideoSnapChat
//
//  Created by Sergey Kulish on 10/15/16.
//  Copyright © 2016 Ahmed. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase
import AssetsLibrary

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var avPlayerViewController = AVPlayerViewController()
    
    var videoArray: [NSDictionary] = []
    var followArray: [NSDictionary] = []
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        self.fetchingMyVideoFiles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "HomeVideoTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! HomeVideoTableViewCell
        
        let value = videoArray[indexPath.row]
        cell.txtDescription.text = value[DESCRIPTION] as? String
        cell.txtPostingFriendName.text = value[SENDER_EMAIL] as? String
        
    
        let nameForThumb = value[NAMEOFTHUMB] as? String
        let thumbnailSpaceRef = thumbnailRef.child(nameForThumb!)
        cell.playicon.isHidden = true
        thumbnailSpaceRef.data(withMaxSize: 1 * 1024 * 1024) {(data, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                cell.imgThumbnail.image = UIImage(data: data!)
                cell.playicon.isHidden = false
            }
        }
        
        cell.onFeedbackButtonTapped = {
            print("btnFeebackButtonClick")
        }
        
        cell.onFollowButtonTapped = {
            let sender_email : String
            sender_email = (value[SENDER_EMAIL] as? String)!
            
            let receiver_email : String
            receiver_email = (value[RECEIVER_EMAIL] as? String)!
            
            let user_email = prefs.string(forKey: "myUserEmail")!
            
            if sender_email != user_email {
                let usersRef = rootRef.child(USERS)
                usersRef.observeSingleEvent(of: .value, with: { snapshot in
                    if !snapshot.exists() {
                        return
                    }
                
                    var child_sender_uid : String = ""
                    var child_sender_email : String = ""
                    for  child in snapshot.children {
                        let childSnap = child as! FIRDataSnapshot
                        for child2 in childSnap.children {
                            let childSnap2 = child2 as! FIRDataSnapshot
                            if EMAIL == childSnap2.key {
                                child_sender_uid = childSnap.key
                                child_sender_email = childSnap2.value as! String
                            }
                        }
                        
                        if child_sender_email == sender_email {
                            self.setFollows(sender_email: sender_email, sender_uid: child_sender_uid, receiver_email: receiver_email)
                        }
                    }
                    
                })
                
                self.setFollowingYou(sender_email: sender_email, user_email: user_email)
            }
            
        }
        
        cell.onHomeMenuButtonTapped = {
            cell.showAnimate()
        }
        
        cell.onPoperLikeButtonTapped = {
            print("onPoperLikeButtonTapped")
        }
        
        cell.onPoperCommentButtonTapped = {
            let recordingViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
            //        self.navigationController?.pushViewController(recordingViewControllerObj!, animated: true)
            
            let transition = CATransition()
            transition.duration = 0.2
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.present(recordingViewControllerObj!, animated: false, completion: nil)
        }
        
        cell.onPoperContributeButtonTapped = {
           print("onPoperContributeButtonTapped")
        }
        
        cell.onPoperRecordButtonTapped = {
            labelOfViewControllerCalledRecordingView = 1
            
            // get the name of video
            let value = self.videoArray[indexPath.row]
            let fileName = value["name"] as? String
            
            // get the substring
            let index = fileName?.index((fileName?.endIndex)!, offsetBy: -4)
            curInvitedVideoName = (fileName?.substring(to: index!))!
            
            let recordingViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "RecordingViewController") as? RecordingViewController
            //        self.navigationController?.pushViewController(recordingViewControllerObj!, animated: true)
            
            let transition = CATransition()
            transition.duration = 0.2
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.present(recordingViewControllerObj!, animated: false, completion: nil)
        }
        
        cell.onPlayiconTapped = {
            self.avPlayerViewController = AVPlayerViewController()
            var videoClips = [URL]()
            
            let strVideoClips = value[DOWNLOADURL]! as! NSDictionary
            
            for strVideoClip in strVideoClips {
                let strUrl = strVideoClip.value
                let downloadURL = URL(string: strUrl as! String)
                videoClips.append(downloadURL!)
            }
            
            if videoClips.count == 1 {
                
                var avPlayer: AVPlayer? = nil
                avPlayer = AVPlayer(url : videoClips.first!)
                self.avPlayerViewController.player = avPlayer
                
                self.present(self.avPlayerViewController, animated: true) {
                    self.avPlayerViewController.player!.play()
                }
                
                
            } else {
                self.mergeVideoClips(videoClips: videoClips)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let urlpath     = Bundle.main.path(forResource: "IMG_2264", ofType: "MOV")
//        let url         = NSURL.fileURL(withPath: urlpath!)
        
        
        
//        let identifier = "HomeVideoTableViewCell"
//        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! HomeVideoTableViewCell

//        let value = videoArray[indexPath.row]
//        
//        cell.txtDescription.text = value["description"] as? String
//        cell.txtPostingFriendName.text = value["sender_email"] as? String
        
//        self.avPlayerViewController = AVPlayerViewController()
//        var videoClips = [URL]()
//        
//        let strVideoClips = value["downloadURL"]! as! NSDictionary
//        
//        for strVideoClip in strVideoClips {
//            let strUrl = strVideoClip.value
//            let downloadURL = URL(string: strUrl as! String)
//            videoClips.append(downloadURL!)
//        }
//        
//        
//        if videoClips.count == 1 {
//            
//            var avPlayer: AVPlayer? = nil
//            avPlayer = AVPlayer(url : videoClips.first!)
//            self.avPlayerViewController.player = avPlayer
//            
//            self.present(self.avPlayerViewController, animated: true) {
//                self.avPlayerViewController.player!.play()
//            }
//            
//            
//        } else {
//            self.mergeVideoClips(videoClips: videoClips)
//        }
        
    }
    
    
    func fetchingMyVideoFiles() {
        
        self.videoArray.removeAll()
        
        let videoRef = rootRef.child(VIDEOS)
        videoRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                return
            }
            
           
            for  child in snapshot.children {
               
                let childSnap = child as! FIRDataSnapshot
                let value = childSnap.value as? NSDictionary
                
                self.videoArray.append(value!)
                
            }
            
            self.tableview.reloadData()
        })
        
    }
    

    func setFollows(sender_email : String,sender_uid: String, receiver_email : String){
        let uid :String
        uid = prefs.string(forKey: "myUserUID")!
        
        let dfWithMilliSeconds = DateFormatter()
        let followID = String(format: "%d", dfWithMilliSeconds)
        
        self.setFollowings(uid: uid, followID: followID, sender_email: sender_email, sender_uid: sender_uid)
        
    }
    
    func setFollowings(uid: String, followID: String, sender_email: String, sender_uid: String){
        var existKey : String = ""
        var isFollowExist : Bool = false
        
        let followRef = rootRef.child(USERS).child(uid).child(FOLLOWS)
        followRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                rootRef.child(USERS).child(uid).child((FOLLOWS)).child(followID).updateChildValues([EMAIL: sender_email, UID: sender_uid])
            } else {
                for  child in snapshot.children {
                    let childSnap = child as! FIRDataSnapshot
                    
//                    let follow_email = childSnap.value as! String
                    existKey = childSnap.key
                    
                    var child_sender_email : String = ""
                    for  child in snapshot.children {
                        let childSnap = child as! FIRDataSnapshot
                        for child2 in childSnap.children {
                            let childSnap2 = child2 as! FIRDataSnapshot
                            if EMAIL == childSnap2.key {
                                child_sender_email = childSnap2.value as! String
                            }
                        }
                        
                        if child_sender_email == sender_email {
                            isFollowExist = true
                            break
                        }
                    }
                }
                
                if !isFollowExist{
                    rootRef.child(USERS).child(uid).child((FOLLOWS)).child(followID).updateChildValues([EMAIL: sender_email, UID: sender_uid])
                } else {
                    rootRef.child(USERS).child(uid).child((FOLLOWS)).child(existKey).removeValue()
                }
                
            }
            
        })

    }
    
    
    func setFollowingYou(sender_email: String, user_email: String){
        
        let dfWithMilliSeconds = DateFormatter()
        let followID = String(format: "%d", dfWithMilliSeconds)
        
        let  usersRef = rootRef.child(USERS)
        usersRef.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() {
               return
            }
            
            for  child in snapshot.children {
                let childSnap = child as! FIRDataSnapshot
                let value = childSnap.value as? NSDictionary
                let email = (value?[EMAIL] as? String)!
                let userID = childSnap.key as? String
                
                if email == sender_email {
                    self.setFollowingYouWithUID(userID: userID!, followID: followID, user_email: user_email)
                    break
                }
            }
        })
    }
    
    func setFollowingYouWithUID(userID: String, followID: String, user_email: String){
        var existKey : String = ""
        var isFollowYouExist : Bool = false

        let followRef = rootRef.child(USERS).child(userID).child(FOLLOWYOU)
        followRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                rootRef.child(USERS).child(userID).child((FOLLOWYOU)).child(followID).updateChildValues([EMAIL: user_email, UID: uid])
            } else {
                for  child in snapshot.children {
                    let childSnap = child as! FIRDataSnapshot
                    
                    
                    existKey = childSnap.key
                    
                    var child_follow_email : String = ""
                    for  child in snapshot.children {
                        let childSnap = child as! FIRDataSnapshot
                        for child2 in childSnap.children {
                            let childSnap2 = child2 as! FIRDataSnapshot
                            if EMAIL == childSnap2.key {
                                child_follow_email = childSnap2.value as! String
                            }
                        }
                        
                        if child_follow_email == user_email {
                            isFollowYouExist = true
                            break
                        }
                    }
                }
                
                if !isFollowYouExist{
                    rootRef.child(USERS).child(userID).child((FOLLOWYOU)).child(followID).updateChildValues([EMAIL: user_email, UID: uid])
                } else {
                    rootRef.child(USERS).child(userID).child((FOLLOWYOU)).child(existKey).removeValue()
                }
                
            }
            
        })
        
    }

    
    func mergeVideoClips(videoClips : [URL]){
        
        let composition = AVMutableComposition()
        
        let videoTrack = composition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)
        let audioTrack = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        var time:Double = 0.0
     
        
//        let mainComposition = AVMutableVideoComposition()
//        let instructions : NSArray = []
        
        for video in videoClips {
            
            // init asset using url
            let asset = AVAsset.init(url: video)
            
            // get the tracks of video and audio
            let videoAssetTracks = asset.tracks(withMediaType: AVMediaTypeVideo)
            print(videoAssetTracks)
            
            if videoAssetTracks.count != 0 {
                let videoAssetTrack = videoAssetTracks[0]
                let audioAssetTrack = asset.tracks(withMediaType: AVMediaTypeAudio)[0]
                
                let atTime = CMTime(seconds: time, preferredTimescale:1)
                do{
                    try videoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, asset.duration) , of: videoAssetTrack, at: atTime)
                    try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, asset.duration) , of: audioAssetTrack, at: atTime)
                    
                }catch{
                    print("something bad happend I don't want to talk about it")
                }
                time +=  asset.duration.seconds
                

            } else {
                print("network error")
            }
            
            
 
        }
        
       

        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        let date = dateFormatter.string(from: NSDate() as Date)
        let savePath = "\(directory)/mergedVideo-\(date).mp4"
        let url = NSURL(fileURLWithPath: savePath)
        
        let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        exporter?.outputURL = url as URL
        exporter?.shouldOptimizeForNetworkUse = true
        exporter?.outputFileType = AVFileTypeMPEG4
        
        
        exporter?.exportAsynchronously(completionHandler: { () -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.finalExportCompletion(session: exporter!)
            })
            
        })

        
    }
    
    
    func finalExportCompletion(session: AVAssetExportSession) {
        let library = ALAssetsLibrary()
        if library.videoAtPathIs(compatibleWithSavedPhotosAlbum: session.outputURL) {
            var completionBlock: ALAssetsLibraryWriteVideoCompletionBlock
            
            completionBlock = { assetUrl, error in
                if error != nil {
                    print("error writing to disk")
                } else {
                    print("video save success!")
                }
            }
            
            library.writeVideoAtPath(toSavedPhotosAlbum: session.outputURL, completionBlock: completionBlock)
        }
        
        print("playing video")
        let player = AVPlayer(url: session.outputURL!)
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.present(playerController, animated: true) {
            player.play()
        }
        
        
    }
    
    @IBAction func btnRecordClick(_ sender: AnyObject) {
        
        labelOfViewControllerCalledRecordingView = 0
        
        let myvideoViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "MyVideosViewController") as? MyVideosViewController
 //       let recordingViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "RecordingViewController") as? RecordingViewController
//        self.navigationController?.pushViewController(recordingViewControllerObj!, animated: true)
        
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        present(myvideoViewControllerObj!, animated: false, completion: nil)
//        present(recordingViewControllerObj!, animated: false, completion: nil)

    }
    
    func followWithEmail(friendEmail: String) -> Void {
        
//          rootRef.child(USERS).child((videoFileName)).setValue(["name": videoFileName + ".mp4" ,"sender_email": user_email,"description":self.txtDescription.text!, "receiver_email": self.txtAddFriend.text!, "downloadURL" : downloadURL, "thumbnailURL" : downloadURLForThumb, "nameOfThumb" : videoFileName + ".jpg"])
    }
    
}
