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
    var ShapeArray: [Shape] = []
    func getIsochrone() {
        
        /*
         This whole section is to make the url request work. it has a body and
         a lot of headers which took a while to get to work.
         */
        guard let url = URL(string: "https://api.traveltimeapp.com/v4/time-map") else
        {
            return
        }
        let body = [
            "arrival_searches": [
                "id": "isochrone-0",
                "coords": ["lat": 51.5119637, "lng": -0.1279543],
                "travel_time": 1800,
                "transportation": ["type": "public_transport"],
                "arrival_time": "2022-04-09T16:00:00.000Z"
            ]
        ]
        let finalBody = try? JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/geo+json", forHTTPHeaderField: "Accept")
        request.addValue("api.traveltimeapp.com", forHTTPHeaderField: "Host")
        request.addValue("34acafbe0724fd45d6d83e02cfa92392", forHTTPHeaderField: "X-Application-key")
        request.addValue("d9b90531", forHTTPHeaderField: "X-Application-id")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//            }
            if let data = data {
                do {
                    let shapeJsonArray = try JSONDecoder().decode([Shape].self, from: data)
                    print("   imageJsonArray.count: \(shapeJsonArray.count)")
                    this.ShapeArray = shapeJsonArray
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
        
        
        
    }
    
    
}


//        "{
//          \"arrival_searches\": \[
//            {
//              \"id\": \"isochrone-0\",
//              \"coords\": {
//                \"lat\": 51.5119637,
//                \"lng\": -0.1279543
//              },
//              \"travel_time\": 1800,
//              \"transportation\": {
//                \"type\": \"public_transport\"
//              },
//              \"arrival_time\": \"2022-04-09T16:00:00.000Z\"
//            }
//          ]
//        }"
