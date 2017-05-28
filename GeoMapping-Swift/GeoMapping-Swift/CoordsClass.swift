//
//  CoordsClass.swift
//  GeoMapping-Swift
//
//  Created by Pedro Ferreira de Matos on 28/05/17.
//  Copyright © 2017 Pedro Ferreira de Matos. All rights reserved.
//


import Foundation
import UIKit
import os.log

class CoordsClass: NSObject, NSCoding {
    
    //MARK: Properties
    var latitude: String
    var longitude: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("pins_visited")
    
    
    //MARK: Types
    struct PropertyKey {
        static let latitude = "latitude"
        static let longitude = "longitude"
        
    }
    
    
    //MARK: Initialization
    
    init?(latitude: String, longitude: String) {
        
        // The name must not be empty
        guard !latitude.isEmpty else {
            return nil
        }
        
        // The name must not be empty
        guard !longitude.isEmpty else {
            return nil
        }
        
        
        // Initialize stored properties.
        self.latitude = latitude
        self.longitude = longitude
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(latitude, forKey: PropertyKey.latitude)
        aCoder.encode(longitude, forKey: PropertyKey.longitude)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let latitude = aDecoder.decodeObject(forKey: PropertyKey.latitude) as? String else {
            os_log("Unable to decode the latitute for a Coords object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let longitude = aDecoder.decodeObject(forKey: PropertyKey.longitude) as? String else {
            os_log("Unable to decode the longitude for a Coords object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(latitude: latitude, longitude: longitude)
    }
    
    
    
    
}
