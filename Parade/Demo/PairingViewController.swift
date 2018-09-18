//
//  PairingViewController.swift
//  Parade
//
//  Created by Simon Le Bras on 14/09/2018.
//  Copyright © 2018 Parade Protection. All rights reserved.
//

import UIKit
import CoreBluetooth

class PairingViewController: UITableViewController {
    var shoeManager: ShoeManager!
    
    private var peripherals = [CBPeripheral]()
    private var peripheralsObservervation: NSKeyValueObservation!
    
    override func viewDidLoad() {
        shoeManager.scanForPeripherals()
        
        peripheralsObservervation = shoeManager.observe(\.discoveredPeripherals, options: .new) { [unowned self] _, change in
            self.peripherals = self.shoeManager.discoveredPeripherals
            self.tableView.reloadData()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as! DeviceCell
        
        cell.name.text = peripherals[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shoeManager.connect(peripheral: peripherals[indexPath.row])
        
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        shoeManager.stopScan()
    }
}
