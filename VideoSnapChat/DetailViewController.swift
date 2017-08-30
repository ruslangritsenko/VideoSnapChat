//
//  DetailViewController.swift
//  VideoSnapChat
//
//  Created by Anton Ivanov on 11/7/16.
//  Copyright © 2016 Ahmed. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtAddComment: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtAddComment.placeholder = "Type Here"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnRecordClick(_ sender: AnyObject) {
        
        let recordingViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "RecordingViewController") as? RecordingViewController
        self.navigationController?.pushViewController(recordingViewControllerObj!, animated: true)
        
    }

    @IBAction func btnFeedbackClick(_ sender: AnyObject) {
        
        
        
    }
    
    @IBAction func btnFollowClick(_ sender: AnyObject) {
        
        
        
    }
    
    @IBAction func btnMenuClick(_ sender: AnyObject) {
        
        
        
    }

    @IBAction func btnSendClick(_ sender: AnyObject) {
        
        txtAddComment.text = ""
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "DetailTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! DetailTableViewCell
        
        cell.txtName.text = "Duke Nukem"
        cell.txtComment.text = "This is so cool! Everytime I look at you guys, I get fired up!!"
        cell.txtTime.text = "4 hours ago"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let identifier = "DetailTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! DetailTableViewCell
        
        
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
