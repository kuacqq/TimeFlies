//
//  File.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/8/22.
//

import Foundation

struct Location {
    var longitude: Double
    var latitude: Double
    
    // This should just be the time and
    // routeModel should hold the actual day
    // so that it can be represented.
    var hoursSpent: Int
    var minutesSpent: Int
    
    init(_ longitude: Double, _ latitude: Double, _ hoursSpent: Int, _ minutesSpent: Int) {
        self.longitude = longitude
        self.latitude = latitude
        self.hoursSpent = hoursSpent
        self.minutesSpent = minutesSpent
    }
}
