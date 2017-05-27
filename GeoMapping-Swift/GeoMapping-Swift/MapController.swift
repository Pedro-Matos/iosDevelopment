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
    
    //MARK: - PERSISTENCE
    private func loadLocs() -> [Locations]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Locations.ArchiveURL.path) as? [Locations]
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





