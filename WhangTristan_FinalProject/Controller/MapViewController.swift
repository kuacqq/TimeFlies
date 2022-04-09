//
//  MapViewController.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/8/22.
//

import UIKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let route = RouteModel.shared
    let coordinateArray = RouteModel.shared.coordinatesArray
    let locationArray = RouteModel.shared.locationArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    /*
     these are some really important methods that you will always use
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // optional binding
        if let location = locations.first {
            // there is a lot you can access from CLLocation, like time, altitude, literally
            // everything. You will need it for your project
//            print("user location : lat \(location.coordinate.latitude), lng \(location.coordinate.longitude)")
            route.addCorrdinate(coords: location.coordinate)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(#function) \(error.localizedDescription)")
    }
    
    /*
     this is the method that is called when the location authorization
     changes
     */
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("\(#function)")
        if (manager.authorizationStatus == .authorizedAlways) {
            
        }
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
