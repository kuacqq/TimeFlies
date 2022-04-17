//
//  GeocodeResponse.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/15/22.
//

import Foundation

struct GeocodeResponse : Codable {
    var results: [GeocodeResult]
    var status: String
}
struct GeocodeResult : Codable {
    var address_components: [AddressComponents]
    var formatted_address: String
    var geometry: GeocodeGeometry
    var place_id: String
}
struct AddressComponents : Codable {
    var components: [Components]
}
struct Components : Codable {
    var long_name: String
    var short_name: String
    var types: [String]
}
struct GeocodeGeometry : Codable {
    var location: GeocodeLocation
}
struct GeocodeLocation : Codable {
    var lat: Double
    var lng: Double
}
