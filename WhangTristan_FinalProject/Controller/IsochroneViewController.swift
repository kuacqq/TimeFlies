//
//  IsochroneViewController.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/9/22.
//

import UIKit
import MapKit

class IsochroneViewController: UIViewController, MKMapViewDelegate {
    
    var sharedGeocodingModel = GeocodingModel.shared
    var myInitLocation = CLLocationCoordinate2D(latitude: 51.50553730266506, longitude: -0.12818042746366376)
    var sharedIsochoneModel = IsochroneModel.shared
    var coordinatesToMap: [[CLLocationCoordinate2D]] = []
    var query: String?
    
    
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
    }
    @IBAction func clearButtonDidTapped(_ sender: Any) {
        self.removeAllPolyLines()
    }
    
    @IBAction func realignButtonDidTapped(_ sender: Any) {
        print("\(#function)")
        realignView()
    }
    func realignView() {
        if let lat = sharedIsochoneModel.inputLatDouble, let lng = sharedIsochoneModel.inputLngDouble {
            print("   lat: \(lat), lng: \(lng)")
            let currentLocation = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            let region = MKCoordinateRegion(center: currentLocation, span: span)
            isochroneMapView.setRegion(region, animated: true)
//            DispatchQueue.main.async { [self] in
//
//            }
        }
    }
    
    
    override func viewDidLoad() {
        print("IsochroneViewController: \(#function)")
        super.viewDidLoad()
        isochroneMapView.delegate = self
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        let region = MKCoordinateRegion(center: myInitLocation, span: span)
        isochroneMapView.setRegion(region, animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        /*
         uncomment loadIsochone to enable the api again.
         */
        if let query = sharedIsochoneModel.inputAddress {
            geocodeAddress(addressInput: query)
            sharedIsochoneModel.inputAddress = nil
        } else {
            self.realignView()
            self.loadIsochrone()
        }
        
        
    }
    func geocodeAddress(addressInput: String) {
        sharedGeocodingModel.setAddress(input: addressInput)
        self.sharedGeocodingModel.geocode { i in
            DispatchQueue.main.async {
                self.sharedGeocodingModel.outputCoordinates = i
                IsochroneModel.shared.setLatLong(lat: self.sharedGeocodingModel.outputCoordinates.latitude, lng: self.sharedGeocodingModel.outputCoordinates.longitude)
                self.realignView()
                self.loadIsochrone()
            }
            
        }
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
    
    func removeAllPolyLines() {
        let currentOverlays = self.isochroneMapView.overlays
        isochroneMapView.removeOverlays(currentOverlays)
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
                    var newCoordinatesToMap: [[CLLocationCoordinate2D]] = []
                    let geometry = feature.geometry
                    self.sharedIsochoneModel.GeometryArray.append(geometry)
                    let outtermostCoordinatesArray = geometry.coordinates
                    for coordinatePairArray in outtermostCoordinatesArray {
                        var shell: [CLLocationCoordinate2D] = []
                        for coordinatePair in coordinatePairArray[0] {
                            let coordinatesIn2D = CLLocationCoordinate2D(latitude: CLLocationDegrees(coordinatePair[1]), longitude: CLLocationDegrees(coordinatePair[0]))
                            shell.append(coordinatesIn2D)
                        }
                        newCoordinatesToMap.append(shell)
                    }
                    self.coordinatesToMap = newCoordinatesToMap
                    featureCounter += 1
                }
                print("featureCounter: \(featureCounter)" )
                self.createPolyLine()
            }
        }
        print("\(#function): FINISHED")
    }
    
    
    /*
     segues to change the navigation parameters
     */
//    extension IsochroneViewController {
//        @IBAction func doneToIsochroneViewController(_ segue: UIStoryboardSegue) {
//
//        }
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let inputViewController = segue.destination as? input_isochroneViewController
//        {
//            DispatchQueue.main.async {
//
//                inputViewController.inputParametersChanged = {
//                    // you can add stuff to get rid of the previous isochrone map.
////                    self.removeAllPolyLines()
////                    self.loadIsochrone()
//                }
//            }
//        }
    }
}
