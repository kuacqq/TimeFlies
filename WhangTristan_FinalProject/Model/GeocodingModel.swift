//
//  GeocodingModel.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/15/22.
//

import Foundation
import CoreLocation

public class GeocodingModel {
    static let shared = GeocodingModel()
    
    let API_KEY: String = "AIzaSyC6Vfk1wKI--AcPMdk4sqbiI7J-QUd7wfA"
    let outputFormat: String = "json"
    let BASE_URL: String = "https://maps.googleapis.com/maps/api/geocode/"
    var address_input: String = ""
    var outputCoordinates:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    func setAddress(input: String) {
        self.address_input = input
    }
    func geocode(onSuccess: @escaping(CLLocationCoordinate2D) -> Void) {
//    func geocode(){
        print("Geocoding Model : \(#function)")
        var addressString: String = ""
        if (address_input != "") {
            addressString = self.address_input.replacingOccurrences(of: " ", with: "+")
        } else {
            return
        }
        var finalURL = BASE_URL
        finalURL.append(contentsOf: "\(outputFormat)?")
        finalURL.append(contentsOf: "address=")
        finalURL.append(contentsOf: addressString)
        finalURL.append(contentsOf: "&key=\(API_KEY)")
        
        guard let url = URL(string: finalURL) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request){ data, response, error in
            
            if let error = error {
                print("   geocoding interior error")
                print(error.localizedDescription)
                return
            }
//            let json = String(data: data!, encoding: .utf8)
//            print("   Geocoding Model: JSON: ", json!)
            if let data = data {
                do {
                    let output = try JSONDecoder().decode(GeocodeResponse.self, from: data)
                    let lat = output.results[0].geometry.location.lat
                    let lng = output.results[0].geometry.location.lng
                    let coordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                    print("   \(#function): lat = \(lat), lng = \(lng)")
                    onSuccess(coordinate2D)
                } catch {
                    print(error)
                }
            }
            
        }.resume()
    }
}
