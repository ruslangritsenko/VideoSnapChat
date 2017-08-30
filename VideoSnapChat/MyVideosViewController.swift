//
//  MyVideosViewController.swift
//  VideoSnapChat
//
//  Created by Anton Ivanov on 11/7/16.
//  Copyright © 2016 Ahmed. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase
import AssetsLibrary

class MyVideosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var avPlayerViewController = AVPlayerViewController()
    var videoArray: [NSDictionary] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchingMyVideoFiles()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchingMyVideoFiles()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "MyVideosTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MyVideosTableViewCell
        
        let value = videoArray[indexPath.row]
        cell.txtDescription.text = value["description"] as? String
        cell.txtCreateUserName.text = value["sender_email"] as? String
        
        
        let nameForThumb = value["nameOfThumb"] as? String
        let thumbnailSpaceRef = thumbnailRef.child(nameForThumb!)
        cell.playicon.isHidden = true
        thumbnailSpaceRef.data(withMaxSize: 1 * 1024 * 1024) {(data, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                cell.imageThumbnail.image = UIImage(data: data!)
                cell.playicon.isHidden = false
            }
        }
        
        cell.onButtonTapped = {
            
            labelOfViewControllerCalledRecordingView = 1
            
            
            // get the name of video
            let value = self.videoArray[indexPath.row]
            let fileName = value["name"] as? String
            
            // get the substring
            let index = fileName?.index((fileName?.endIndex)!, offsetBy: -4)
            curInvitedVideoName = (fileName?.substring(to: index!))!
            
            
            let recordingViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "RecordingViewController") as? RecordingViewController
            self.navigationController?.pushViewController(recordingViewControllerObj!, animated: true)
            
        }
        
        cell.onFeedbackButtonTapped = {
            
            print("btnFeebackButtonClick")
        }
        
        cell.onFollowButtonTapped = {
            
            print("btnFollowButtonClick")
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
            
            let recordingViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "RecordingViewController") as? RecordingViewController
            //        self.navigationController?.pushViewController(recordingViewControllerObj!, animated: true)
            
            let transition = CATransition()
            transition.duration = 0.2
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.present(recordingViewControllerObj!, animated: false, completion: nil)
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.avPlayerViewController = AVPlayerViewController()
        
        let identifier = "MyVideosTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MyVideosTableViewCell
        
        let value = videoArray[indexPath.row]
        
        cell.txtDescription.text = value["description"] as? String
        cell.txtCreateUserName.text = value["sender_email"] as? String
        
        
        var videoClips = [URL]()
        
        let strVideoClips = value["downloadURL"]! as! NSDictionary
        
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
    
    
    func fetchingMyVideoFiles() {
        
        self.videoArray.removeAll()
        
        let user_email :String
        user_email = prefs.string(forKey: "myUserEmail")!
        
        //        let videoRef = rootRef.child("videos").queryEqual(toValue: user_email, childKey: "receiver_email")
        let videoRef = rootRef.child("videos")
        videoRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                return
            }
            
            
            for  child in snapshot.children {
                
                let childSnap = child as! FIRDataSnapshot
                let value = childSnap.value as? NSDictionary
                let send_email = value?["sender_email"] as? String
                
                if send_email == user_email{
                    
                    self.videoArray.append(value!)
                    
                    print(value?["name"] as! String)
                    print(child)
                }
                
                
                //                 self.videoCount = self.videoArray.count
            }
            
            self.tableView.reloadData()
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
                
                
                // get the time range of main instruction
                //                let instruction = AVMutableVideoCompositionInstruction()
                //                instruction.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration)
                //
                //
                //                instructions.adding(instruction)
                
                
            } else {
                print("network error")
            }
            
            
            
        }
        
        
        //        mainComposition.instructions = instructions as! [AVMutableVideoCompositionInstruction]
        //        mainComposition.frameDuration = CMTimeMake(Int64(time), 30)
        //        mainComposition.renderSize = CGSize(width: 640, height: 480)
        
        
        //        let pi = AVPlayerItem(asset: composition)
        //        pi.videoComposition = mainComposition
        //
        //         // playing video
        //        self.avPlayerViewController.player = AVPlayer.init(playerItem: pi)
        //
        //        self.present(self.avPlayerViewController, animated: true) {
        //            self.avPlayerViewController.player!.play()
        //        }
        
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
                    
                }
            }
            
            library.writeVideoAtPath(toSavedPhotosAlbum: session.outputURL, completionBlock: completionBlock)
        }
        
        let player = AVPlayer(url: session.outputURL!)
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.present(playerController, animated: true) {
            player.play()
        }
        
        
        
    }
    
    
    @IBAction func btnCancelClick(_ sender: AnyObject) {
//        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
//        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true);

        let transition = CATransition()
        transition.duration = 0.2
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        self.dismiss(animated: false, completion: nil)
    }
    


}
