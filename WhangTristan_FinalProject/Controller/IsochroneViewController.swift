//
//  IsochroneViewController.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/9/22.
//

import UIKit
import MapKit

class IsochroneViewController: UIViewController, MKMapViewDelegate {
    
    var myInitLocation = CLLocationCoordinate2D(latitude: 32.7767, longitude: -96.7970)
    let locationManager = CLLocationManager()
    
    var sharedIsochoneModel = IsochroneModel.shared
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonDidTapped(_ sender: Any) {
        loadIsochrone()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadIsochrone() {
        print("\(#function)")
        sharedIsochoneModel.getIsochrone()
        
    }

}
