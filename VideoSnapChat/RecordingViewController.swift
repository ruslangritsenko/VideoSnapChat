//
//  RecordingViewController.swift
//  VideoSnapChat
//
//  Created by Anton Ivanov on 10/28/16.
//  Copyright © 2016 Ahmed. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit
import AVFoundation
import Firebase
import OneSignal

var selVideoData : NSData! = nil
var avatarDataOfSelVideo : UIImage! = nil

class RecordingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    @IBOutlet weak var txtAddFriend: UITextField!
    @IBOutlet weak var imgAddVideo: UIImageView!
    @IBOutlet weak var saveIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imgThumbnailView: UIImageView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var txtAddFriends: UILabel!
    @IBOutlet weak var txtTag: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var videoRecView: UIView!
    
    var vData : NSData!
    var imgThumbnail : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // imagePicker.delegate = self
        self.txtDescription.delegate = self
        txtDescription.text = "Enter Description Here"
        txtDescription.textColor = UIColor.lightGray
        
        self.txtTag.placeholder = "Insert tags"
        self.txtAddFriend.placeholder = "Add your friends you want to contribute"
        
        self.saveIndicator.hidesWhenStopped = true
        
//        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.videoRecord (_:)))
//        self.imgAddVideo.addGestureRecognizer(gesture)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if selVideoData != nil {
            self.imgThumbnailView.image = avatarDataOfSelVideo
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func btnAddVideoClick(_ sender: AnyObject) {
        
//        self.videoRecord()
        
        let recordViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "RecordViewController") as? RecordViewController
        //       let recordingViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "RecordingViewController") as? RecordingViewController
        //        self.navigationController?.pushViewController(recordingViewControllerObj!, animated: true)
        
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        present(recordViewControllerObj!, animated: false, completion: nil)
        
    }
    
    @IBAction func btnAddFriendsClick(_ sender: AnyObject) {
        
        
    }
   
    @IBAction func btnCancelClick(_ sender: AnyObject) {
        
        self.back()
    }
    
    @IBAction func btnDoneClick(_ sender: AnyObject) {
        
        if selVideoData != nil {
            vData = selVideoData
            self.imgThumbnail = avatarDataOfSelVideo
        }
        
        
        view.endEditing(true)
        if (txtAddFriend.text != "") && (txtDescription.text != "") && (txtTag.text != "") && (vData != nil) {
            
            saveIndicator.startAnimating()
            saveIndicator.hidesWhenStopped = false
            
            // name video file using random date
            let dfWithMilliSeconds = DateFormatter()
            let videoFileName = String(format: "%d", dfWithMilliSeconds)
            
            // for Video
            let metadata = FIRStorageMetadata()
            metadata.contentType = "video/mpeg"
            let videoSpaceRef = videoRef.child(videoFileName + ".mp4")
            
            // for Thumbnail
            var thumbData = Data()
            thumbData = UIImageJPEGRepresentation(self.imgThumbnail, 0.8)! as Data
            let metadataForThumb = FIRStorageMetadata()
            metadataForThumb.contentType = "image/jpg"
            let thumbSpaceRef = thumbnailRef.child(videoFileName + ".jpg")
            var downloadURLForThumb: NSString = ""
            
            // upload thumbnail image to  path "thumbnails/'name'.jpg" on firebase
            _ = thumbSpaceRef.put(thumbData  as Data, metadata: nil) {metadataForThumb, error in
                if(error == nil){
                    downloadURLForThumb = (metadataForThumb!.downloadURL()?.absoluteString as NSString?)!
                    
                    // Upload the file to the path "videos/'video file name'.mp4" on firebase
                    _ = videoSpaceRef.put(self.vData as Data, metadata: nil) { metadata, error in
                        if (error != nil) {
                            // Uh-oh, an error occurred!
                        } else {
                            // Metadata contains file metadata such as size, content-type, and download URL.
                            let downloadURL: NSString = (metadata!.downloadURL()?.absoluteString as NSString?)!
                            
                            let user_email :String
                            user_email = prefs.string(forKey: "myUserEmail")!
                            let uid : String
                            uid = prefs.string(forKey: "myUserUID")!
                         
                            
                            // upload video file data to Firebase db
                            if labelOfViewControllerCalledRecordingView == 0 {
                                
                                rootRef.child(CON_VIDEOS).child((videoFileName)).setValue([NAME: videoFileName + ".mp4" ,SENDER_EMAIL: user_email,DESCRIPTION:self.txtDescription.text!, RECEIVER_EMAIL: self.txtAddFriend.text!, DOWNLOADURL : downloadURL, THUMBNAILURL : downloadURLForThumb, NAMEOFTHUMB : videoFileName + ".jpg"])
                                rootRef.child(VIDEOS).child((videoFileName)).setValue([NAME: videoFileName + ".mp4" ,SENDER_EMAIL: user_email,DESCRIPTION:self.txtDescription.text!, RECEIVER_EMAIL: self.txtAddFriend.text!, THUMBNAILURL : downloadURLForThumb, NAMEOFTHUMB : videoFileName + ".jpg"])
                                rootRef.child(VIDEOS).child((videoFileName)).child(DOWNLOADURL).setValue([videoFileName : downloadURL])
                                rootRef.child(VIDEOS).child((videoFileName)).child(CONTRIBUTE_NAME).setValue([videoFileName : user_email])
                                rootRef.child(USERS).child(uid).child(VIDEOS).updateChildValues([videoFileName: videoFileName + ".mp4"])
                                
                            } else if labelOfViewControllerCalledRecordingView == 1{
                                
                                rootRef.child(CON_VIDEOS).child((videoFileName)).setValue([NAME: videoFileName + ".mp4" ,SENDER_EMAIL: user_email,DESCRIPTION:self.txtDescription.text!, RECEIVER_EMAIL: self.txtAddFriend.text!, DOWNLOADURL : downloadURL, THUMBNAILURL : downloadURLForThumb, NAMEOFTHUMB : videoFileName + ".jpg"])
                                
                                rootRef.child(VIDEOS).child((curInvitedVideoName)).updateChildValues([SENDER_EMAIL: user_email, RECEIVER_EMAIL: self.txtAddFriend.text!])
                                rootRef.child(VIDEOS).child(curInvitedVideoName).child(DOWNLOADURL).updateChildValues([videoFileName : downloadURL])
                                self.isExistInContributeNames(cur_email: user_email, videoFileName: videoFileName)
                                
                                
                            }
                            
                            
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
                                    let noti_uid = (value?[NOTIUSERID] as? String)!
                                    
                                    if email == self.txtAddFriend.text! {
                                        OneSignal.postNotification(["contents": ["en": "Test Message"], "include_player_ids": [noti_uid]])
                                        self.initView()
                                        
                                        self.saveIndicator.stopAnimating()
                                        self.saveIndicator.hidesWhenStopped = true

                                        break
                                    }
                                }
                            })

                        
                        self.back()
                            
                        }
                    }
                    
                } else {
                }
            }
            
            
        }
        
    }
    
    func initView(){
        
        selVideoData = nil
        avatarDataOfSelVideo = nil
        self.imgThumbnailView.image = nil
        self.txtDescription.text = ""
        self.txtTag.text = ""
        self.txtAddFriend.text = ""

    }
    
    func isExistInContributeNames(cur_email : String, videoFileName: String) {
        
        var isExistCurEmail: Bool = false
       
        let conNameRef = rootRef.child(VIDEOS).child(curInvitedVideoName).child(CONTRIBUTE_NAME)
        conNameRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                return
            }
            
            
            for  child in snapshot.children {
                
                let childSnap = child as! FIRDataSnapshot
                let value = childSnap.value as? String
                
                if value == cur_email {
                    isExistCurEmail = true
                    break
                }
                
            }
            
            if !isExistCurEmail {
                rootRef.child(VIDEOS).child(curInvitedVideoName).child(CONTRIBUTE_NAME).updateChildValues([videoFileName : cur_email])
            }
            
        })
    
    }

    
    
    func videoRecord(){
        
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.allowsEditing = false
                imagePicker.delegate = self
                
                
                present(imagePicker!, animated: true, completion: {})
            } else {
                //postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
            }
        } else {
            //postAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
        
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "Placeholder"
//            textView.textColor = UIColor.lightGray
//        }
//    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    
    // Finished recording a video
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Got a video")
        
        let saveFileName = "/myvideo"
        
        if let pickedVideo:NSURL = (info[UIImagePickerControllerMediaURL] as? NSURL) {
            // Save video to the main photo album
            
            print(pickedVideo)
            
            let selectorToCall = #selector(self.videoWasSavedSuccessfully(video:didFinishSavingWithError:context:))
            UISaveVideoAtPathToSavedPhotosAlbum(pickedVideo.relativePath!, self, selectorToCall, nil)
            
            // Save the video to the app directory so we can play it later
            let videoData = NSData(contentsOf: pickedVideo as URL)
            imgThumbnail = self.thumbnailForVideoAtURL(url: pickedVideo)
            self.imgThumbnailView.image = imgThumbnail
            vData = videoData
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths.first
            let dataPath = documentsDirectory?.appending(saveFileName as String)
            videoData?.write(toFile: dataPath!, atomically: false)
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
        imagePicker.dismiss(animated: true, completion: {
            // Anything you want to happen when the user saves an video
        })
    }
    
    // Called when the user selects cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("User canceled image")
        dismiss(animated: true, completion: {
            // Anything you want to happen when the user selects cancel
        })
    }
    
    // Any tasks you want to perform after recording a video
    func videoWasSavedSuccessfully(video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutablePointer<()>){
        print("Video saved")
        if let theError = error {
            print("An error happened while saving the video = \(theError)")
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
                // What you want to happen
            })
        }
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -150
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    //    func keyboardWasShown(notification: NSNotification) {
    //        let info = notification.userInfo!
    //        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    //
    //        UIView.animate(withDuration: 0.1, animations: { () -> Void in
    //            self.superViewBottomConstraint.constant = keyboardFrame.size.height + 20
    //        })
    //    }
    
    private func thumbnailForVideoAtURL(url: NSURL) -> UIImage?{
        let asset = AVAsset(url: url as URL)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        var time = asset.duration
        
        time.value = min(time.value, 2)
        
        do{
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch{
            print("error")
            return nil
        }
    }
    
    private func back(){
//        if labelOfViewControllerCalledRecordingView == 0 {
//            
//            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
//            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true);
//            
//            
//        } else if labelOfViewControllerCalledRecordingView == 1{
//            
//            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
//            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true);
//        }
        
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        self.dismiss(animated: false, completion: nil)
        

    }
    
}
