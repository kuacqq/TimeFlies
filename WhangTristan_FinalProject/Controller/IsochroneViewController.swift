//
//  IsochroneViewController.swift
//  WhangTristan_FinalProject
//
//  Created by tristan whang on 4/9/22.
//

import UIKit
import MapKit

class IsochroneViewController: UIViewController, MKMapViewDelegate {
    /*
     Singleton Setup
     */
    var sharedGeocodingModel = GeocodingModel.shared
    var sharedIsochoneModel = IsochroneModel.shared
    
    /*
     Other Class Properties
     */
    var myInitLocation = CLLocationCoordinate2D(latitude: 51.50553730266506, longitude: -0.12818042746366376)
    var coordinatesToMap: [[CLLocationCoordinate2D]] = []
    var query: String?
    
    /*
     IBOutlets
     */
    // I just set the property of the map to not show traffic. This was just to get rid of some of the xcode warnings that clogged up the console. However, this does not remove all of them, most notably the compile errors from generating poly lines.
    @IBOutlet weak var isochroneMapView: MKMapView! {
        didSet {
            #if targetEnvironment(simulator)
            isochroneMapView?.showsTraffic = false
            #endif
        }
    }
    // these IBOutlets have their titles localized at the bottom of the file.
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var modifyBarButton: UIBarButtonItem!
    
    /*
     Functions:
     */
    // viewDidLoad just does some initial setup in terms of modifying the starting location and perspective the user has on the mapView.
    // The initial locaiton just happens to be at the heart of london.
    override func viewDidLoad() {
        print("IsochroneViewController: \(#function)")
        super.viewDidLoad()
        isochroneMapView.delegate = self
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        let region = MKCoordinateRegion(center: myInitLocation, span: span)
        isochroneMapView.setRegion(region, animated: true)
        localizeButtons()
    }
    
    // viewWillAppear is primarily to reload the display after making changes in input_isochroneViewController.
    override func viewWillAppear(_ animated: Bool) {
        if let query = sharedIsochoneModel.inputAddress {
            geocodeAddress(addressInput: query)
            sharedIsochoneModel.inputAddress = nil
        } else {
            self.realignView()
            self.loadIsochrone()
        }
    }
    
    // buttonDidTapped (this is the load button). The load button just reloads the isochrone model. This is mainly so that you can clear all your previously generated isochrones and just load the one that you just entered in input_isochroneViewController.
    @IBAction func buttonDidTapped(_ sender: Any) {
        print("IsochroneViewController: \(#function)")
        loadIsochrone()
    }
    
    // clearButtonDidTapped just removes all the polylines/polygons overlayed on the mapView.
    @IBAction func clearButtonDidTapped(_ sender: Any) {
        self.removeAllPolyLines()
    }
    
    // realignButtonDidTapped just calls the realign view function on the butotn press
    @IBAction func realignButtonDidTapped(_ sender: Any) {
        print("\(#function)")
        realignView()
    }
    
    // realigns the view relative to the starting location of your generated isochrone.
    func realignView() {
        if let lat = sharedIsochoneModel.inputLatDouble, let lng = sharedIsochoneModel.inputLngDouble {
            print("   lat: \(lat), lng: \(lng)")
            let currentLocation = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            let region = MKCoordinateRegion(center: currentLocation, span: span)
            isochroneMapView.setRegion(region, animated: true)
        }
    }
    
    // geocodeAddress takes in an address and geocodes it. This then immediately realigns the view and loads the respective isochrone.
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
    
    // creates the poly lines using the coordinates to map. The coordinates to map is of type [[CLLocationCoordinate2D]] and so for each of the shells you have to make a different poly line to wrap around those locations
    func createPolyLine() {
        print("IsochroneViewController: \(#function)")
        for shell in coordinatesToMap {
            let polyLine = MKPolyline(coordinates: shell, count: shell.count)
            isochroneMapView.addOverlay(polyLine)
        }
    }
    // creates the polygons using the coordinates to map. The coordinates to map is of type [[CLLocationCoordinate2D]] and so for each of the shells you have to make a different polygon to cover those areas.
    func addPolygon() {
        print("IsochroneViewController: \(#function)")
        for shell in coordinatesToMap {
            let polygon = MKPolygon(coordinates: shell, count: shell.count)
            isochroneMapView.addOverlay(polygon)
        }
    }
    
    // removes all the poly lines and polygons.
    func removeAllPolyLines() {
        let currentOverlays = self.isochroneMapView.overlays
        isochroneMapView.removeOverlays(currentOverlays)
    }
    
    // This is the function that actually renders the poly lines and polygons on the map.
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline) {
            let polyLineRender = MKPolylineRenderer(overlay: overlay)
            polyLineRender.strokeColor = UIColor.purple.withAlphaComponent(0.5)
            polyLineRender.lineWidth = 3
            return polyLineRender
        } else if (overlay is MKPolygon) {
            let polygonRender = MKPolygonRenderer(overlay: overlay)
            polygonRender.fillColor = UIColor.blue.withAlphaComponent(0.2)
            return polygonRender
        }
        return MKOverlayRenderer()
    }
    
    // loadIsochrone triggers the api call in isochroneModel and parses the information storing it in shells and then the coordinate map of this view controller. Then it calls add polygon to render the polygon.
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
//                self.createPolyLine()
                self.addPolygon()
            }
        }
        print("\(#function): FINISHED")
    }
    
    
    
    /*
     Localizing functions
     */
    // localizes the titles of the buttons, including the bar button item.
    func localizeButtons() {
        loadButton.setTitle(NSLocalizedString("load_text", comment: ""), for: .normal)
        clearButton.setTitle(NSLocalizedString("clear_text", comment: ""), for: .normal)
        modifyBarButton.title = NSLocalizedString("modify_text", comment: "")
    }
    
    
}
