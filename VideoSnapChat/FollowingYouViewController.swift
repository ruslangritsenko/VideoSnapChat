//
//  FollowingYouViewController.swift
//  VideoSnapChat
//
//  Created by Anton Ivanov on 11/8/16.
//  Copyright © 2016 Ahmed. All rights reserved.
//

import UIKit
import Firebase

class FollowingYouViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var username : String = ""
    let numberOfVideos : Int = 0
    var numberOfFollowings : Int = 0
    var numberOfFollowingYou : Int = 0
    var avatarName: String = ""
    var myVideoNames : [String] = []
    var myFollowingYouUIDs : [String] = []
   
    var FollowingYouArray: [NSDictionary] = []
    var myFollowingYouArray: [NSDictionary] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       self.loadFollowYous()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFollowingYouUIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "FollowingYouTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! FollowingYouTableViewCell
        
        loadUserInfo(cell: cell, index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let identifier = "FollowingYouTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! FollowingYouTableViewCell
        
        
    }
    
    func loadFollowYous(){
        
        myFollowingYouUIDs.removeAll()
        
        let followYouRef = rootRef.child(USERS).child(uid).child(FOLLOWYOU)
        followYouRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                return
            }
            
            for  child in snapshot.children {
                let childSnap = child as! FIRDataSnapshot
                var userID: String = ""
                for child2 in childSnap.children {
                    let childSnap2 = child2 as! FIRDataSnapshot
                    if UID == childSnap2.key {
                        userID = childSnap2.value as! String
                    }
                }

                self.myFollowingYouUIDs.append(userID)
                
            }
            
            self.fetchFollowYouInfos()
        })
    }

    func fetchFollowYouInfos() {
        
        self.FollowingYouArray.removeAll()

        let userRef = rootRef.child(USERS)
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                return
            }
            
            
            for  child in snapshot.children {
                
                let childSnap = child as! FIRDataSnapshot
                let value = childSnap.value as? NSDictionary
                
                self.FollowingYouArray.append(value!)
                
            }
            
            for childUID in self.myFollowingYouUIDs {
                for childFollowingYouInfo in self.FollowingYouArray {
                    if childUID == childFollowingYouInfo[UID] as? String {
                        self.myFollowingYouArray.append(childFollowingYouInfo)
                        break
                    }
                }
            }

            self.tableView.reloadData()
            
        })

    }

    func loadUserInfo(cell : FollowingYouTableViewCell, index: Int){
        cell.txtName.text = self.myFollowingYouArray[index][NAME] as? String
        
        if self.myFollowingYouArray[index][VIDEOS] != nil{
            var myVideoArray: NSDictionary = [:]
            myVideoArray = self.myFollowingYouArray[index][VIDEOS] as! NSDictionary
            cell.txtNumberOfVideos.text = String(myVideoArray.count)
        } else {
            
        }
        
        if self.myFollowingYouArray[index][AVATAR] != nil{
            let avatarDic = self.myFollowingYouArray[index][AVATAR] as! NSDictionary
            let nameForAvatar = avatarDic.value(forKey: NAME) as! String
            let avatarSpaceRef = avatarRef.child(nameForAvatar)
            
            avatarSpaceRef.data(withMaxSize: 3 * 1024 * 1024) {(data, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    cell.imgAvatar.image = UIImage(data: data!)
                
                }
            }
            
        
        }

    }

    
}
