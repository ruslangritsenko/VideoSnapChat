//
//  ProfileViewController.swift
//  VideoSnapChat
//
//  Created by Sergey Kulish on 10/20/16.
//  Copyright © 2016 Ahmed. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!

    
    var datasource : NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       datasource = ["Invite by email", "Invite from facebook", "Push Notification", "Email Notification", "About Us", "Prevacy Policy", "Term & Conditions", "Logout", ""]
       tableview.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableview.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 2 || indexPath.row == 3 {
            
            let identifier = "SettingToggleTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SettingToggleTableViewCell
            
            cell.txtName.text = datasource.object(at: indexPath.row) as? String
            
            return cell
        } else if (indexPath.row == 8) {
            
            let identifier = "SettingLastTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SettingLastTableViewCell
            
           
            
            return cell

            
        }  else {
            
            let identifier = "ProfileCommonTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ProfileCommonTableViewCell
            
            cell.txtName.text = datasource.object(at: indexPath.row) as? String
            
            return cell
       
        }
        
        

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row == datasource.count - 2) {
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "windowRootController") as! WindowRootController
            UIApplication.shared.keyWindow?.rootViewController = viewController;
            
            
            try! FIRAuth.auth()?.signOut()
        }
        
        if (indexPath.row == 0) {
            
            let invitaionViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "InvitationViewController") as? InvitationViewController
//            self.navigationController?.pushViewController(invitaionViewControllerObj!, animated: true)
            
            let transition = CATransition()
            transition.duration = 0.2
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            view.window!.layer.add(transition, forKey: kCATransition)
            present(invitaionViewControllerObj!, animated: false, completion: nil)
        }
        
        if (indexPath.row == 1) {
            
//            let myVideosViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "MyVideosViewController") as? MyVideosViewController
////            self.navigationController?.pushViewController(myVideosViewControllerObj!, animated: true)
//            
//            let transition = CATransition()
//            transition.duration = 0.2
//            transition.type = kCATransitionPush
//            transition.subtype = kCATransitionFromRight
//            view.window!.layer.add(transition, forKey: kCATransition)
//            present(myVideosViewControllerObj!, animated: false, completion: nil)
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
