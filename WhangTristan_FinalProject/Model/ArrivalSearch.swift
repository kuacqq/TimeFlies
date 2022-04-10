//
//  ArrivalSearch.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/9/22.
//

import Foundation

class ArrivalSearch {
    var id: String = ""
    var coords: [String: Double] = [:]
    // travel_time is in seconds
    var travel_time: Int = 0
    var transportation: [String: String] = [:]
    var arrival_time: String = ""
    
    func ArrivalSearch(id: String, coords: [String: Double], travel_time: Int, transportation: [String: String], arrival_time: String ) {
        self.id = id
        self.coords = coords
        self.travel_time = travel_time
        self.transportation = transportation
        self.arrival_time = arrival_time
    }
}
