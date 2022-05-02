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
        print("   route.locationArray: \(String(describing: route.locationArray))")
        print("   lastMeasuredTime: \(lastTimeMeasurement)")
        print("   locationMap: \(String(describing: route.locationMap))")
        if let curLocation = locationManager.location {
            self.shouldIAddLocation(loc: curLocation)
        }
        
    }
    @IBAction func recenterButtonDidTapped(_ sender: Any) {
        if let currentLocation = locationManager.location?.coordinate {
            let span = MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
            let region = MKCoordinateRegion(center: currentLocation, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        print("MapRouteViewController: \(#function)")
        super.viewDidLoad()
        route.setUpToday()
        
        // core location setup
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
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
//        print("MapRouteViewController: \(#function)")
        // optional binding
        if let location = locations.first {
            // there is a lot you can access from CLLocation, like time, altitude, literally
            // everything. You will need it for your project
//            print("user location : lat \(location.coordinate.latitude), lng \(location.coordinate.longitude)")
            route.addCorrdinate(coords: location.coordinate)
            self.shouldIAddLocation(loc: location)
        }
    }
    
    
    /*
     In testing mode it will record the locations where you spend 10 seconds or more.
     But in real mode, it will record the locations where you spend more than 5 minutes.
     */
    func shouldIAddLocation(loc: CLLocation) {
        let currentTime = Date()
        let timeDifference = currentTime.timeIntervalSince(self.lastTimeMeasurement)
        print("\(#function)")
        print("   timeDifference: \(timeDifference)")
        //minimum time spent is the amount of time that you will spend in an
        //area before it will make it a marker on the map.
        var minimumTimeSpent: Double = 0
        if (route.testingMode == true) {
            minimumTimeSpent = 10
        } else {
            let minutes: Double = 5.0
            minimumTimeSpent = (minutes * 60)
        }
        if (timeDifference >= minimumTimeSpent) {
            print("   Testing Mode: adding location: (\(loc.coordinate.latitude), \(loc.coordinate.longitude))")
            let secondsSpent = Int(timeDifference) % 60
            route.addLocation(lng: loc.coordinate.longitude, lat: loc.coordinate.latitude, secSpent: secondsSpent)
            self.lastTimeMeasurement = currentTime
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
