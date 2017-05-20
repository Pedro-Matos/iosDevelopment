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

class MapController: UIViewController {
    var locationManager: CLLocationManager?
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    let dataService = DataTransferServiceManagement()
    
    
    @IBAction func logOut(_ sender: Any) {
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
        
        dataService.delegate = self
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
        
        let homeLocation = locationManager?.location
        centerMapOnLocation(location: homeLocation!)
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
    
    @IBAction func sendData(_ sender: Any) {
        dataService.send(locations: "teste")
        
    }
}

extension MapController : DataTransferServiceManagementDelegate {
    
    func connectedDevicesChanged(manager: DataTransferServiceManagement, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            print("Connections: \(connectedDevices)")
        }
    }
    
    func dataChanged(manager: DataTransferServiceManagement, data: String) {
        OperationQueue.main.addOperation {
            print("Teste: dataChanged")
            let alertController = UIAlertController(title: "Data Received", message: "Data received by multipeer!", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}




