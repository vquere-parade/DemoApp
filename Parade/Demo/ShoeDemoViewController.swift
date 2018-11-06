//
//  ShoeDemoViewController.swift
//  Parade
//
//  Created by Simon Le Bras on 14/09/2018.
//  Copyright © 2018 Parade Protection. All rights reserved.
//

import UIKit
import CoreBluetooth
// psam
import CoreLocation
// /psam

class ShoeDemoViewController: BaseDemoViewController {
    @IBOutlet weak var pairLabel: UILabel!
    
    @IBOutlet weak var pairButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var shoeManager: ShoeManager!
    
    private var stateObservation: NSKeyValueObservation!
    private var shoeObservation: NSKeyValueObservation!
    private var fallObservation: NSKeyValueObservation!
// psam
    let locationManager = CLLocationManager()
    let beaconRegion = CLBeaconRegion(
        proximityUUID: UUID(uuidString: "dfe942fe-cfdf-4838-90c5-07dbcaa8f620")!,major:0,minor:0, identifier: "e-vone")
    let kontaktRegion = CLBeaconRegion(
        proximityUUID: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, identifier: "ktk")
// /psam

    override func startFallDetection() {
// psam
        //locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        for r in locationManager.monitoredRegions {
            print("cleanup monitored region \(r)")
            locationManager.stopMonitoring(for: r)
        }
        locationManager.startMonitoring(for: beaconRegion)
        //locationManager.startMonitoring(for: kontaktRegion)
        //locationManager.startRangingBeacons(in: beaconRegion)
        //locationManager.startRangingBeacons(in: kontaktRegion)
        print("Monitored: \(locationManager.monitoredRegions)")
        activityIndicator.isHidden = true
        demoView.isHidden = false
// /psam
//        shoeManager = ShoeManager()
/*
        stateObservation = shoeManager.observe(\.state, options: .new) { [unowned self] shoeManager, _ in
            if shoeManager.state == .poweredOn {
                guard UserDefaults.standard.string(forKey: "shoeIdentifier") == nil else {
                    shoeManager.scanForPeripherals()
                    
                    return
                }
                
                self.activityIndicator.isHidden = true
                    
                self.pairLabel.isHidden = false
                self.pairButton.isHidden = false
            }
        }
        
        shoeObservation = shoeManager.observe(\.shoe, options: .new) { [unowned self] shoeManager, _ in
            if shoeManager.shoe == nil {
                self.cancelFallAnimation()
            }
            
            self.demoView.isHidden = shoeManager.shoe == nil
                
            self.activityIndicator.isHidden = shoeManager.shoe != nil
            
            let shoeIdentifier =  UserDefaults.standard.string(forKey: "shoeIdentifier")
            self.pairLabel.isHidden = shoeIdentifier != nil
            self.pairButton.isHidden = shoeIdentifier != nil
        }
        
        fallObservation = shoeManager.observe(\.fall, options: .new) { [unowned self] shoeManager, _ in
            self.startFallAnimation()
        }*/
    }
/*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PairingSegue" {
            let viewController = segue.destination as! PairingViewController
            viewController.shoeManager = shoeManager
        }
    }*/
    
    deinit {
//        shoeManager.stopScan()
// psam
        //locationManager.stopRangingBeacons(in: beaconRegion)
        //locationManager.stopRangingBeacons(in: kontaktRegion)
        locationManager.stopMonitoring(for: beaconRegion)
        //locationManager.stopMonitoring(for: kontaktRegion)
        print("stopMonitoring")
// /psam
    }
}
// psam
// MARK: - CLLocationManagerDelegate
extension ShoeDemoViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("monitoringDidFail: \(error.localizedDescription)")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error.localizedDescription)")
    }
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        print("rangingBeaconsDidFail: \(error.localizedDescription)")
    }
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("didPauseLocationUpdates")
    }
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("didResumeResumeLocationUpdates")
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuth: \(status.rawValue)")
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for b in beacons {
            print("beacon: \(b)")
        }
    }
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("didStartMonitoringFor: \(region)")
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didEnterRegion: \(region)")
        startFallAnimation()
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("didExitRegion: \(region)")
        cancelFallAnimation()
    }
}
// /psam
