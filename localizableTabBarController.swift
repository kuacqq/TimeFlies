//
//  localizableTabBarController.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 5/2/22.
//

import UIKit

class localizableTabBarController: UITabBarController {

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
        // Do any additional setup after loading the view.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
