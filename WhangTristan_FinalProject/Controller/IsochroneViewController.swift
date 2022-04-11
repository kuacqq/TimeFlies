//
//  IsochroneViewController.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/9/22.
//

import UIKit
import MapKit

class IsochroneViewController: UIViewController, MKMapViewDelegate {
    
    
    var myInitLocation = CLLocationCoordinate2D(latitude: 51.50553730266506, longitude: -0.12818042746366376)
    var sharedIsochoneModel = IsochroneModel.shared
    var coordinatesToMap: [[CLLocationCoordinate2D]] = []
    
    @IBOutlet weak var isochroneMapView: MKMapView! {
        didSet {
            #if targetEnvironment(simulator)
            isochroneMapView?.showsTraffic = false
            #endif
        }
    }
    
    
    @IBAction func buttonDidTapped(_ sender: Any) {
        print("IsochroneViewController: \(#function)")
        loadIsochrone()
        DispatchQueue.main.async {
            self.createPolyLine()
        }
    }
    
    
    
    override func viewDidLoad() {
        print("IsochroneViewController: \(#function)")
        super.viewDidLoad()
        isochroneMapView.delegate = self
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        let region = MKCoordinateRegion(center: myInitLocation, span: span)
        isochroneMapView.setRegion(region, animated: true)
        loadIsochrone()
    }
    
    
    /*
     SECTION: Making the polyLine, this uses the IsochroneModel
     to do this.
        -It sets the properties of the line in func mapView(..renderFor)...
        -The actual line is created and added as an overlay in createPolyLine()
        -LoadIsochrone uses the IsochroneModel and the travelTimeAPI to fill out the actual coordinates to map property which is then used to make the overlay.
     */
    func createPolyLine() {
        print("IsochroneViewController: \(#function)")
//        print("   CoordinatesToMap: \(self.coordinatesToMap)")
        for shell in coordinatesToMap {
            let polyLine = MKPolyline(coordinates: shell, count: shell.count)
            isochroneMapView.addOverlay(polyLine)
        }
        
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline) {
            let polyLineRender = MKPolylineRenderer(overlay: overlay)
            polyLineRender.strokeColor = UIColor.purple.withAlphaComponent(0.5)
            polyLineRender.lineWidth = 3
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
                var featureCounter = 0
                let features = i
                for feature in features {
                    let geometry = feature.geometry
                    self.sharedIsochoneModel.GeometryArray.append(geometry)
                    let outtermostCoordinatesArray = geometry.coordinates
                    for coordinatePairArray in outtermostCoordinatesArray {
                        var shell: [CLLocationCoordinate2D] = []
                        for coordinatePair in coordinatePairArray[0] {
                            let coordinatesIn2D = CLLocationCoordinate2D(latitude: CLLocationDegrees(coordinatePair[1]), longitude: CLLocationDegrees(coordinatePair[0]))
                            shell.append(coordinatesIn2D)
                        }
                        self.coordinatesToMap.append(shell)
                    }
                    featureCounter += 1
                }
                print("featureCounter: \(featureCounter)" )
                self.createPolyLine()
            }
        }
        print("\(#function): FINISHED")
    }
    
    
    
}
