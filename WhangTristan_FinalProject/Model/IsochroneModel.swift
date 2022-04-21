//
//  IsochroneModel.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/9/22.
//

import Foundation

class IsochroneModel {
    static let shared = IsochroneModel()
    var inputAddress: String? 
    var ACCESS_KEY = "34acafbe0724fd45d6d83e02cfa92392"
    var APPLICATION_ID = "d9b90531"
    var inputLngDouble: Double? = -0.128315
    var inputLatDouble: Double? = 51.507609
    var inputModeOfTransport: String? = "driving"
    var inputTravelTimeInt: Int? = 3600

    
    func changeInputs(lat: Double, lng: Double, modeOfTransport: String, travelTime: Int) {
        print("IsochroneModel: \(#function)")
        self.inputLngDouble = lng
        self.inputLatDouble = lat
        self.inputTravelTimeInt = travelTime
        self.inputModeOfTransport = modeOfTransport
    }
    func setTime(travelTime: Int) {
        self.inputTravelTimeInt = travelTime
    }
    func setLatLong(lat: Double, lng: Double) {
        self.inputLatDouble = lat
        self.inputLngDouble = lng
    }
    func setModeOfTransport(mode: String) {
        self.inputModeOfTransport = mode
    }
    var GeometryArray: [Geometry] = []
    func getIsochrone(onSuccess: @escaping ([Feature]) -> Void) {
        print("IsochroneModel: \(#function)")
        
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
        
        
        
        let modular_finalBody = """
            {
              "departure_searches": [
                {
                  "id": "My first isochrone",
                  "coords": {
                    "lat": \(self.inputLatDouble ?? 51.507609),
                    "lng": \(self.inputLngDouble ?? -0.128315)
                  },
                  "transportation": {
                    "type": "\(self.inputModeOfTransport ?? "driving")"
                  },
                  "departure_time": "2021-09-27T08:00:00Z",
                  "travel_time": \(self.inputTravelTimeInt ?? 3600)
                }
              ]
            }
        """.data(using: .utf8)

//        let static_finalBody = """
//            {
//              "departure_searches": [
//                {
//                  "id": "My first isochrone",
//                  "coords": {
//                    "lat": 51.507609,
//                    "lng": -0.128315
//                  },
//                  "transportation": {
//                    "type": "driving"
//                  },
//                  "departure_time": "2021-09-27T08:00:00Z",
//                  "travel_time": 3600
//                }
//              ]
//            }
//        """.data(using: .utf8)

        print("\(#function): modular_finalBody: \(String(data: modular_finalBody!, encoding: .utf8)!)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = modular_finalBody!
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/geo+json", forHTTPHeaderField: "Accept")
//        request.addValue("api.traveltimeapp.com", forHTTPHeaderField: "Host")
        request.addValue("34acafbe0724fd45d6d83e02cfa92392", forHTTPHeaderField: "X-Api-key")
        request.addValue("d9b90531", forHTTPHeaderField: "X-Application-Id")
        print("   \(#function): request: \(request)")
        URLSession.shared.dataTask(with: request) { data, response, error in
//            print("   \(#function): URLSession: response: \(response as Any)")
            
//            if error != nil {
            if let error = error {
                print("   interior error")
                print(error.localizedDescription)
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
