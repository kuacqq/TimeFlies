//
//  input_isochroneViewController.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/11/22.
//

import UIKit

class input_isochroneViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var modeOfTransportPicker: UIPickerView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var holderView: UIView!
    
    var inputParametersChanged: (()->Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("input_isochroneViewController: \(#function)")
        
    }
    
    
    @IBAction func doneButtonDidPressed(_ sender: Any) {
        print("input_isochroneViewController: \(#function): ")
        if addressTextField.text != nil {
            let date = timePicker.calendar.dateComponents([.hour, .minute], from: timePicker.date)
            let hourValue = date.hour ?? 1
            let minValue = date.minute ?? 0
//            let date = timePicker.date
//            let hourValue: Int = Calendar.current.component(.hour, from: date)
//            let minValue: Int = Calendar.current.component(.minute, from: date)
            let travelTimeCalculated: Int = ((hourValue * 60) + minValue) * 60
            
            IsochroneModel.shared.changeInputs(lat: 51.507609, lng: -0.128315, modeOfTransport: JSON_TRANSPORT_MODE_ARRAY[pickerView.selectedRow(inComponent: 0)], travelTime: travelTimeCalculated)
            navigationController?.popViewController(animated: true)
            inputParametersChanged?()
        } else {
            let alert = UIAlertController(title: "No address entered", message: "Please enter a new address to load a new isochone.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default)
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
        }
        
    }
    /*
     timePicker functions and attributes
     */
    let HOUR_COMPONENT_INDEX = 0
    let MINUTE_COMPONENT_INDEX = 1
    
    
    /*
     modeOfTransportPicker functinos and attributes
     */
    let TRANSPORT_MODE_ARRAY = ["Cycling", "Driving", "Public Transport", "Walking", "Bus", "Train", "Ferry"]
    let JSON_TRANSPORT_MODE_ARRAY = ["cycling", "driving", "public_transport", "walking", "bus", "train", "ferry"]
    let NUMBER_OF_COMPONENTS = 1
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        print("input_isochroneViewController: \(#function)")
        return NUMBER_OF_COMPONENTS
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        print("input_isochroneViewController: \(#function)")
        return TRANSPORT_MODE_ARRAY.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        print("\(#function): TRANSPORT[\(row)]: \(TRANSPORT_MODE_ARRAY[row])")
        return TRANSPORT_MODE_ARRAY[row]
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
