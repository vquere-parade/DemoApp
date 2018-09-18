//
//  BluetoothManager.swift
//  Parade
//
//  Created by Simon Le Bras on 14/09/2018.
//  Copyright © 2018 Parade Protection. All rights reserved.
//

import CoreBluetooth

@objc class ShoeManager: NSObject {
    private let fallServiceUUID = CBUUID(string: "0xFFE0")
    private let fallCharacteristicUUID = CBUUID(string: "0xFFE5")
    
    private var centralManager: CBCentralManager!
    
    @objc dynamic var shoe: CBPeripheral?
    
    @objc dynamic var state: CBManagerState = .unknown
    
    @objc dynamic var discoveredPeripherals = [CBPeripheral]()
    
    @objc dynamic var fall = false
    
    override init() {
        super.init()
        
        let centralQueue: DispatchQueue = DispatchQueue(label: "Central Queue", attributes: .concurrent)
        
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    }
    
    func scanForPeripherals() {
        discoveredPeripherals.removeAll()
        
        centralManager.scanForPeripherals(withServices: nil)
    }
    
    func stopScan() {
        centralManager.stopScan()
    }
    
    func connect(peripheral: CBPeripheral) {
        UserDefaults.standard.set(peripheral.identifier.uuidString, forKey: "shoeIdentifier")
        
        shoe = peripheral
        shoe!.delegate = self
        
        centralManager.connect(peripheral)
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
                    self.connect(peripheral: peripheral)
                    
                    self.stopScan()
                }
                
                return
            }
            
            if !self.discoveredPeripherals.contains(peripheral) {
                self.discoveredPeripherals.append(peripheral)
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([fallServiceUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        DispatchQueue.main.async {
            self.shoe = nil
        
            self.scanForPeripherals()
        }
    }
}

extension ShoeManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            if service.uuid == fallServiceUUID {
                peripheral.discoverCharacteristics([fallCharacteristicUUID], for: service)
                
                break
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            if characteristic.uuid == fallCharacteristicUUID {
                peripheral.readValue(for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        DispatchQueue.main.async {
            if let value = characteristic.value, UInt8(value[2]) > 0  {
                self.fall = true
            }

            peripheral.readValue(for: characteristic)
        }
    }
}
