//
//  RecordViewController.swift
//  VideoSnapChat
//
//  Created by Sergey Kulish on 10/15/16.
//  Copyright © 2016 Ahmed. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit
import AVFoundation
import Firebase

class RecordViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
     let imagePicker: UIImagePickerController! = UIImagePickerController()
    
     override func viewDidLoad() {
        super.viewDidLoad()

    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func btnGalleryClick(_ sender: AnyObject) {
        
        self.selectingFromGallery()
    }
    
    func selectingFromGallery(){
        
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                
                imagePicker.sourceType = .photoLibrary
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
    
    @IBAction func btnRecordClick(_ sender: AnyObject) {
        
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
            avatarDataOfSelVideo = self.thumbnailForVideoAtURL(url: pickedVideo)
            selVideoData = videoData
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
    
    @IBAction func btnCancelClick(_ sender: AnyObject) {
        
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        self.dismiss(animated: false, completion: nil)
    }

}
