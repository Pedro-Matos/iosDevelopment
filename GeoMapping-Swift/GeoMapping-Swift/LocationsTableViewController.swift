//
//  LocationsTableViewController.swift
//  GeoMapping-Swift
//
//  Created by Pedro Ferreira de Matos on 18/05/17.
//  Copyright © 2017 Pedro Ferreira de Matos. All rights reserved.
//

import UIKit
import os.log

class LocationsTableViewController: UITableViewController {

    
    //MARK: Properties
    var locs = [Locations]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //load the sample data
        loadSampleLocations()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.rightBarButtonItem = editButtonItem
        
    }
    
    public func loadSampleLocations(){
        if let savedMeals = loadLocs() {
            locs += savedMeals
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
    
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "LocationsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LocationsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of LocationsTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let loc = locs[indexPath.row]
        
        cell.photoImageView.image = loc.photo
        cell.coords.text = loc.coords
        cell.nameLabel.text = loc.name

        return cell
    }
    
    //MARK: - PERSISTENCE
    private func loadLocs() -> [Locations]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Locations.ArchiveURL.path) as? [Locations]
    }
    
    private func saveLocs() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(locs, toFile: Locations.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
        
    }
    
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            locs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveLocs()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
