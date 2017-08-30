//
//  ProfileViewController.swift
//  VideoSnapChat
//
//  Created by Anton Ivanov on 11/9/16.
//  Copyright © 2016 Ahmed. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgProfileAvatarBG: UIImageView!
    @IBOutlet weak var imgProfileAvatar: UIImageView!
    @IBOutlet weak var txtNumberOfFollowers: UILabel!
    @IBOutlet weak var txtNumberOfFollowings: UILabel!
    @IBOutlet weak var txtNumberOfVideos: UILabel!
    @IBOutlet weak var txtFullName: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    
    let imagePicker = UIImagePickerController()
    
    var username : String = ""
    let numberOfVideos : Int = 0
    var numberOfFollowings : Int = 0
    var numberOfFollowingYou : Int = 0
    var videoArray: [NSDictionary] = []
    var myVideoArray : [NSDictionary] = []
    var avatarName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        
//        imgProfileAvatar.layer.borderWidth = 1
        imgProfileAvatar.layer.masksToBounds = false
        imgProfileAvatar.layer.borderColor = UIColor.black.cgColor
        imgProfileAvatar.layer.cornerRadius = imgProfileAvatar.frame.height/2
        imgProfileAvatar.clipsToBounds = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadUserInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    
    func loadUserInfo(){
        let userRef = rootRef.child(USERS).child(uid)
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                return
            }
            
            for  child in snapshot.children {
                let childSnap = child as! FIRDataSnapshot
                
                if childSnap.key == NAME {
                    self.username = childSnap.value as! String
                    self.txtFullName.text = self.username
                }
                
                if childSnap.key == AVATAR {
                    for avatarChild in childSnap.children {
                        let avatarChildSnap = avatarChild as! FIRDataSnapshot
                        if avatarChildSnap.key == NAME{
                            self.avatarName = avatarChildSnap.value as! String
                            self.loadAvatar(nameForAvatar: self.avatarName)
                        }
                    }
                }
                
                if childSnap.key == FOLLOWS {
                    self.numberOfFollowings = childSnap.children.allObjects.count
                    self.txtNumberOfFollowers.text = String(self.numberOfFollowings)
                }

                if childSnap.key == FOLLOWYOU {
                    self.numberOfFollowingYou = childSnap.children.allObjects.count
                    self.txtNumberOfFollowings.text = String(self.numberOfFollowingYou)
                }
                
                if childSnap.key == VIDEOS {
                    var myVideoNames : [String] = []
                    
                    for videoChild in childSnap.children{
                        let videoChildSnap = videoChild as! FIRDataSnapshot
                        myVideoNames.append(videoChildSnap.value as! String)
                    }
                    
                    self.fetchingMyVideoFiles(myVideoNames: myVideoNames)
                    self.txtNumberOfVideos.text = String(myVideoNames.count)
                }

            }
            
        })

    }
    
    func loadAvatar(nameForAvatar: String){
        let avatarSpaceRef = avatarRef.child(nameForAvatar)
        avatarSpaceRef.data(withMaxSize: 3 * 1024 * 1024) {(data, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                self.imgProfileAvatar.image = UIImage(data: data!)
            }
        }
    }
    
    func fetchingMyVideoFiles(myVideoNames: [String]) {
        
        self.videoArray.removeAll()
        self.myVideoArray.removeAll()
        
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
            
            for name in myVideoNames{
                for video in self.videoArray{
                    if video.value(forKey: NAME) as! String == name {
                        self.myVideoArray.append(video)
                        break
                    }
                }
            }
            
            self.collectionView.reloadData()
            
        })
    }

    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        if myVideoArray.count == 0{
            return 1
        } else {
            return 1
        }
        
     }
    

     func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
//        if myVideoArray.count < 3 {
//            return myVideoArray.count
//        } else{
//            return 3
//
//        }
        return myVideoArray.count
    }
    
   
     func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileVideosCollectionViewCell",
                                                      for: indexPath) as! ProfileVideosCollectionViewCell
        let value = self.myVideoArray[indexPath.row]
        let nameForThumb = value[NAMEOFTHUMB] as? String
        let thumbnailSpaceRef = thumbnailRef.child(nameForThumb!)
        thumbnailSpaceRef.data(withMaxSize: 1 * 1024 * 1024) {(data, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                cell.imgAvatarOfVideo.image = UIImage(data: data!)
            }
        }

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let paddingSpace = sectionInsets.left * (3 + 1)
        let availableWidth = view.frame.width - 20 - paddingSpace
        let widthPerItem = availableWidth / 3
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
  
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
   
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return sectionInsets.top
    }
    
    @IBAction func btnProfileAvatarEditClick(_ sender: AnyObject) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            self.imgProfileAvatarBG.contentMode = .scaleAspectFit
            imgProfileAvatar.image = pickedImage
            
            uploadAvatar(image: pickedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func uploadAvatar(image: UIImage){
        
        // name Avatar file using random date
        let dfWithMilliSeconds = DateFormatter()
        let avatarFileName = String(format: "%d", dfWithMilliSeconds)
        
        var avatarData = Data()
        avatarData = UIImageJPEGRepresentation(image, 0.5)! as Data
        let metadataForAvatar = FIRStorageMetadata()
        metadataForAvatar.contentType = "image/jpg"
        let avatarSpaceRef = avatarRef.child(avatarFileName + ".jpg")
        var downloadURLForAvatar: NSString = ""
        
        _ = avatarSpaceRef.put(avatarData  as Data, metadata: nil) {metadataForAvatar, error in
            if(error == nil){
                downloadURLForAvatar = (metadataForAvatar!.downloadURL()?.absoluteString as NSString?)!
                rootRef.child(USERS).child(uid).child(AVATAR).setValue([NAME: avatarFileName + ".jpg", DOWNLOADURL: downloadURLForAvatar])
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func btnSettingClick(_ sender: AnyObject) {
        
        let settingViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController
//        self.navigationController?.pushViewController(settingViewControllerObj!, animated: true)
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        present(settingViewControllerObj!, animated: false, completion: nil)


        
    }
    
    @IBAction func btnCancelClick(_ sender: AnyObject) {
        
        
        
    }
}
