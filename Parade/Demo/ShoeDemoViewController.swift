//
//  ShoeDemoViewController.swift
//  Parade
//
//  Created by Simon Le Bras on 14/09/2018.
//  Copyright © 2018 Parade Protection. All rights reserved.
//

import UIKit
import CoreLocation

class ShoeDemoViewController: BaseDemoViewController {
    private let locationManager = CLLocationManager()
    
    private let beaconRegion: CLBeaconRegion = {
        let region = CLBeaconRegion(
            proximityUUID: UUID(uuidString: "dfe942fe-cfdf-4838-90c5-07dbcaa8f620")!,
            identifier: "parade-demo-shoe"
        )
        
        region.notifyEntryStateOnDisplay = true
        
        return region
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    override func startFallDetection() {
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    override func stopFallDetection() {
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(in: beaconRegion)
        
        super.stopFallDetection()
    }
}

extension ShoeDemoViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if region.identifier == beaconRegion.identifier && !beacons.isEmpty {
            startFallAnimation()
        }
    }
}
