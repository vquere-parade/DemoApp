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
    
    private var observations = [NSKeyValueObservation]()
    
    override func startFallDetection() {
        shoeManager = ShoeManager()
        
        var observation = shoeManager.observe(\.state, options: .new) { [unowned self] shoeManager, _ in
            if shoeManager.state == .poweredOn {
                guard UserDefaults.standard.string(forKey: "shoeIdentifier") == nil else {
                    shoeManager.scanForPeripherals(withServices: nil, options: nil)
                    
                    return
                }
                
                self.activityIndicator.isHidden = true
                    
                self.pairLabel.isHidden = false
                self.pairButton.isHidden = false
            }
        }
        
        observations.append(observation)
        
        observation = shoeManager.observe(\.shoe, options: .new) { [unowned self] shoeManager, _ in
            if shoeManager.shoe == nil {
                self.cancelFallAnimation()
            }
            
            self.demoView.isHidden = shoeManager.shoe == nil
                
            self.activityIndicator.isHidden = shoeManager.shoe != nil
            
            let shoeIdentifier =  UserDefaults.standard.string(forKey: "shoeIdentifier")
            self.pairLabel.isHidden = shoeIdentifier != nil
            self.pairButton.isHidden = shoeIdentifier != nil
        }
        
        observations.append(observation)
        
        observation = shoeManager.observe(\.fall, options: .new) { [unowned self] shoeManager, _ in
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            self.startFallAnimation()
        }
        
        observations.append(observation)
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
