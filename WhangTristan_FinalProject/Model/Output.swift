//
//  Output.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/10/22.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let type: String
    let features: [Feature]
}

// MARK: - Feature
struct Feature: Codable {
    let type: String
    let geometry: Geometry
    let properties: Properties
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: String
    let coordinates: [[[[Double]]]]
}

// MARK: - Properties
struct Properties: Codable {
}
