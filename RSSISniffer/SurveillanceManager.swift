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

    var centralManager: CBCentralManager!
    var deviceTrackingManager: DeviceTrackingManager!

    // Slow check for stale devices
    var surveillanceStaleCheckTimer: Timer!

    // Callback notification handler for when data has changed
    var dataChangeNotificationHandler: (() -> Void)?

    // MARK: - Initializers

    override init() {
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        deviceTrackingManager = DeviceTrackingManager()

        surveillanceStaleCheckTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: surveillanceTask)
    }

    convenience init(dataChangeNotificationHandler: (() -> Void)?) {
        self.init()
        self.dataChangeNotificationHandler = dataChangeNotificationHandler
    }

    // MARK: - Operation and data query

    func surveillanceTask(timer: Timer) {
        // Run device tracking operations on main thread to avoid multi-thread data operations
        DispatchQueue.main.async {
            self.deviceTrackingManager.removeStaleDevices()
            self.dataChangeNotificationHandler?()
        }
    }

    func startScanningForPeripherals() {
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }

    func stopScanningForPeripherals() {
        centralManager.stopScan()

        // Run device tracking operations on main thread to avoid multi-thread data operations
        DispatchQueue.main.async {
            self.deviceTrackingManager.clearDevices()
            self.dataChangeNotificationHandler?()
        }
    }

    func getNumberOfDevices() -> Int {  // Pass-through to deviceTrackingManager function
        return deviceTrackingManager.getNumberOfDevices()
    }

    func getDevice(atIndex: Int) -> Device? {  // Pass-through to deviceTrackingManager function
        return deviceTrackingManager.getDevice(atIndex: atIndex)
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

        let timestamp = Date().timeIntervalSince1970
        let uuid = peripheral.identifier.uuidString
        let name = peripheral.name ?? "?"

        // Run device tracking operations on main thread to avoid multi-thread data operations
        DispatchQueue.main.async {
            self.deviceTrackingManager.track(uuid: uuid, name: name, timestamp: timestamp, RSSI: RSSI.doubleValue)
        }

        let csvString = "\(uuid),\(RSSI.stringValue),\(name)"
        LogFileManager.writeLn(fileName: Constants.Files.DeviceSurveillance, text: csvString)
    }

}
