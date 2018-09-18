//
//  ShoeDemoViewController.swift
//  Parade
//
//  Created by Simon Le Bras on 14/09/2018.
//  Copyright © 2018 Parade Protection. All rights reserved.
//

import UIKit
import CoreBluetooth
import AudioToolbox

class ShoeDemoViewController: BaseDemoViewController {
    @IBOutlet weak var pairLabel: UILabel!
    
    @IBOutlet weak var pairButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var shoeManager: ShoeManager!
    
    private var stateObservation: NSKeyValueObservation!
    private var shoeObservation: NSKeyValueObservation!
    private var fallObservation: NSKeyValueObservation!
    
    override func startFallDetection() {
        shoeManager = ShoeManager()
        
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
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            self.startFallAnimation()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PairingSegue" {
            let viewController = segue.destination as! PairingViewController
            viewController.shoeManager = shoeManager
        }
    }
    
    deinit {
        shoeManager.stopScan()
    }
}
