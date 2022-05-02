//
//  File.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/8/22.
//

import Foundation



struct Location: Codable {
    var longitude: Double
    var latitude: Double
    
    // This should just be the time and
    // routeModel should hold the actual day
    // so that it can be represented.
//    var hoursSpent: Int
//    var minutesSpent: Int
    
    // for testing purposes
    var secondsSpent: Int
    
//    init(_ longitude: Double, _ latitude: Double, _ hoursSpent: Int, _ minutesSpent: Int) {
//        self.longitude = longitude
//        self.latitude = latitude
//        self.hoursSpent = hoursSpent
//        self.minutesSpent = minutesSpent
//        self.secondsSpent = 0
//    }
    init(_ longitude: Double, _ latitude: Double, _ secondsSpent: Int) {
        self.longitude = longitude
        self.latitude = latitude
//        self.hoursSpent = 0
//        self.minutesSpent = 0
        self.secondsSpent = secondsSpent
    }
}
