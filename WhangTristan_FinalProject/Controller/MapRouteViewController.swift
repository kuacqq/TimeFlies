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
    var myInitLocation = CLLocationCoordinate2D(latitude: 34.023, longitude: -118.29131)
    let locationManager = CLLocationManager()
    let route = RouteModel.shared
    var coordinateArray: [CLLocationCoordinate2D] = RouteModel.shared.coordinatesArray
    let locationArray = RouteModel.shared.locationArray
    var lastTimeMeasurement: Date = Date()
    
    
    
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
        print("MapRouteViewController: \(#function)")
        let span = MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
        if (!self.coordinateArray.isEmpty) {
            let region = MKCoordinateRegion(center: self.coordinateArray[0], span: span)
            mapView.setRegion(region, animated: true)
            return
        }
        if let currentLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: currentLocation, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        print("MapRouteViewController: \(#function)")
        super.viewDidLoad()
        route.setUpToday()
        self.localizeButtonText()
    
        /*
         Core Location Setup
         if you are in testing mode, the distance fileter is the 50 meters but if its in real it should be 200
         */
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        if (route.testingMode == true) {
            locationManager.distanceFilter = 50
        } else {
            locationManager.distanceFilter = 200
        }
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("MapRouteViewController: \(#function)")
        if (route.testingMode == true) {
            locationManager.distanceFilter = 50
        } else {
            locationManager.distanceFilter = 200
        }
    }
    
    
    func createPolyLine() {
        print("MapRouteViewController: \(#function)")
        print("   Route.coordinatesArray: \(self.coordinateArray)")
        
        let polyLine = MKPolyline(coordinates: self.coordinateArray, count: self.coordinateArray.count)
        mapView.addOverlay(polyLine)
    }
    func removeAllPolyLines() {
        print("MapRouteViewController: \(#function)")
        let currentOverlays = self.mapView.overlays
        mapView.removeOverlays(currentOverlays)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("MapRouteViewController: \(#function)")
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
            route.addCorrdinate(coords: location.coordinate)
            self.shouldIAddLocation(loc: location)
        }
    }
    
    
    /*
     In testing mode it will record the locations where you spend 10 seconds or more.
     But in real mode, it will record the locations where you spend more than 5 minutes.
     */
    func shouldIAddLocation(loc: CLLocation) {
        print("MapRouteViewController: \(#function)")
        let currentTime = Date()
        let timeDifference = currentTime.timeIntervalSince(self.lastTimeMeasurement)
        print("   timeDifference: \(timeDifference)")
        
        /*
         I set lastTimeMeasurement equal to currentTime because only time that you set within the area specified by the distance fileter matters. This will cause the map to be a bit less accurate in its display of locations/the route that you took.
         
         There are simple ways to get around this but this feature is just not currently implemented.
         */
        self.lastTimeMeasurement = currentTime
        
        
        // minimum time spent is the amount of time that you need to spend in an area before the progam will record this and place it on the map
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
        print("   \(error.localizedDescription)")
    }

    /*
     this is the method that is called when the location authorization
     changes
     */
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("MapRouteViewController: \(#function)")
        print("\(#function)")
        if (manager.authorizationStatus != .authorizedAlways) {
            let alert = UIAlertController(title: "Location Preferences Changed", message: "Please change your preferences back to Always Active. Otherwise this app will be unable to function properly", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default)
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
            locationManager.requestAlwaysAuthorization()
        }
    }
   
    @IBAction func datePickerValueDidChange(_ sender: UIDatePicker) {
        removeAllPolyLines()
        print("MapRouteViewController: \(#function)")
        if let locationMapUnwrapped = route.locationMap {
            let date =  sender.calendar.dateComponents([.day, .year, .month], from: sender.date)
            if let tempLocationArray = locationMapUnwrapped[date] {
                self.coordinateArray = []
                for loc in tempLocationArray {
                    self.coordinateArray.append(CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude))
                }
            }
        }
        createPolyLine()
        return
    }
    
    
    /*
     Outlets of MapViewController Class
     */
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var printButton: UIButton!
    /*
     Localization Functions
     */
    func localizeButtonText() {
        testButton.setTitle(NSLocalizedString("polyline_text", comment: ""), for: .normal)
        printButton.setTitle(NSLocalizedString("print_text", comment: ""), for: .normal)
    }
    
    

}
