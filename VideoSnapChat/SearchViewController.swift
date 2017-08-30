//
//  SearchViewController.swift
//  VideoSnapChat
//
//  Created by Anton Ivanov on 11/8/16.
//  Copyright © 2016 Ahmed. All rights reserved.
//

import UIKit
import CarbonKit



class SearchViewController: UIViewController, CarbonTabSwipeNavigationDelegate, UISearchBarDelegate {

    var items = NSArray()
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    
    var searchBar : UISearchBar?
    var searchActive : Bool = false
    
    var currentVCID : String = ""
    
    var topicVC: TopicsViewController!
    var tagsVC: TagsViewController!
    var subjectVC: SubjectViewController!
    var peopleVC: PeopleViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 50, height: 30))
        searchBar?.placeholder = "Search"
        
        searchBar?.delegate = self

        let leftNavBarButton = UIBarButtonItem(customView:searchBar!)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        

        items = ["Topics", "Tags", "Subject", "People"]
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items as [AnyObject], delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        
        self.style()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
        searchBar?.addGestureRecognizer(tap)
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        searchBar.text = ""
        if currentVCID == "TopicsViewController" {
            topicVC.txtSearch = searchBar.text!
            topicVC.fetchingMyVideoFiles()
        }
        
        if currentVCID == "TagsViewController" {
            tagsVC.txtSearch = searchBar.text!
            tagsVC.fetchingMyVideoFiles()
        }
        
        if currentVCID == "SubjectViewController" {
            subjectVC.txtSearch = searchBar.text!
            subjectVC.fetchingMyVideoFiles()
        }
        
        if currentVCID == "PeopleViewController" {
            peopleVC.txtSearch = searchBar.text!
            peopleVC.fetchingMyVideoFiles()
        }

    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchActive = false;
        
        if currentVCID == "TopicsViewController" {
            topicVC.txtSearch = searchBar.text!
            topicVC.fetchingMyVideoFiles()
        }
        
        if currentVCID == "TagsViewController" {
            tagsVC.txtSearch = searchBar.text!
            tagsVC.fetchingMyVideoFiles()
        }
        
        if currentVCID == "SubjectViewController" {
            subjectVC.txtSearch = searchBar.text!
            subjectVC.fetchingMyVideoFiles()
        }
        
        if currentVCID == "PeopleViewController" {
            peopleVC.txtSearch = searchBar.text!
            peopleVC.fetchingMyVideoFiles()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
       
    }

    
    func btnBackClick(){
        
    }
    
    func dismissKeyboard() {
        searchBar?.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func style() {
        
        let color: UIColor = UIColor(red: 0.15, green: 0.61, blue: 1.00, alpha: 1)
//        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.white
//        self.navigationController!.navigationBar.barTintColor = color
//        self.navigationController!.navigationBar.barStyle = .blackTranslucent
        carbonTabSwipeNavigation.toolbar.isTranslucent = false
        carbonTabSwipeNavigation.setIndicatorColor(color)
        carbonTabSwipeNavigation.setTabExtraWidth(30)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(100, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(100, forSegmentAt: 1)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(100, forSegmentAt: 2)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(100, forSegmentAt: 3)
        
        carbonTabSwipeNavigation.setNormalColor(UIColor.black.withAlphaComponent(0.6))
        carbonTabSwipeNavigation.setSelectedColor(color, font: UIFont.boldSystemFont(ofSize: 14))
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        switch index {
        case 0:
            self.topicVC = self.storyboard!.instantiateViewController(withIdentifier: "TopicsViewController") as? TopicsViewController
            currentVCID = "TopicsViewController"
            return topicVC!
        case 1:
            self.tagsVC = self.storyboard!.instantiateViewController(withIdentifier: "TagsViewController") as? TagsViewController
            currentVCID = "TagsViewController"
            return tagsVC!
        case 2:
            self.subjectVC = self.storyboard!.instantiateViewController(withIdentifier: "SubjectViewController") as? SubjectViewController
            currentVCID = "SubjectViewController"
            return subjectVC!
        default:
            self.peopleVC = self.storyboard!.instantiateViewController(withIdentifier: "PeopleViewController") as? PeopleViewController
            currentVCID = "PeopleViewController"
            return peopleVC!
        }
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        NSLog("Did move at index: %ld", index)
        switch index {
        case 0:
            currentVCID = "TopicsViewController"
        case 1:
            currentVCID = "TagsViewController"
        case 2:
            currentVCID = "SubjectViewController"
        default:
            currentVCID = "PeopleViewController"
        }

    }

}
