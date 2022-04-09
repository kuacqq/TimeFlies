//
//  RouteModel.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/8/22.
//

import Foundation
import CoreLocation

class RouteModel: NSObject, RouteDataModel {
    
    static let shared = RouteModel()
    var locationArray: [Location]
    var coordinatesArray: [CLLocationCoordinate2D]
    var date: Date
    
    override init() {
        self.coordinatesArray = []
        self.locationArray = []
        self.date = Date.now
    }
    
    func addLocation(lng: Double, lat: Double, hrsSpent: Int, minSpent: Int) {
        let pin: Location = Location(lng, lat, hrsSpent, minSpent)
        locationArray.append(pin)
    }
    
    // this is so i can use
    // let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
    // mapView.addOverlay(polyline)
    func addCorrdinate(coords: CLLocationCoordinate2D) {
        coordinatesArray.append(coords)
    }
    func addCoordinate(lng: Int, lat: Int) {
        let degLongitude: CLLocationDegrees = CLLocationDegrees(lng)
        let degLatitude: CLLocationDegrees = CLLocationDegrees(lat)
        let coords = CLLocationCoordinate2D(latitude: degLongitude, longitude: degLatitude)
        coordinatesArray.append(coords)
    }
    func addCoorinates(lng: CLLocationDegrees, lat: CLLocationDegrees) {
        coordinatesArray.append(CLLocationCoordinate2D(latitude: lat, longitude: lng))
    }
    
    
}
