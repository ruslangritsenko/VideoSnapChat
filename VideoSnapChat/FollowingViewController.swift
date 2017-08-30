//
//  FollowingViewController.swift
//  VideoSnapChat
//
//  Created by Anton Ivanov on 11/8/16.
//  Copyright © 2016 Ahmed. All rights reserved.
//

import UIKit
import CarbonKit

class FollowingViewController: UIViewController, CarbonTabSwipeNavigationDelegate{

    var items = NSArray()
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        items = ["Following You", "You are Following"]
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items as [AnyObject], delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        
        self.style()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func style() {
        
        let color: UIColor = UIColor(red: 0.15, green: 0.61, blue: 1.00, alpha: 1)
//        self.navigationController!.navigationBar.isTranslucent = false
//        self.navigationController!.navigationBar.tintColor = UIColor.white
//        self.navigationController!.navigationBar.barTintColor = color
//        self.navigationController!.navigationBar.barStyle = .blackTranslucent
        self.navigationController!.navigationBar.barTintColor = UIColor.white
        carbonTabSwipeNavigation.toolbar.isTranslucent = false
        carbonTabSwipeNavigation.setIndicatorColor(color)
        carbonTabSwipeNavigation.setTabExtraWidth(30)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(200, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(200, forSegmentAt: 1)
        
        carbonTabSwipeNavigation.setNormalColor(UIColor.black.withAlphaComponent(0.6))
        carbonTabSwipeNavigation.setSelectedColor(color, font: UIFont.boldSystemFont(ofSize: 14))
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        switch index {
        case 0:
            return self.storyboard!.instantiateViewController(withIdentifier: "FollowingYouViewController") as! FollowingYouViewController
   
        default:
            return self.storyboard!.instantiateViewController(withIdentifier: "YouAreFollwoingViewController") as! YouAreFollwoingViewController
        }
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        NSLog("Did move at index: %ld", index)
    }
    

}
