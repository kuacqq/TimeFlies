//
//  RouteModel.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/8/22.
//

import Foundation

class RouteModel: NSObject, RouteDataModel {
    var locationPinArray: [LocationPin]
    var date: Date
    
    override init() {
        self.locationPinArray = []
        self.date = Date.now
    }
    
    func addPin(lng: Double, lat: Double, hrsSpent: Int, minSpent: Int) {
        let pin: LocationPin = LocationPin(lng, lat, hrsSpent, minSpent)
        locationPinArray.append(pin)
    }
    
    
}
