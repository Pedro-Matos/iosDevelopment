//
//  Locations.swift
//  GeoMapping-Swift
//
//  Created by Pedro Ferreira de Matos on 18/05/17.
//  Copyright © 2017 Pedro Ferreira de Matos. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Locations: NSObject, NSCoding {
    
    //MARK: Properties
    var name: String
    var coords: String
    var photo: UIImage?
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("locs")
    
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let coords = "coords"
        static let photo = "photo"
    }
    
    
    //MARK: Initialization
    
    init?(name: String, coords: String, photo: UIImage?) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The name must not be empty
        guard !coords.isEmpty else {
            return nil
        }
        
        
        // Initialize stored properties.
        self.name = name
        self.coords = coords
        self.photo = photo
        
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(coords, forKey: PropertyKey.coords)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let coords = aDecoder.decodeObject(forKey: PropertyKey.coords) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(name: name, coords: coords, photo: photo)

    }
    
    
    
    
}
