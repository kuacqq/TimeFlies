//
//  RouteModel.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/8/22.
//

import Foundation
import CoreLocation

class RouteModel: NSObject, RouteDataModel {
    
    static let shared = RouteModel()
    let testingMode: Bool = true
    var locationArray: [Location]?
    var coordinatesArray: [CLLocationCoordinate2D]
    var today: DateComponents
    var locationFilePath: String
//    var locationMap: [DateComponents: [Location]]?
    var locationMap: [DateComponents: [Location]]?

    override init() {
        print("Route Model: \(#function)")
//        self.locationMap = DateLocationMap(dateLocationMap: [Date: [Location]])
        self.coordinatesArray = []
//        self.locationArray = []
        self.today = DateComponents()
        self.locationMap = [DateComponents: [Location]]()
        
        
        // Deal with files
        let documentFolderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        locationFilePath = "\(documentFolderPath.first!)/locationArray.plist"
        print("\(documentFolderPath)")
        
        super.init()
        self.setUpToday()
        self.load()
        
//        if let tempLocationMap = locationMap {
//            self.locationArray = tempLocationMap[self.today.day!]
//        } else {
//            self.locationArray = []
//        }
        self.locationArray = []
    }
    func setUpToday() {
        let date = Date.now
        let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: date)
        self.today = calendarDate
        print("\(#function): \(self.today)")
    }
    
    func save() {
        print("Route Model: \(#function)")
        print("   \(self.today)")
        if let locationMap = self.locationMap {
            if let _ = locationMap[self.today], let locationArray = self.locationArray {
                print("\(#function): if")
                self.locationMap![self.today]!.append(contentsOf: locationArray)
            } else {
                print("\(#function): else")
                self.locationMap![self.today] = locationArray
            }
        } else {
            return
        }
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(locationMap)
            let str = String(data: data, encoding: .utf8)!
            let filePath = URL(string: locationFilePath)!
            
            try! str.write(to: filePath, atomically: true, encoding: .utf8)
        } catch {
            print("there is an error with encoding \(error)")
        }
    }
    func load() {
        print("Route Model: \(#function)")
        let filePath = URL(string: locationFilePath)!
        do {
            let data = try Data(contentsOf: filePath)
            let decoder = JSONDecoder()
//            self.locationMap = try decoder.decode([DateComponents: [Location]].self, from: data )
            self.locationMap = try decoder.decode([DateComponents: [Location]].self, from: data )
            print("   \(String(describing: self.locationMap))")
        } catch {
            print("there is an error with encoding \(error)")
        }
    }
    
    func addLocation(lng: Double, lat: Double, hrsSpent: Int, minSpent: Int) {
        print("Route Model: \(#function)")
        let pin: Location = Location(lng, lat, hrsSpent, minSpent)
        if let _ = locationArray {
            self.locationArray!.append(pin)
        }
        save()
    }
    func addLocation(lng: Double, lat: Double, secSpent: Int) {
        print("Route Model: \(#function): \(self.today)")
        let pin: Location = Location(lng, lat, secSpent)
        if let _ = locationArray {
            self.locationArray!.append(pin)
        }
        save()
    }
    
    // this is so i can use
    // let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
    // mapView.addOverlay(polyline)
    func addCorrdinate(coords: CLLocationCoordinate2D) {
        print("Route Model: \(#function)")
        coordinatesArray.append(coords)
    }
    func addCoordinate(lng: Int, lat: Int) {
        print("Route Model: \(#function)")
        let degLongitude: CLLocationDegrees = CLLocationDegrees(lng)
        let degLatitude: CLLocationDegrees = CLLocationDegrees(lat)
        let coords = CLLocationCoordinate2D(latitude: degLongitude, longitude: degLatitude)
        coordinatesArray.append(coords)
    }
    func addCoorinates(lng: CLLocationDegrees, lat: CLLocationDegrees) {
        print("Route Model: \(#function)")
        coordinatesArray.append(CLLocationCoordinate2D(latitude: lat, longitude: lng))
    }
    
    
    /*
     Testing Method
     */
    func setTestArray() {
        print("Route Model: \(#function)")
    }
}
