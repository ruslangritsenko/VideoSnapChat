//
//  SignupViewController.swift
//  VideoSnapChat
//
//  Created by Sergey Kulish on 10/15/16.
//  Copyright © 2016 Ahmed. All rights reserved.
//

import UIKit
import Firebase
import OneSignal

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!

    @IBOutlet weak var btnToLogin: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    
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
        storageRef = FIRStorage.storage().reference(forURL: "gs://videosnapchat-83ad2.appspot.com")
        videoRef = storageRef.child(VIDEOS)
        thumbnailRef = storageRef.child(THUMBNAILS)

        
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initialize(){
        
        
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtPassword.isSecureTextEntry = true
        txtFullName.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func btnToLoginClick(_ sender: AnyObject) {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true);
    }
    
    @IBAction func btnSignupClick(_ sender: AnyObject) {
        
        if (txtEmail.text != "") && (txtPassword.text != "") && (txtFullName.text != "") {
            
            FIRAuth.auth()?.createUser(withEmail: txtEmail.text!, password: txtPassword.text!){
                (user, error) in
                let userID : String = (user?.uid)!
                
                rootRef.child(USERS).child((user?.uid)!).setValue([NAME: self.txtFullName.text!])
                rootRef.child(USERS).child((user?.uid)!).updateChildValues([UID: userID])
                rootRef.child(USERS).child((user?.uid)!).updateChildValues([EMAIL: self.txtEmail.text!])
                
                 rootRef.child(USERS).child((user?.uid)!).updateChildValues([NOTIUSERID: notiUserId])
    
                prefs.setValue(user?.uid, forKey: "myUserUID")
                prefs.setValue(user?.email, forKey: "myUserEmail")
                prefs.setValue(user?.displayName, forKey: "myFullName")
                
                let mainViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
                self.navigationController?.pushViewController(mainViewControllerObj!, animated: true)
                
            }

        }
    }
    
    @IBAction func userTappedBackground(sender: AnyObject) {
        txtFullName.resignFirstResponder()
        txtPassword.resignFirstResponder()
        txtEmail.resignFirstResponder()
    }

    
}
