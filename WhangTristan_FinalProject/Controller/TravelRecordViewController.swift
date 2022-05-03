//
//  TravelRecordViewController.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/24/22.
//

import UIKit

class TravelRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    /*
     IBOutlets
     */
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var testRealSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    /*
     Singleton route model
     */
    let sharedRouteModel = RouteModel.shared
    
    /*
     Variables
     */
    //the date we are looking at has to do with the date picker. This is so that we can separate the location array that we are displying on the record page and the one that you are adding to throughout the day.
    var dateWeAreLookingAt: DateComponents = DateComponents()
    
    
    /*
     Functions
     */
    // in the viewDidLoad function I just make the initial day that is displayed to be the current day and set up the rest of the GUI.
    override func viewDidLoad() {
        print("TRVC: \(#function)")
        super.viewDidLoad()
        let date = Date.now
        self.dateWeAreLookingAt = Calendar.current.dateComponents([.day, .year, .month], from: date)
        
        // initial gui setup
        setStartedSelectedSegment()
        localizeSegmentedControl()
    }
    // viewWillAppear just reloads the data so as you change to the record screen you will refresh the table view to show the locations that you have saved thus far.
    override func viewWillAppear(_ animated: Bool) {
        print("TRVC: \(#function)")
        tableView.reloadData()
    }
    
    // This is pretty standard. I access the singleton and extract the locationArray corresponding to the date that we are currently observing.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("TRVC: \(#function)")
        if let currentLocationArray = sharedRouteModel.locationMap![self.dateWeAreLookingAt] {
            print("   returning Count: \(currentLocationArray.count)")
            return currentLocationArray.count
        }
        return 0
    }
    
    // In here i basically do all the calculations to display the coordinates and time. The way that the time is displayed depends on whether you are in testing or real mode. The testing mode will change the distance filter to be much smaller than the real and the amount of time that it requires to trigger the adding of a new locaiton is much lower. I also display all coordinates as absolute values, just changing the N/S and E/W notation. These of course are localized strings and will be changed based on the language of the system.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! RecordTableViewCell
        if let locationMap = sharedRouteModel.locationMap {
            if let locationArray = locationMap[dateWeAreLookingAt] {
                var lngDouble = locationArray[indexPath.row].longitude
                var latDouble = locationArray[indexPath.row].latitude
                
                var northSouthText: String = NSLocalizedString("n_text", comment: "")
                var eastWestText: String = NSLocalizedString("e_text", comment: "")
                if (latDouble < 0) {
                    latDouble *= -1
                    northSouthText = NSLocalizedString("s_text", comment: "")
                }
                if (lngDouble < 0) {
                    lngDouble *= -1
                    eastWestText = NSLocalizedString("w_text", comment: "")
                }
                let lat = String(format: "%.3f", latDouble)
                let lng = String(format: "%.3f", lngDouble)
                cell.coordinatesLabel?.text = "\(lat)°\(northSouthText), \(lng)°\(eastWestText)"
                
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
    
    // The dateDidChanged function checks to see if the date picker has had its value changed. if it has been changed then we change the property dateWeAreLookingAt and then reload the table. This will then redisplay the data that is in the locationMap.plist file that corresponds to the desired date.
    @IBAction func dateDidChanged(_ sender: Any) {
        let date = datePicker.date
        self.dateWeAreLookingAt = datePicker.calendar.dateComponents([.day, .year, .month], from: date)
        print("\(#function): \(dateWeAreLookingAt)")
        print("   \(String(describing: sharedRouteModel.locationMap![dateWeAreLookingAt]))")
        tableView.reloadData()
    }
    
    // testVsRealDidChange triggers when you change the selected segment on the UISegmentedControl. This modifys the singleton testingMode value to the desired mode. This also updates the UserDefaults file so that the next time you load the app it retains its previous testing mode.
    @IBAction func testVsRealDidChange(_ sender: UISegmentedControl) {
        let segment = sender.selectedSegmentIndex
        // segment 0 is test and segment 1 is real
        if (segment == 0) {
            sharedRouteModel.testingMode = true
        } else {
            sharedRouteModel.testingMode = false
        }
        UserDefaults.standard.set(RouteModel.shared.testingMode, forKey: "testingMode")
        
        tableView.reloadData()
    }
    
    /*
    GUI initialization:
    */
    // This basically makes sure that when you load up the application, the segmented control will display the correct mode.
    func setStartedSelectedSegment() {
        if (sharedRouteModel.testingMode == false) {
            testRealSegmentedControl.selectedSegmentIndex = 1
        }
    }
    
    // This just localizes the strings in the segmented control.
    func localizeSegmentedControl() {
        testRealSegmentedControl.setTitle(NSLocalizedString("test_text", comment: ""), forSegmentAt: 0)
        testRealSegmentedControl.setTitle(NSLocalizedString("real_text", comment: ""), forSegmentAt: 1)
    }
}
