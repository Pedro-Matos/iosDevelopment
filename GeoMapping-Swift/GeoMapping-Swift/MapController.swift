//
//  MapController.swift
//  GeoMapping-Swift
//
//  Created by Pedro Ferreira de Matos on 16/05/17.
//  Copyright © 2017 Pedro Ferreira de Matos. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation
import os.log

class MapController: UIViewController {
    var locationManager: CLLocationManager?
    
    @IBOutlet weak var mapView: MKMapView!
    
    var isSession: Bool!
    
    //let dataService = DataTransferServiceManagement()
    
    var locs = [Locations]()
    
    var coords_visited = [CoordsClass]()
    
    let session1_anot = ["40.6409015@-8.6537111","40.6391622@-8.6532668","40.6396443@-8.6524315"]
    
    let session2_anot = ["40.6331812@-8.66077","40.6303024@-8.6596947"]
    
    @IBAction func create_session1(_ sender: Any) {
        
    
        //Delete all notations
        let annotations = self.mapView.annotations
         for _annotation in annotations {
            if let annotation = _annotation as? MKAnnotation
            {
                self.mapView.removeAnnotation(annotation)
            }
         }
        
        var sess = [String]()
        
        if self.isSession == true {
            sess = session1_anot
        }
        else{
            sess = session2_anot
        }
        
        self.isSession = !self.isSession
        
        var i = 0
        while i < sess.count {
            let fullName    = sess[i]
            let fullNameArr = fullName.components(separatedBy: "@")
            
            let lat    = fullNameArr[0]
            let long = fullNameArr[1]
            
            let annot = MKPointAnnotation()
            
            annot.coordinate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
            mapView.addAnnotation(annot)
        
            i = i + 1
        }
        
        //casa: @40.6353059,-8.6570489
        //fabrica ciencia viva: @40.636576,-8.6551177
        /*let teste = MKPointAnnotation()
        teste.coordinate = CLLocationCoordinate2D(latitude: 40.636576, longitude: -8.6551177)
        mapView.addAnnotation(teste)
        
        let teste2 = MKPointAnnotation()
        teste2.coordinate = CLLocationCoordinate2D(latitude: 40.6353059, longitude: -8.6570489)
        mapView.addAnnotation(teste2)*/
        
        // casa gisela: @40.6332187,-8.6485305
        let teste2 = MKPointAnnotation()
        teste2.coordinate = CLLocationCoordinate2D(latitude: 40.6332187, longitude: -8.6485305)
        var k = 0
        var tmp = 0
        while k < coords_visited.count{
            let lat = coords_visited[k].latitude
            let long = coords_visited[k].longitude
            
            let coordinate_casa = CLLocation(latitude: 40.6332187, longitude: -8.6485305)
            let coordinate_array = CLLocation(latitude: Double(lat)!, longitude: Double(long)!)
            let distanceInMeters = coordinate_casa.distance(from: coordinate_array)
            
            NSLog("%@", "DISTANCIA: \(distanceInMeters)")
            if(distanceInMeters < 10){
                tmp = 1
                print("xDDDDDDDDDDDDD")
            }
            k = k + 1
        }
        if (tmp == 0){
            mapView.addAnnotation(teste2)
        }
        
        
        NSLog("%@", "INDICE: \(k)")
        
        let teste1 = MKPointAnnotation()
        teste1.coordinate = CLLocationCoordinate2D(latitude: 40.6342187, longitude: -8.6495305)
        mapView.addAnnotation(teste1)
        
        /*let pins = mapView.annotations
        let currentLocation = mapView.userLocation.location!
        
        let nearestPin: MKAnnotation? = pins.reduce((CLLocationDistanceMax, nil)) { (nearest, pin) in
            let coord = pin.coordinate
            let loc = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            let distance = currentLocation.distance(from: loc)
            return distance < nearest.0 ? (distance, pin) : nearest
            }.1
        
        NSLog("%@", "CLOSEEE: \(nearestPin?.coordinate)")*/
        
        
        
    }
    
    
    @IBAction func sign_out(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load the locations
        loadSampleLocations()
        
        loadSampleCoords()
        NSLog("%@", "COORDS_ARRAY: \(coords_visited)")
        
        
        //dataService.delegate = self
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        
        mapView.showsUserLocation = true
        
        isSession = true
        
        let homeLocation = locationManager?.location
        centerMapOnLocation(location: homeLocation!)
    }
    
   
    public func loadSampleLocations(){
        if let savedMeals = loadLocs() {
            locs += savedMeals
        }
    }
     
    public func loadSampleCoords(){
        if let savedMeals = loadCoords() {
            coords_visited += savedMeals
        }
    
    }
    
    //MARK: - PERSISTENCE
    private func loadLocs() -> [Locations]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Locations.ArchiveURL.path) as? [Locations]
    }
    
    
    
    private func loadCoords() -> [CoordsClass]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: CoordsClass.ArchiveURL.path) as? [CoordsClass]
    }
    
    func centerMapOnLocation(location: CLLocation)
    {
        let regionRadius: CLLocationDistance = 200
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}





