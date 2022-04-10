//
//  Results.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/9/22.
//

import Foundation

struct InitialOutput : Codable {
    var results: [Result]?
}

struct Result : Codable {
    var shapes: [Shape]
}

struct Shape : Codable {
    var shell: [Coordinate]
}

struct Coordinate : Codable {
    var lat: Double
    var lng: Double
}


