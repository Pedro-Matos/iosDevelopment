//
//  QRController.swift
//  GeoMapping-Swift
//
//  Created by Pedro Ferreira de Matos on 16/05/17.
//  Copyright © 2017 Pedro Ferreira de Matos. All rights reserved.
//

import UIKit
import AVFoundation
import os.log
import CoreLocation

class QRController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    
    
    let textCellIdentifier = "TextCell"
    
    @IBOutlet var topbar: UIToolbar!
    @IBOutlet var messageLabel: UILabel!
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var locs = [Locations]()
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //user location
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        //load the locations
        loadSampleLocations()
    
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()
            
            
            // Move the message label and top bar to the front
            view.bringSubview(toFront: messageLabel)
            view.bringSubview(toFront: topbar)
            

            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                
                var tmp = 0
                if locs.count > 0{
                    for i in 0..<locs.count{
                        if locs[i].name == metadataObj.stringValue {
                            tmp = 1
                        }
                    }
                }
                
                if tmp == 0{
                    print(metadataObj.stringValue)
                    let homeLocation = locationManager?.location
                    let lat = String(format : "%.3f", (homeLocation?.coordinate.latitude)!)
                    let long = String(format : "%.3f", (homeLocation?.coordinate.longitude)!)
                    let coords = "Lat: " + lat+"; Long: "+long
                    loadSampleLocations(name_qr: metadataObj.stringValue, coords: coords)
                    
                    
                
                }
                
                
                
            }
        }
    }
    
    public func loadSampleLocations(name_qr: String, coords: String){
        let photo1 = UIImage(named: "Map")
        
        guard let loc1 = Locations(name: name_qr, coords: coords, photo: photo1) else {
            fatalError("Unable to instantiate meal1")
        }
        
        locs += [loc1]
        
        saveLocs()
    }
    
    private func saveLocs() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(locs, toFile: Locations.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    
   
}
