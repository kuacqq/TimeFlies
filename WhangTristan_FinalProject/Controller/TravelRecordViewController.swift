//
//  TravelRecordViewController.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/24/22.
//

import UIKit

class TravelRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let sharedRouteModel = RouteModel.shared
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedRouteModel.locationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! RecordTableViewCell
        let lngDouble = sharedRouteModel.locationArray[indexPath.row].longitude
        let latDouble = sharedRouteModel.locationArray[indexPath.row].latitude
        
        let lat = String(format: "%.2f", latDouble)
        let lng = String(format: "%.2f", lngDouble)
        cell.coordinatesLabel?.text = "\(lat), \(lng)"
        let hrs = sharedRouteModel.locationArray[indexPath.row].hoursSpent
        let min = sharedRouteModel.locationArray[indexPath.row].minutesSpent
        let sec = sharedRouteModel.locationArray[indexPath.row].secondsSpent
        if (RouteModel.shared.testingMode) {
            cell.timeLabel.text = "\(sec) \(NSLocalizedString("sec", comment: ""))"
        } else {
            cell.timeLabel.text = "\(hrs) \(NSLocalizedString("hr_text", comment: "")) \(min) \(NSLocalizedString("min_text", comment: ""))"
        }
        return cell
    }

}
