//
//  TravelRecordViewController.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/24/22.
//

import UIKit

class TravelRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    let sharedRouteModel = RouteModel.shared
    @IBOutlet weak var tableView: UITableView!
    
    var dateWeAreLookingAt: DateComponents = DateComponents()
    override func viewDidLoad() {
        print("TRVC: \(#function)")
        super.viewDidLoad()
        let date = Date.now
        self.dateWeAreLookingAt = Calendar.current.dateComponents([.day, .year, .month], from: date)
        
        /*
         initial gui setup
         */
        setStartedSelectedSegment()
        localizeSegmentedControl()
    }
    override func viewWillAppear(_ animated: Bool) {
        print("TRVC: \(#function)")
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("TRVC: \(#function)")
        if let currentLocationArray = sharedRouteModel.locationMap![self.dateWeAreLookingAt] {
            print("   returning Count: \(currentLocationArray.count)")
            return currentLocationArray.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("   TRVC: \(#function)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! RecordTableViewCell
        if let locationMap = sharedRouteModel.locationMap {
            if let locationArray = locationMap[dateWeAreLookingAt] {
                let lngDouble = locationArray[indexPath.row].longitude
                let latDouble = locationArray[indexPath.row].latitude
                
                let lat = String(format: "%.3f", latDouble)
                let lng = String(format: "%.3f", lngDouble)
                cell.coordinatesLabel?.text = "\(lat), \(lng)"
                
                let time = locationArray[indexPath.row].secondsSpent
                let sec = (time % 360)
                let min = ((time - sec)/60) % 60
                let hr = ((time - sec)/60 - min)/60
                
                if (RouteModel.shared.testingMode) {
                    cell.timeLabel.text = "\(sec) \(NSLocalizedString("sec_text", comment: ""))"
                } else {
                    cell.timeLabel.text = "\(hr) \(NSLocalizedString("hr_text", comment: "")) \(min) \(NSLocalizedString("min_text", comment: ""))"
                }
            }
        }
        return cell
    }
    @IBAction func dateDidChanged(_ sender: Any) {
        let date = datePicker.date
        self.dateWeAreLookingAt = datePicker.calendar.dateComponents([.day, .year, .month], from: date)
        print("\(#function): \(dateWeAreLookingAt)")
        print("   \(String(describing: sharedRouteModel.locationMap![dateWeAreLookingAt]))")
        tableView.reloadData()
    }
    
    @IBAction func testVsRealDidChange(_ sender: UISegmentedControl) {
        let segment = sender.selectedSegmentIndex
        // segment 0 is test and segment 1 is real
        if (segment == 0) {
            sharedRouteModel.testingMode = true
        } else {
            sharedRouteModel.testingMode = false
        }
        tableView.reloadData()
    }
    func setStartedSelectedSegment() {
        if (sharedRouteModel.testingMode == false) {
            testRealSegmentedControl.selectedSegmentIndex = 1
        }
    }
    
    /*
    Localization
    */
    @IBOutlet weak var testRealSegmentedControl: UISegmentedControl!
    func localizeSegmentedControl() {
        testRealSegmentedControl.setTitle(NSLocalizedString("test_text", comment: ""), forSegmentAt: 0)
        testRealSegmentedControl.setTitle(NSLocalizedString("real_text", comment: ""), forSegmentAt: 1)
    }
}
