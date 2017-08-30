//
//  ViewController.swift
//  VideoSnapChat
//
//  Created by Sergey Kulish on 10/15/16.
//  Copyright © 2016 Ahmed. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import OneSignal
//import Google

var rootRef : FIRDatabaseReference!
var storageRef : FIRStorageReference!
var videoRef : FIRStorageReference!
var thumbnailRef : FIRStorageReference!
var avatarRef : FIRStorageReference!
let prefs = UserDefaults.standard


let CON_VIDEOS : String = "con_videos"
let USERS : String = "users"
let VIDEOS : String = "videos"


let THUMBNAILS : String = "thumbnails"
let AVATAR : String = "avatar"
let FOLLOWS : String = "follows"
let FOLLOWYOU : String = "followyou"

let DESCRIPTION : String = "description"
let TAG : String = "tag"
let SENDER_EMAIL : String = "sender_email"
let NAMEOFTHUMB : String = "nameOfThumb"
let DOWNLOADURL : String = "downloadURL"
let RECEIVER_EMAIL : String = "receiver_email"
let NAME : String = "name"
let NOTIUSERID = "notification_uid"
let POSTUSERNAME : String = "postUserName"
let EMAIL : String = "email"
let THUMBNAILURL : String = "thumbnailURL"
let UID : String = "uid"
let CONTRIBUTE_NAME : String = "con_names"

var uid : String = ""

var labelOfViewControllerCalledRecordingView : Int = 0
var curInvitedVideoName : String = ""

var notiUserId: String = ""
var notiToken: String = ""

class LoginViewController: UIViewController {

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnToSignup: UIButton!

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnFacebookLogin: UIButton!
    @IBOutlet weak var btnTwitterLogin: UIButton!
    @IBOutlet weak var btnGoogleLogin: UIButton!
    @IBOutlet weak var viewSocialLogin: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OneSignal.idsAvailable({ (userId, pushToken) in
            print("UserId:%@", userId)
            notiUserId = userId!
            if (pushToken != nil) {
                print("pushToken:%@", pushToken)
                notiToken = pushToken!
            }
        })
        
         rootRef = FIRDatabase.database().reference()
//         storageRef = FIRStorage.storage().reference(forURL: "gs://tubable-176b0.appspot.com")
        storageRef = FIRStorage.storage().reference(forURL: "gs://videosnapchat-83ad2.appspot.com")

         videoRef = storageRef.child(VIDEOS)
         thumbnailRef = storageRef.child(THUMBNAILS)
         avatarRef = storageRef.child(AVATAR)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        txtPassword.isSecureTextEntry = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //-- /////////////////////////////// --
    // facebook login module
    
    @IBAction func btnFacebookLoginClick(_ sender: AnyObject) {
        self.fbLoginInitiate()
        
    }
    
    func fbLoginInitiate() {
       
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        fbLoginManager.loginBehavior = FBSDKLoginBehavior.native
        
        
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self, handler: { (result, error) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                
                if (result! as FBSDKLoginManagerLoginResult).isCancelled == true {
                    
                } else {
                    
                    self.fetchFacebookProfile()
                }
            }
        })    }
    
    func removeFbData() {
        //Remove FB Data
        let fbManager = FBSDKLoginManager()
        fbManager.logOut()
        FBSDKAccessToken.setCurrent(nil)
    }
    
    func fetchFacebookProfile()
    {
        if FBSDKAccessToken.current() != nil {
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                
                if ((error) != nil) {
                    //Handle error
                } else {
                    let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                    
                    FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                        // ...
                        if error != nil {
                            let mainViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
                            self.navigationController?.pushViewController(mainViewControllerObj!, animated: true)
                            return
                        }
                    }
                }
            })
        }
    }
   
    
    //-- twitter login module --
    
    
    
    @IBAction func btnLoginClick(_ sender: AnyObject) {
        
        FIRAuth.auth()?.signIn(withEmail: txtEmail.text!, password: txtPassword.text!){
            (user, error) in
            print(error)
            if (user != nil) {
                
                prefs.setValue(user?.uid, forKey: "myUserUID")
                prefs.setValue(user?.email, forKey: "myUserEmail")
                
                uid = prefs.string(forKey: "myUserUID")!
                
                rootRef.child(USERS).child((user?.uid)!).updateChildValues([NOTIUSERID: notiUserId])
                
                
                let mainViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
                self.navigationController?.pushViewController(mainViewControllerObj!, animated: true)

            } else{
                
            }

        }
        
//        let mainViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
//        self.navigationController?.pushViewController(mainViewControllerObj!, animated: true)

    }
    
    @IBAction func btnToSignupClick(_ sender: AnyObject) {
        
        let signupViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController
        self.navigationController?.pushViewController(signupViewControllerObj!, animated: true)
        
    }

    @IBAction func btnTwitterLoginClick(_ sender: AnyObject) {
        
    }
    
    @IBAction func btnGoogleLoginClick(_ sender: AnyObject) {
        
        
    }
    
    
}

