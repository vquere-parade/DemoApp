//
//  BluetoothManager.swift
//  Parade
//
//  Created by Simon Le Bras on 14/09/2018.
//  Copyright © 2018 Parade Protection. All rights reserved.
//

import CoreBluetooth

@objc class ShoeManager: NSObject {
    private var centralManager: CBCentralManager!
    
    @objc dynamic var shoe: CBPeripheral?
    
    @objc dynamic var state: CBManagerState = .unknown
    
    @objc dynamic var discoveredPeriphicals = [CBPeripheral]()
    
    @objc dynamic var fall = false
    
    override init() {
        super.init()
        
        let centralQueue: DispatchQueue = DispatchQueue(label: "Central Queue", attributes: .concurrent)
        
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    }
    
    func scanForPeripherals(withServices services: [CBUUID]?, options: [String:Any]?) {
        discoveredPeriphicals.removeAll()
        
        centralManager.scanForPeripherals(withServices: services, options: options)
    }
    
    func stopScan() {
        centralManager.stopScan()
    }
    
    func connect(periphical: CBPeripheral) {
        UserDefaults.standard.set(periphical.identifier.uuidString, forKey: "shoeIdentifier")
        
        shoe = periphical
        shoe!.delegate = self
        
        centralManager.connect(periphical)
    }
}

extension ShoeManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        DispatchQueue.main.async {
            self.state = central.state
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        DispatchQueue.main.async {
            if let shoeIdentifier = UserDefaults.standard.string(forKey: "shoeIdentifier") {
                if shoeIdentifier == peripheral.identifier.uuidString {
                    self.connect(periphical: peripheral)
                    
                    self.stopScan()
                }
                
                return
            }
            
            if !self.discoveredPeriphicals.contains(peripheral) {
                self.discoveredPeriphicals.append(peripheral)
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        DispatchQueue.main.async {
            self.shoe = nil
        
            self.scanForPeripherals(withServices: nil, options: nil)
        }
    }
}

extension ShoeManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        DispatchQueue.main.async {
            self.fall = true
        }
    }
}
