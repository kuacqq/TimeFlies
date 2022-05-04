//
//  Output.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/10/22.
//

import Foundation

/*
 This set of structs are used to decode the time travel api response. As mentioned elsewhere, this does not actually follow the response given as an example on their website so it may have to be restructured in the future.
 */
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
