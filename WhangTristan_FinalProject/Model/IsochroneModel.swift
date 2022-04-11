//
//  IsochroneModel.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/9/22.
//

import Foundation

class IsochroneModel {
    static let shared = IsochroneModel()
    
    var ACCESS_KEY = "34acafbe0724fd45d6d83e02cfa92392"
    var APPLICATION_ID = "d9b90531"
    var GeometryArray: [Geometry] = []
    func getIsochrone(onSuccess: @escaping ([Feature]) -> Void) {
        print("IsochroneViewController: \(#function)")
        
        /*
         This whole section is to make the url request work. it has a body and
         a lot of headers which took a while to get to work.
         */
        guard let url = URL(string: "https://api.traveltimeapp.com/v4/time-map") else
        {
            return
        }
//        let body = [
//            "arrival_searches": [
//                "id": "isochrone-0",
//                "coords": ["lat": 51.5119637, "lng": -0.1279543],
//                "travel_time": 1800,
//                "transportation": ["type": "public_transport"],
//                "arrival_time": "2022-04-09T16:00:00.000Z"
//            ]
//        ]
//        let body: [String: Any] = [
//            "arrival_searches": [
//                "id": "isochrone-0",
//                "coords": ["lat": 51.5119637, "lng": -0.1279543],
//                "travel_time": 1800,
//                "transportation": ["type": "public_transport"],
//                "arrival_time": "2022-04-09T16:00:00.000Z"
//            ]
//        ]
//        print("   \(#function): body: \(body)")
//        let finalBody = try? JSONSerialization.data(withJSONObject: body)
//        print("   \(#function): finalBody: \(finalBody!)")
        
        
        
        let finalBody = """
            {
              "departure_searches": [
                {
                  "id": "My first isochrone",
                  "coords": {
                    "lat": 51.507609,
                    "lng": -0.128315
                  },
                  "transportation": {
                    "type": "driving"
                  },
                  "departure_time": "2021-09-27T08:00:00Z",
                  "travel_time": 3600
                }
              ]
            }
        """.data(using: .utf8)

        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/geo+json", forHTTPHeaderField: "Accept")
//        request.addValue("api.traveltimeapp.com", forHTTPHeaderField: "Host")
        request.addValue("34acafbe0724fd45d6d83e02cfa92392", forHTTPHeaderField: "X-Api-key")
        request.addValue("d9b90531", forHTTPHeaderField: "X-Application-Id")
        print("   \(#function): request: \(request)")
        URLSession.shared.dataTask(with: request) { data, response, error in
//            print("   \(#function): URLSession: response: \(response as Any)")
            
            if error != nil {
                print("   interior error")
                print(error?.localizedDescription ?? "No dat")
                return
            }
//            let json = String(data: data!, encoding: .utf8)
//            print(json!)
            if let data = data {
//                print("   \(#function): Data: \(String(describing:data))")
                do {
                    let output = try JSONDecoder().decode(Welcome.self, from: data)
//                    print("   \(#function): \(output)")
                    let features = output.features
                    // do the closure on an array of features and extract all the geometries and nested coordinates.
                    if !features.isEmpty {
                        onSuccess(features)
                    }
                } catch {
                    print("   caught in 4K!!!!")
                    print(error)
                }
            }
        }.resume()
        print("   \(#function): FINISHED")
    }
    
    
}
