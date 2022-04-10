//
//  ViewController.swift
//  tristan_location_demo
//
//  Created by tristan whang on 4/4/22.
//

import UIKit

import CoreLocation

class MapTrackingViewController: UIViewController, CLLocationManagerDelegate {
    /*
     you need to import the coreLocation framework
     to make sure that locationManager is kept in
     memory you need to make it a property of the class
     you need to make sure that it doesnt get garbage colelcted
     */
    let locationManager = CLLocationManager()
    let myRoute = RouteModel.shared
    let coordinatesArray = RouteModel.shared.coordinatesArray
    
    /*
     to simulate location movement, you can simulate a custom location,
     and there are other options as well liek running around.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 0 // any slight movement, we will be informed
                                           // about that change
        
        // Whatever happens in the core location manager, tell self
        // you need to conform to the protocol though.
        locationManager.delegate = self
        /*
         you need to make sure that you get the proper authorization from the user
         you have to add to the info.plist to give a reason as to why you need your location
         you can only request one of these.
         */
        locationManager.requestAlwaysAuthorization()
//        locationManager.requestWhenInUseAuthorization()
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
            print("user location : lat \(location.coordinate.latitude), lng \(location.coordinate.longitude)")
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
        if (manager.authorizationStatus == .authorizedAlways) {
            
        }
    }
    

    

}

