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
         Localize the labels
         */
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
                
                let hrs = locationArray[indexPath.row].hoursSpent
                let min = locationArray[indexPath.row].minutesSpent
                let sec = locationArray[indexPath.row].secondsSpent
                if (RouteModel.shared.testingMode) {
                    cell.timeLabel.text = "\(sec) \(NSLocalizedString("sec_text", comment: ""))"
                } else {
                    cell.timeLabel.text = "\(hrs) \(NSLocalizedString("hr_text", comment: "")) \(min) \(NSLocalizedString("min_text", comment: ""))"
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
    
    @IBAction func testVsRealDidChange(_ sender: Any) {
        
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
