//
//  File.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/8/22.
//

import Foundation


/*
 A location to be stored consists of its latitude and longitude coordinates and the amount of time spent at that location, in seconds. It is possible to reverse geocode these coordinates for addresses but doesn't add anything in terms of technical functionality but would be included in a final version that would be shipped to consumers.
 */
struct Location: Codable {
    var longitude: Double
    var latitude: Double
    var secondsSpent: Int
    
    init(_ longitude: Double, _ latitude: Double, _ secondsSpent: Int) {
        self.longitude = longitude
        self.latitude = latitude
        self.secondsSpent = secondsSpent
    }
}
