//
//  RouteDataModel.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/8/22.
//

import Foundation
import CoreLocation

protocol RouteDataModel {
    func addLocation(lng: Double, lat: Double, hrsSpent: Int, minSpent: Int)
    func addCorrdinate(coords: CLLocationCoordinate2D)
}
