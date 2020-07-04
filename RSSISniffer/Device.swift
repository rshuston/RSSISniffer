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

    let name: String
    let uuid: String

    var timestamp: TimeInterval
    var RSSI: Float

    var refreshCount: UInt16

    init(name: String, uuid: String, timestamp: TimeInterval, RSSI: Float) {
        self.name = name
        self.uuid = uuid

        self.timestamp = timestamp
        self.RSSI = RSSI

        refreshCount = Device.MaxCount
    }

    public func touch() {
        refreshCount = Device.MaxCount
    }

    public func refresh() -> State {
        if refreshCount > 0 {
            refreshCount = refreshCount - 1
        }
        return (refreshCount <= 0) ? .stale : .fresh
    }

    public func update(timestamp: TimeInterval, RSSI: Float) {
        self.timestamp = timestamp
        self.RSSI = RSSI
    }

}
