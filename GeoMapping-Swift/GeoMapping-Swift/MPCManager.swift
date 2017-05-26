//
//  MPCManager.swift
//  GeoMapping-Swift
//
//  Created by Pedro Ferreira de Matos on 25/05/17.
//  Copyright © 2017 Pedro Ferreira de Matos. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class MPCManager: NSObject{
    
    var session: MCSession!
    
    var peer: MCPeerID!
    
    var browser: MCNearbyServiceBrowser!
    
    var advertiser: MCNearbyServiceAdvertiser!
    
    var foundPeers = [MCPeerID]()
    
    var invitationHandler: ((Bool, MCSession?)->Void)!
    
    var delegate: MPCManagerDelegate?
    
    override init() {
        super.init()
        
        peer = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peer)
        session.delegate = self as MCSessionDelegate
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: "PedroTiago-mpc")
        browser.delegate = self as MCNearbyServiceBrowserDelegate
        
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: "PedroTiago-mpc")
        advertiser.delegate = self as MCNearbyServiceAdvertiserDelegate
    }
    
    func connectedWithPeer(peerID: MCPeerID) {
        NSLog("%@", "CONNECTED :D")
    }
    
    

    func sendData(locations : Dictionary<Int, Locations>) -> Bool {
        let dataToSend = NSKeyedArchiver.archivedData(withRootObject: locations)
        
        if session.connectedPeers.count > 0 {
            do {
                NSLog("%@", "Send Locations to \(session.connectedPeers.count) peers")
                try self.session.send(dataToSend, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
            return true
        }
        else{
            return false
        }
        
    }
}

extension MPCManager : MCNearbyServiceAdvertiserDelegate {
    

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error.localizedDescription)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping ((Bool, MCSession?) -> Void)) {
        self.invitationHandler = invitationHandler
        
        delegate?.invitationWasReceived(fromPeer: peerID.displayName)
    }
}

extension MPCManager : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", error.localizedDescription)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        if peerID.displayName != UIDevice.current.name{
            
            if(!foundPeers.map{$0.displayName}.contains(peerID.displayName)){
                NSLog("%@", "invitePeer: \(peerID)")
                foundPeers.append(peerID)
                delegate?.foundPeer()
            }
            else{
                NSLog("%@", "Peer already connected: \(peerID)")
            }
        }
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        for (index, aPeer) in foundPeers.enumerated(){
            if aPeer == peerID {
                foundPeers.remove(at: index)
                break
            }
        }
        
        delegate?.lostPeer()
    }

}

extension MPCManager : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state{
        case MCSessionState.connected:
            NSLog("%@", "Connected to session: \(session)")
            delegate?.connectedWithPeer(peerID: peerID)
            
        case MCSessionState.connecting:
            NSLog("%@", "Connecting to session: \(session)")
            
        default:
            NSLog("%@", "Did not connect to session: \(session)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        //let dic: [String: String] = NSKeyedArchiver.
        let dictionary: Dictionary? = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Int : Locations]
        self.delegate?.dataChanged(manager: self, data: dictionary!)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
    
}

 

protocol MPCManagerDelegate {
    func foundPeer()
    
    func lostPeer()
    
    func invitationWasReceived(fromPeer: String)
    
    func connectedWithPeer(peerID: MCPeerID)
    
    func dataChanged(manager : MPCManager, data: Dictionary<Int, Locations>)
}
