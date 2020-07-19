//
//  Device.swift
//  RSSISniffer
//
//  Created by Robert Huston on 7/3/20.
//  Copyright © 2020 Pinpoint Dynamics. All rights reserved.
//

import Foundation

class Device {

    public enum State {
        case stale
        case fresh
    }

    static let MaxCount: UInt16 = 3  // Number of successive refreshes to turn stale

    let uuid: String
    let name: String

    var kf: IGMKF
    var timestamp: TimeInterval {
        get {
            return kf.t
        }
    }
    var RSSI: Double {
        get {
            return kf.x0
        }
    }

    var refreshCount: UInt16

    init(uuid: String, name: String, timestamp: TimeInterval, RSSI: Double) {
        self.uuid = uuid
        self.name = name

        kf = IGMKF(P0_00: 1, P0_01: 0, P0_11: 1, sigma: 0.2, beta: 0.1, R: 5)
        kf.update(t: timestamp, z: RSSI)

        refreshCount = Device.MaxCount
    }

    func touch() {
        refreshCount = Device.MaxCount
    }

    func refresh() -> State {
        if refreshCount > 0 {
            refreshCount = refreshCount - 1
        }
        return (refreshCount <= 0) ? .stale : .fresh
    }

    func update(timestamp: TimeInterval, RSSI: Double) {
        kf.update(t: timestamp, z: RSSI)
    }

}
