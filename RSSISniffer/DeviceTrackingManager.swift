//
//  DeviceTrackingManager.swift
//  RSSISniffer
//
//  Created by Robert Huston on 7/3/20.
//  Copyright © 2020 Pinpoint Dynamics. All rights reserved.
//

import Foundation

class DeviceTrackingManager {

    var devices: [Device] = []

    func track(uuid: String, name: String, timestamp: TimeInterval, RSSI: Double) {
        if let device = devices.first(where: { $0.uuid == uuid }) {
            device.update(timestamp: timestamp, RSSI: RSSI)
        } else {
            devices.append(Device(uuid: uuid, name: name, timestamp: timestamp, RSSI: RSSI))
        }
    }

    func removeStaleDevices() {
        for device in devices {
            if device.refresh() == .stale {
                devices.removeAll(where: {$0 === device})
            }
        }
    }

    func clearDevices() {
        devices.removeAll()
    }

    func getNumberOfDevices() -> Int {
        return devices.count
    }

    func getDevice(atIndex: Int) -> Device? {
        guard atIndex < devices.count else { return nil }
        return devices[atIndex]
    }

}
