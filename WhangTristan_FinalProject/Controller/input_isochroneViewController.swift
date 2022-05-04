//
//  input_isochroneViewController.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/11/22.
//

import UIKit
import CoreLocation

class input_isochroneViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    let sharedGeocodingModel = GeocodingModel.shared
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var holderView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("input_isochroneViewController: \(#function)")
        localizeLabels()
        localizeButtons()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            self.answerTextField.becomeFirstResponder()
//        }
//        return true
//    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func doneButtonDidPressed(_ sender: Any) {
        print("input_isochroneViewController: \(#function):")
        if (addressTextField.text != "") {
            print("   text field not empty")
            let date = timePicker.calendar.dateComponents([.hour, .minute], from: timePicker.date)
            let hourValue = date.hour ?? 1
            let minValue = date.minute ?? 0

            let travelTimeCalculated: Int = ((hourValue * 60) + minValue) * 60
            
//            geocodeAddress(addressInput: addressTextField.text!)
            IsochroneModel.shared.inputAddress = addressTextField.text!
            IsochroneModel.shared.setTime(travelTime: travelTimeCalculated)
            IsochroneModel.shared.setModeOfTransport(mode: JSON_TRANSPORT_MODE_ARRAY[pickerView.selectedRow(inComponent: 0)])
            
            navigationController?.popViewController(animated: true)
//            self.dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "No address entered", message: "Please enter a new address to load a new isochone.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default)
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
        }
        
    }

    func geocodeAddress(addressInput: String) {
        sharedGeocodingModel.setAddress(input: addressInput)
        self.sharedGeocodingModel.geocode { i in
            DispatchQueue.main.async {
                self.sharedGeocodingModel.outputCoordinates = i
                IsochroneModel.shared.setLatLong(lat: self.sharedGeocodingModel.outputCoordinates.latitude, lng: self.sharedGeocodingModel.outputCoordinates.longitude)
            }
            
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
