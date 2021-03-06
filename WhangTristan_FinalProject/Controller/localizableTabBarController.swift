//
//  localizableTabBarController.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 5/2/22.
//

import UIKit

class localizableTabBarController: UITabBarController {
    
    // This is a custom UITabBarController that was meant to localize the labels for each of the tabs
    // but I was having a difficult time with this so I eventually scrapped this and left this here potentially for later
    override func viewDidLoad() {
        super.viewDidLoad()
        print("localizableTabBarController: \(#function)")
        if let isochroneTabBarItem = self.tabBarController?.tabBar.items?[0] {
            print("   isochroneTabBarItem")
            isochroneTabBarItem.title = NSLocalizedString("isochrone_text", comment: "")
        }
        if let routeTabBarItem = self.tabBarController?.tabBar.items?[1] {
            print("   routeTabBarItem")
            routeTabBarItem.title = NSLocalizedString("route_text", comment: "")
        }
        if let recordTabBarItem = self.tabBarController?.tabBar.items?[2] {
            print("   recordTabBarItem")
            recordTabBarItem.title = NSLocalizedString("record_text", comment: "")
        }
    }
    

}
