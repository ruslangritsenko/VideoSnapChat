//
//  SubjectViewController.swift
//  VideoSnapChat
//
//  Created by Anton Ivanov on 11/8/16.
//  Copyright © 2016 Ahmed. All rights reserved.
//
import UIKit
import  Firebase

class SubjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableview: UITableView!
    var videoArray: [NSDictionary] = []
    var filterVideoArray : [NSDictionary] = []
    var txtSearch : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchingMyVideoFiles()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterVideoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "SubjectTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SubjectTableViewCell
        
        let value = videoArray[indexPath.row]
        
        let nameForThumb = value[NAMEOFTHUMB] as? String
        let thumbnailSpaceRef = thumbnailRef.child(nameForThumb!)
        cell.btnPlayicon.isHidden = true
        thumbnailSpaceRef.data(withMaxSize: 1 * 1024 * 1024) {(data, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                cell.imgAvatar.image = UIImage(data: data!)
                cell.btnPlayicon.isHidden = false
            }
        }
        
        cell.txtName.text = value[POSTUSERNAME] as? String
        cell.txtDescription.text = value[DESCRIPTION] as? String
        
        cell.onPlayiconTapped = {
            print("onPlayiconTapped")
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let identifier = "SubjectTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SubjectTableViewCell
        
        
    }
    
    func fetchingMyVideoFiles() {
        
        self.videoArray.removeAll()
        self.filterVideoArray.removeAll()
        
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
            
            if self.txtSearch != "" {
                for video in self.videoArray {
                    let description = video[DESCRIPTION] as? String
                    if ((description?.range(of: self.txtSearch)) != nil) {
                        self.filterVideoArray.append(video)
                    }
                }
            } else {
                self.filterVideoArray = self.videoArray
            }
            
            self.tableview.reloadData()
        })
        
    }
    
}

