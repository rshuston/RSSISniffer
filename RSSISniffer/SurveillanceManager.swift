//
//  SurveillanceManager.swift
//  RSSISniffer
//
//  Created by Robert Huston on 7/3/20.
//  Copyright © 2020 Pinpoint Dynamics. All rights reserved.
//

import Foundation
import CoreBluetooth

class SurveillanceManager: NSObject {

    var centralManager: CBCentralManager?

    override init() {
        super.init()

        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func startScanningForPeripherals() {
        centralManager?.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }

    func stopScanningForPeripherals() {
        centralManager?.stopScan()
    }

}

// MARK: - CBCentralManagerDelegate methods

extension SurveillanceManager: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let stateMsg: String
        switch central.state {
        case .unknown:
            stateMsg = "central.state is .unknown"
        case .resetting:
            stateMsg = "central.state is .resetting"
        case .unsupported:
            stateMsg = "central.state is .unsupported"
        case .unauthorized:
            stateMsg = "central.state is .unauthorized"
        case .poweredOff:
            stateMsg = "central.state is .poweredOff"
            stopScanningForPeripherals()
        case .poweredOn:
            stateMsg = "central.state is .poweredOn"
        @unknown default:
            stateMsg = "central.state default is \(central.state)"
        }
        print(stateMsg)
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        let uuid = peripheral.identifier.uuidString
        let name = peripheral.name ?? "?"

        print("peripheral: uuid = \(uuid), RSSI = \(RSSI.stringValue), name = \(name)")

        let csvString = "\(uuid),\(RSSI.stringValue),\(name)"
        LogFileManager.writeLn(fileName: Constants.Files.DeviceSurveillance, text: csvString)
    }

}
