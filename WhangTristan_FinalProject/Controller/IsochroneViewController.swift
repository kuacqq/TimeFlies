//
//  IsochroneViewController.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/9/22.
//

import UIKit
import MapKit

class IsochroneViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var isochroneMapView: MKMapView!
    var myInitLocation = CLLocationCoordinate2D(latitude: 32.7767, longitude: -96.7970)
    var sharedIsochoneModel = IsochroneModel.shared
    var coordinatesToMap: [CLLocationCoordinate2D] = []
    
    
    
    override func viewDidLoad() {
        print("IsochroneViewController: \(#function)")
        super.viewDidLoad()
        isochroneMapView.delegate = self
        let span = MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
        let region = MKCoordinateRegion(center: myInitLocation, span: span)
        isochroneMapView.setRegion(region, animated: true)
        loadIsochrone()
    }
    
    @IBAction func buttonDidTapped(_ sender: Any) {
        print("IsochroneViewController: \(#function)")
        loadIsochrone()
        DispatchQueue.main.async {
            self.createPolyLine()
        }
    }
    
    func createPolyLine() {
        print("IsochroneViewController: \(#function)")
        
        let polyLine = MKPolyline(coordinates: self.coordinatesToMap, count: self.coordinatesToMap.count)
        isochroneMapView.addOverlay(polyLine)
    }
    
    func loadIsochrone() {
        print("\(#function)")
        sharedIsochoneModel.getIsochrone { i in
            DispatchQueue.main.async {
                let shapes = i
                for shape in shapes {
                    for coordinatePair in shape.shell {
                        let coord = CLLocationCoordinate2D(latitude: coordinatePair.lat
                                                           , longitude: coordinatePair.lng)
                        self.coordinatesToMap.append(coord)
                    }
                }
            }
        }
    }
    
    
    
}
