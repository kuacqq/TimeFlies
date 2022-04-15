//
//  MapViewController.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/8/22.
//

import UIKit
import MapKit
import CoreLocation

class MapRouteViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    /*
    Properties of Map View Controller Class
     */
    var myInitLocation = CLLocationCoordinate2D(latitude: 32.7767, longitude: -96.7970)
    let locationManager = CLLocationManager()
    let route = RouteModel.shared
    let coordinateArray = RouteModel.shared.coordinatesArray
    let locationArray = RouteModel.shared.locationArray
    var lastTimeMeasurement: Date = Date()
    
    /*
     Outlets of MapViewController Class
     */
    @IBOutlet weak var testButton: UIButton!
    
    
    /*
     Outlets of MapViewController Class
     */
    @IBAction func testButtonDidTapped(_ sender: Any) {
        print("MapRouteViewController: \(#function)")
        self.createPolyLine()
        
    }
    @IBAction func printButtonDidTapped(_ sender: Any) {
        print("\(#function): PRINTER")
        print("   route.locationArray: \(route.locationArray)")
        print("   lastMeasuredTime: \(lastTimeMeasurement)")
        self.shouldIAddLocation()
    }
    @IBAction func recenterButtonDidTapped(_ sender: Any) {
        if let currentLocation = locationManager.location?.coordinate {
            let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            let region = MKCoordinateRegion(center: currentLocation, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        print("MapRouteViewController: \(#function)")
        super.viewDidLoad()
        
        // core location setup
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
        if let currentlocation = locationManager.location?.coordinate {
            myInitLocation = currentlocation
        }
        
        // map view and poly line setup
        mapView.delegate = self
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: myInitLocation, span: span)
        mapView.setRegion(region, animated: true)
        
//        createPolyLine()
    }
    
    
    func createPolyLine() {
        print("MapRouteViewController: \(#function)")
        print("   Route.coordinatesArray: \(route.coordinatesArray)")
        
        let polyLine = MKPolyline(coordinates: route.coordinatesArray, count: route.coordinatesArray.count)
        mapView.addOverlay(polyLine)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline) {
            let polyLineRender = MKPolylineRenderer(overlay: overlay)
            polyLineRender.strokeColor = UIColor.purple.withAlphaComponent(0.5)
            polyLineRender.lineWidth = 5
            return polyLineRender
        }
        return MKOverlayRenderer()
    }
    
    
    
    
    
    
    /*
     these are some really important methods that you will always use
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("MapRouteViewController: \(#function)")
        // optional binding
        if let location = locations.first {
            // there is a lot you can access from CLLocation, like time, altitude, literally
            // everything. You will need it for your project
            print("user location : lat \(location.coordinate.latitude), lng \(location.coordinate.longitude)")
            route.addCorrdinate(coords: location.coordinate)
            self.shouldIAddLocation(loc: location)
        }
    }
    
    
    /*
     I still have to make a decision as to how long in a specific place qualifies leaving a marker there.
     */
    func shouldIAddLocation(loc: CLLocation) {
        let currentTime = Date()
        let timeDifference = currentTime.timeIntervalSince(self.lastTimeMeasurement)
        print("\(#function)")
        print("   timeDifference: \(timeDifference)")
        if (timeDifference >= 10) {
            var minutesSpent = Int(timeDifference / 60)
            let hoursSpent = Int(minutesSpent / 60)
            minutesSpent = minutesSpent % 60
            route.addLocation(lng: loc.coordinate.longitude, lat: loc.coordinate.latitude, hrsSpent: hoursSpent, minSpent: minutesSpent)
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("MapRouteViewController: \(#function)")
        print("\(#function) \(error.localizedDescription)")
    }

    /*
     this is the method that is called when the location authorization
     changes
     */
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("MapRouteViewController: \(#function)")
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
