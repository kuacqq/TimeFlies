//
//  GeocodeResponse.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/15/22.
//

import Foundation

/*
 This set of objects is to decode the response from the google places api. This is primarily currently used for getting the longitude and latitude coordinates of an address entered in the input isochrone vc. 
 */
struct GeocodeResponse : Codable {
    var results: [GeocodeResult]
    var status: String
}
struct GeocodeResult : Codable {
    var address_components: [AddressComponent]
    var formatted_address: String
    var geometry: GeocodeGeometry
    var place_id: String
}
struct AddressComponent : Codable {
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
