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
    
    
    //let dataService = DataTransferServiceManagement()
    
    var locs = [Locations]()
    
    
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
        
        //load the locations
        loadSampleLocations()
        
        //dataService.delegate = self
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
        
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
    
    /*@IBAction func sendData(_ sender: Any) {
        
        /*let locs_dic = entries.reduce([Int:Locations]()) { (var dict, entry) in
            let elements = entry.characters.split("=").map(String.init)
            dict[elements[0]] = elements[1]
            return dict
        }*/
        
        var locs_dic :  [Int: Locations] = [:]
        
        if(locs.count > 0){
            var i = 0
            while i < locs.count {
                locs_dic[i] = locs[i]
                i = i + 1
            }
            
            print("dictionary: \(locs_dic)")
            let state = dataService.send(locations: locs_dic)
            
            if (!state){
                let alertController = UIAlertController(title: " No connections", message: "0 peers connected!", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        else{
            //popup para dizer que nao ha valores
            let alertController = UIAlertController(title: "Can't send data", message: "Don't have enought data to send", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
    }*/
}

/*extension MapController : DataTransferServiceManagementDelegate {
    
    func connectedDevicesChanged(manager: DataTransferServiceManagement, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            print("Connections: \(connectedDevices)")
        }
    }
    
    func dataChanged(manager: DataTransferServiceManagement, data: Dictionary<Int, Locations>) {
        OperationQueue.main.addOperation {
            
            var locs_tmp = [Locations]()
            print("dictionary_received: \(data)")
            var i = 0
            while i < data.count {
                let l = data[i]!
                
                
                var tmp = 0
                if self.locs.count > 0{
                    for i in 0..<self.locs.count{
                        if self.locs[i].name == l.name {
                            tmp = 1
                        }
                    }
                }
                
                if tmp == 0{
                    locs_tmp += [l]
                }
                
                i = i + 1
            }
            
            self.locs += locs_tmp
            self.saveLocs()
            
            print("Teste: dataChanged")
            let alertController = UIAlertController(title: "Data Received", message: String(data.count), preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func saveLocs() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(locs, toFile: Locations.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
        
    }
    
}*/




