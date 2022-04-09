//
//  RouteModel.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/8/22.
//

import Foundation
import CoreLocation

class RouteModel: NSObject, RouteDataModel {
    
    
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
    func addCorrdinate(coords: CLLocationCoordinate2D) {
        coordinatesArray.append(coords)
    }
    
    
}
