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
    var myInitLocation = CLLocationCoordinate2D(latitude: 51.50553730266506, longitude: -0.12818042746366376)
    var sharedIsochoneModel = IsochroneModel.shared
    var coordinatesToMap: [CLLocationCoordinate2D] = []
    
    
    
    override func viewDidLoad() {
        print("IsochroneViewController: \(#function)")
        super.viewDidLoad()
        isochroneMapView.delegate = self
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        let region = MKCoordinateRegion(center: myInitLocation, span: span)
        isochroneMapView.setRegion(region, animated: true)
        loadIsochrone()
    }
    
    @IBAction func buttonDidTapped(_ sender: Any) {
        print("IsochroneViewController: \(#function)")
//        print("IsochroneViewController: \(coordinatesToMap)")
        loadIsochrone()
        DispatchQueue.main.async {
            self.createPolyLine()
        }
    }
    
    func createPolyLine() {
        print("IsochroneViewController: \(#function)")
//        print("   CoordinatesToMap: \(self.coordinatesToMap)")
        
        let polyLine = MKPolyline(coordinates: self.coordinatesToMap, count: self.coordinatesToMap.count)
        isochroneMapView.addOverlay(polyLine)
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline) {
            let polyLineRender = MKPolylineRenderer(overlay: overlay)
            polyLineRender.strokeColor = UIColor.purple.withAlphaComponent(0.5)
            polyLineRender.lineWidth = 5
            return polyLineRender
        }
        return MKOverlayRenderer()
    }
    
    
    /*
     was getting this error so this is my trying to fix it
     2022-04-10 16:16:20.602852-0700 WhangTristan_FinalProject[74964:9098061] Compiler error: Invalid library file
     */
    
    
    func loadIsochrone() {
        print("\(#function)")
        sharedIsochoneModel.getIsochrone { i in
            DispatchQueue.main.async {
                let features = i
                for feature in features {
                    let geometry = feature.geometry
                    self.sharedIsochoneModel.GeometryArray.append(geometry)
                    let outtermostCoordinatesArray = geometry.coordinates
                    for coordinatePair in outtermostCoordinatesArray[0][0] {
                        self.coordinatesToMap.append(CLLocationCoordinate2D(latitude: CLLocationDegrees(coordinatePair[1]), longitude: CLLocationDegrees(coordinatePair[0])))
                    }
                    
                }
                self.createPolyLine()
            }
        }
        print("\(#function): FINISHED")
    }
    
    
    
}
