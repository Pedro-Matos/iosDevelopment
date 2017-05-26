//
//  PeersViewController.swift
//  GeoMapping-Swift
//
//  Created by Pedro Ferreira de Matos on 25/05/17.
//  Copyright © 2017 Pedro Ferreira de Matos. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import os.log

class PeersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MPCManagerDelegate {
    

    @IBOutlet weak var tblPeers: UITableView!
    
    var isAdvertising: Bool!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let dataService = MPCManager()
    
    var locs = [Locations]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblPeers.delegate = self
        tblPeers.dataSource = self
        dataService.delegate = self
        
        //load the locations
        loadSampleLocations()
        
        isAdvertising = true
        
        dataService.browser.startBrowsingForPeers()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: UITableView related method implementation

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataService.foundPeers.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "idCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PeersCellViewController  else {
            fatalError("The dequeued cell is not an instance of PeersCellViewController.")
        }
        
        cell.peerID_label?.text = dataService.foundPeers[indexPath.row].displayName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPeer = dataService.foundPeers[indexPath.row] as MCPeerID
        
        dataService.browser.invitePeer(selectedPeer, to: dataService.session, withContext: nil, timeout: 20)
    }
    
    
    @IBAction func startStopAdvertising(_ sender: Any) {
        let actionSheet = UIAlertController(title: "", message: "Change Visibility", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        var actionTitle: String
        if isAdvertising == true {
            actionTitle = "Make me invisible to others"
        }
        else{
            actionTitle = "Make me visible to others"
        }
        
        let visibilityAction: UIAlertAction = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default) { (alertAction) -> Void in
            if self.isAdvertising == true {
                self.dataService.advertiser.stopAdvertisingPeer()
            }
            else{
                self.dataService.advertiser.startAdvertisingPeer()
            }
            
            self.isAdvertising = !self.isAdvertising
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
            
        }
        
        actionSheet.addAction(visibilityAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: MULTIPEER FUNCTIONS
    func foundPeer() {
        tblPeers.reloadData()
    }
    
    
    func lostPeer() {
        tblPeers.reloadData()
    }
    
    func invitationWasReceived(fromPeer: String) {
        let alert = UIAlertController(title: "", message: "\(fromPeer) wants to chat with you.", preferredStyle: UIAlertControllerStyle.alert)
        
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.dataService.invitationHandler(true, self.dataService.session)
        }
        
        let declineAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
            self.dataService.invitationHandler(false, nil)
        }
        
        alert.addAction(acceptAction)
        alert.addAction(declineAction)
        
        OperationQueue.main.addOperation { () -> Void in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func connectedWithPeer(peerID: MCPeerID) {
        
        let alert = UIAlertController(title: "", message: "\(peerID.displayName) is connected to you :D", preferredStyle: UIAlertControllerStyle.alert)
        
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            NSLog("%@", "Peer is connected to: \(peerID.displayName)")
        }

        
        alert.addAction(acceptAction)
        
        self.present(alert, animated: true, completion: nil)
        
        
        //Enviar dados
        var locs_dic :  [Int: Locations] = [:]
        
        if(locs.count > 0){
            var i = 0
            while i < locs.count {
                locs_dic[i] = locs[i]
                i = i + 1
            }
            
            print("dictionary: \(locs_dic)")
            let state = dataService.sendData(locations: locs_dic)
            
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
        
        
        
        
        
    }
    
    func dataChanged(manager: MPCManager, data: Dictionary<Int, Locations>) {
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

    
    
    

}
