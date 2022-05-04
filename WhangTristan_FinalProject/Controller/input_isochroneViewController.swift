//
//  input_isochroneViewController.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/11/22.
//

import UIKit
import CoreLocation

/*
 The input isochrone view controller is how you change the parameters for a call to the travel time api. You enter an amount of availible time, mode of transport, and an address which is then geocoded when you press done. After you transition back to the isochroneViewController, the new isochrone is displayed.
 */
class input_isochroneViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    let sharedGeocodingModel = GeocodingModel.shared
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var holderView: UIView!
    
    // the only initial setup that needs to be done is localizing the buttons and labels.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("input_isochroneViewController: \(#function)")
        localizeLabels()
        localizeButtons()
    }
    
    // this viewWillAppear is for future use like if you want to store and review the settings of your last isochrone.
    override func viewWillAppear(_ animated: Bool) {
    }

    // textFieldShouldReturn just resigns the keyboard from the address text field when you press return.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // When you press the done bar button item this function triggers. It basically changes all the properties that relate to making the travel time api call which is then invoked in the isochrone view controller. It also checks if the text field is empty. if it is empty you cannot use the done button to go back to the previous VC.
    @IBAction func doneButtonDidPressed(_ sender: Any) {
        print("input_isochroneViewController: \(#function):")
        if (addressTextField.text != "") {
            print("   text field not empty")
            let date = timePicker.calendar.dateComponents([.hour, .minute], from: timePicker.date)
            let hourValue = date.hour ?? 1
            let minValue = date.minute ?? 0

            let travelTimeCalculated: Int = ((hourValue * 60) + minValue) * 60
            
            IsochroneModel.shared.inputAddress = addressTextField.text!
            IsochroneModel.shared.setTime(travelTime: travelTimeCalculated)
            IsochroneModel.shared.setModeOfTransport(mode: JSON_TRANSPORT_MODE_ARRAY[pickerView.selectedRow(inComponent: 0)])
            
            navigationController?.popViewController(animated: true)
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
     The transport mode array is what you actually see as the strings in the picker view but the json version contains the actual corresponding text that is needed to make the api call.
     */
    let TRANSPORT_MODE_ARRAY = [NSLocalizedString("cycling_text", comment: ""),
                                NSLocalizedString("driving_text", comment: ""),
                                NSLocalizedString("public_transport_text", comment: ""),
                                NSLocalizedString("walking_text", comment: ""),
                                NSLocalizedString("bus_text", comment: ""),
                                NSLocalizedString("train_text", comment: "")]
    let JSON_TRANSPORT_MODE_ARRAY = ["cycling", "driving", "public_transport", "walking", "bus", "train"]
    let NUMBER_OF_COMPONENTS = 1
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return NUMBER_OF_COMPONENTS
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TRANSPORT_MODE_ARRAY.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TRANSPORT_MODE_ARRAY[row]
    }
    @IBAction func backgroundButtonDidTapped(_ sender: Any) {
        self.addressTextField.resignFirstResponder()
    }
    
    
    /*
     Localizing Functions
     */
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var modeOfTransportLabel: UILabel!
    @IBOutlet weak var travelTimeLabel: UILabel!
    func localizeLabels() {
        addressLabel.text = NSLocalizedString("address_label_text", comment: "")
        modeOfTransportLabel.text = NSLocalizedString("mode_of_transport_text", comment: "")
        travelTimeLabel.text = NSLocalizedString("travel_time_text", comment: "")
    }
    func localizeButtons() {
        doneBarButton.title = NSLocalizedString("done_text", comment: "")
    }
    
    



}
