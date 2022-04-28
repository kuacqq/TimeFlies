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
        super.viewDidLoad()
        let date = Date.now
        self.dateWeAreLookingAt = Calendar.current.dateComponents([.day, .year, .month], from: date)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let locationArray = sharedRouteModel.locationArray {
            return locationArray.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! RecordTableViewCell
        if let locationMap = sharedRouteModel.locationMap {
            if let locationArray = locationMap[dateWeAreLookingAt.day!] {
                let lngDouble = locationArray[indexPath.row].longitude
                let latDouble = locationArray[indexPath.row].latitude
                
                let lat = String(format: "%.2f", latDouble)
                let lng = String(format: "%.2f", lngDouble)
                cell.coordinatesLabel?.text = "\(lat), \(lng)"
                
                let hrs = locationArray[indexPath.row].hoursSpent
                let min = locationArray[indexPath.row].minutesSpent
                let sec = locationArray[indexPath.row].secondsSpent
                if (RouteModel.shared.testingMode) {
                    cell.timeLabel.text = "\(sec) \(NSLocalizedString("sec", comment: ""))"
                } else {
                    cell.timeLabel.text = "\(hrs) \(NSLocalizedString("hr_text", comment: "")) \(min) \(NSLocalizedString("min_text", comment: ""))"
                }
            }
        }
        return cell
    }
    @IBAction func dateDidChanged(_ sender: Any) {
        let date = datePicker.date
        dateWeAreLookingAt = datePicker.calendar.dateComponents([.day, .year, .month], from: date)
        tableView.reloadData()
    }
}
