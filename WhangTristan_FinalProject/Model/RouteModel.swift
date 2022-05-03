//
//  RouteModel.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/8/22.
//

import Foundation
import CoreLocation

class RouteModel: NSObject {
    static let shared = RouteModel()
    var testingMode: Bool = false
    var locationArray: [Location]?
    var coordinatesArray: [CLLocationCoordinate2D]
    var today: DateComponents
    var dayToDisplay: DateComponents
    var locationFilePath: String
    var locationMap: [DateComponents: [Location]]?

    override init() {
        print("Route Model: \(#function)")
        self.coordinatesArray = []
        self.today = DateComponents()
        dayToDisplay = self.today
        self.locationMap = [DateComponents: [Location]]()
        
        print("   self.testingMode before reading = \(self.testingMode)")
        self.testingMode = UserDefaults.standard.bool(forKey: "testingMode")
        print("   self.testingMode after reading = \(self.testingMode)")
        
        // Deal with files
        let documentFolderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        locationFilePath = "\(documentFolderPath.first!)locationArray.plist"
        print("   \(locationFilePath)")
        
        super.init()
        self.setUpToday()
        self.load()
        self.locationArray = []
        setTestArray()
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
            self.locationMap = try decoder.decode([DateComponents: [Location]].self, from: data )
            print("   \(String(describing: self.locationMap))")
        } catch {
            print("there is an error with encoding \(error)")
        }
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
        var aprilFirst: DateComponents = self.today
        aprilFirst.month = 4
        aprilFirst.day = 1
        aprilFirst.isLeapMonth = false
        aprilFirst.year = 2022
        
        // I am force unwrapping because this method is only called after everything is initialized.
        // let keyExists = locationMap![aprilFirst] != nil
        let testLocation: Location = Location(-118.29131, 34.023, 130)
        var testLocationArray: [Location] = [testLocation]
        testLocationArray.append(Location(-118.28785, 34.02030, 5000))
        testLocationArray.append(Location(-118.28666, 34.02193, 1250))
        testLocationArray.append(Location(-118.28704, 34.02287, 1500))
        testLocationArray.append(Location(-118.28511, 34.02324, 27000))
        testLocationArray.append(Location(-118.28389, 34.02739, 5009))
        testLocationArray.append(Location(-118.28418, 34.05074, 3000))
        testLocationArray.append(Location(-118.27925, 34.05902, 10000))
        testLocationArray.append(Location(-118.29419, 34.05775, 15000))
        testLocationArray.append(Location(-118.26115, 34.04136, 2500))
        testLocationArray.append(Location(-118.27264, 34.02797, 17000))
        self.locationMap![aprilFirst] = testLocationArray
        
    }
}

