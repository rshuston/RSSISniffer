//
//  DeviceTrackingManagerTests.swift
//  RSSISnifferTests
//
//  Created by Robert Huston on 7/5/20.
//  Copyright © 2020 Pinpoint Dynamics. All rights reserved.
//

import XCTest

@testable import RSSISniffer

class DeviceTrackingManagerTests: XCTestCase {

    var subject: DeviceTrackingManager!

    override func setUpWithError() throws {
        subject = DeviceTrackingManager()
    }

    override func tearDownWithError() throws {
        subject = nil
    }

    func testTrackAddsNewDeviceToEmptyList() throws {
        XCTAssertEqual(subject.devices.count, 0)

        let uuid = "Gandalf"
        let name = "Bilbo"
        let timestamp = 3.141593
        let RSSI = -32.0

        subject.track(uuid: uuid, name: name, timestamp: timestamp, RSSI: RSSI)

        XCTAssertEqual(subject.devices.count, 1)
        XCTAssertEqual(subject.devices[0].timestamp, timestamp)
    }

    func testTrackUpdatesExistingDevice() throws {
        let uuid = "Gandalf"
        let name = "Bilbo"
        var timestamp = 3.141593
        var RSSI = -32.0

        subject.devices.append(Device(uuid: uuid, name: name, timestamp: timestamp, RSSI: RSSI))

        timestamp += 1.0
        RSSI -= 1.0

        subject.track(uuid: uuid, name: name, timestamp: timestamp, RSSI: RSSI)

        XCTAssertEqual(subject.devices.count, 1)
        XCTAssertEqual(subject.devices[0].timestamp, timestamp)
    }

    func testTrackAddsNewDeviceToNonEmptyList() throws {
        let uuid_1 = "Gandalf"
        let name_1 = "Bilbo"
        let timestamp_1 = 2.718282
        let RSSI_1 = -32.0

        subject.devices.append(Device(uuid: uuid_1, name: name_1, timestamp: timestamp_1, RSSI: RSSI_1))

        let uuid_2 = "Dumbledore"
        let name_2 = "Harry"
        let timestamp_2 = 3.141593
        let RSSI_2 = -24.0

        subject.track(uuid: uuid_2, name: name_2, timestamp: timestamp_2, RSSI: RSSI_2)

        XCTAssertEqual(subject.devices.count, 2)
        XCTAssertEqual(subject.devices[0].uuid, uuid_1)
        XCTAssertEqual(subject.devices[1].uuid, uuid_2)
    }

    func testRemoveStaleDevicesDoesNotRemoveFreshDevices() throws {
        subject.devices.append(Device(uuid: "Curly", name: "Howard", timestamp: 1.0, RSSI: 1.0))
        subject.devices.append(Device(uuid: "Larry", name: "Fine",   timestamp: 1.0, RSSI: 1.0))
        subject.devices.append(Device(uuid: "Moe",   name: "Howard", timestamp: 1.0, RSSI: 1.0))
        XCTAssertEqual(subject.devices.count, 3)

        subject.removeStaleDevices()

        XCTAssertEqual(subject.devices.count, 3)
    }

    func testRemoveStaleDevicesRemoveStaleDevice() throws {
        subject.devices.append(Device(uuid: "Curly", name: "Howard", timestamp: 1.0, RSSI: 1.0))
        subject.devices.append(Device(uuid: "Larry", name: "Fine",   timestamp: 1.0, RSSI: 1.0))
        subject.devices.append(Device(uuid: "Moe",   name: "Howard", timestamp: 1.0, RSSI: 1.0))

        subject.devices[0].refreshCount = 0

        subject.removeStaleDevices()

        XCTAssertEqual(subject.devices.count, 2)
        XCTAssertEqual(subject.devices[0].uuid, "Larry")
        XCTAssertEqual(subject.devices[1].uuid, "Moe")
    }

    func testClearDevicesRemovesAllDevices() {
        subject.devices.append(Device(uuid: "Curly", name: "Howard", timestamp: 1.0, RSSI: 1.0))
        subject.devices.append(Device(uuid: "Larry", name: "Fine",   timestamp: 1.0, RSSI: 1.0))
        subject.devices.append(Device(uuid: "Moe",   name: "Howard", timestamp: 1.0, RSSI: 1.0))

        subject.clearDevices()

        XCTAssertEqual(subject.devices.count, 0)
    }

    func testGetNumberOfDevicesReturnsNoneForEmptyList() {
        XCTAssertEqual(subject.getNumberOfDevices(), 0)
    }

    func testGetNumberOfDevicesReturnsNoneForNonEmptyList() {
        subject.devices.append(Device(uuid: "Curly", name: "Howard", timestamp: 1.0, RSSI: 1.0))
        subject.devices.append(Device(uuid: "Larry", name: "Fine",   timestamp: 1.0, RSSI: 1.0))
        subject.devices.append(Device(uuid: "Moe",   name: "Howard", timestamp: 1.0, RSSI: 1.0))

        XCTAssertEqual(subject.getNumberOfDevices(), 3)
    }

    func testGetDeviceReturnsDevice() throws {
        subject.devices.append(Device(uuid: "Curly", name: "Howard", timestamp: 1.0, RSSI: 1.0))
        subject.devices.append(Device(uuid: "Larry", name: "Fine",   timestamp: 1.0, RSSI: 1.0))
        subject.devices.append(Device(uuid: "Moe",   name: "Howard", timestamp: 1.0, RSSI: 1.0))

        let device = subject.getDevice(atIndex: 1)

        XCTAssertEqual(device?.uuid, "Larry")
    }

    func testGetDeviceReturnsNilForOutOfBoundsIndex() throws {
        subject.devices.append(Device(uuid: "Curly", name: "Howard", timestamp: 1.0, RSSI: 1.0))
        subject.devices.append(Device(uuid: "Larry", name: "Fine",   timestamp: 1.0, RSSI: 1.0))
        subject.devices.append(Device(uuid: "Moe",   name: "Howard", timestamp: 1.0, RSSI: 1.0))

        let device = subject.getDevice(atIndex: 5)

        XCTAssertNil(device)
    }

}
