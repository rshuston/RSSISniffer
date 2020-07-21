//
//  RSSISnifferTests.swift
//  RSSISnifferTests
//
//  Created by Robert Huston on 7/3/20.
//  Copyright © 2020 Pinpoint Dynamics. All rights reserved.
//

import XCTest

@testable import RSSISniffer

class DeviceTests: XCTestCase {

    let DeviceName: String = "Tri-Corder"
    let DeviceIdentifier: String = "This is me!"
    let DeviceInitialTimeStamp: TimeInterval = 1.0
    let DeviceInitialRSSI: Double = -40

    var subject: Device!

    override func setUpWithError() throws {
        subject = Device(uuid: DeviceIdentifier, name: DeviceName, timestamp: DeviceInitialTimeStamp, RSSI: DeviceInitialRSSI)
    }

    override func tearDownWithError() throws {
        subject = nil
    }

    func testTouchMaximizesRefreshCount() throws {
        subject.refreshCount = 0
        subject.touch()
        XCTAssertEqual(subject.refreshCount, Device.MaxRefreshCount)
    }

    func testFirstRefreshUpdatesCountAndDeclaresDeviceFresh() {
        XCTAssertEqual(subject.refreshCount, Device.MaxRefreshCount)
        let state = subject.refresh()
        XCTAssertEqual(subject.refreshCount, Device.MaxRefreshCount - 1)
        XCTAssertEqual(state, Device.State.fresh)
    }

    func testSecondRefreshUpdatesCountAndDeclaresDeviceFresh() {
        subject.refreshCount = Device.MaxRefreshCount - 1
        let state = subject.refresh()
        XCTAssertEqual(subject.refreshCount, Device.MaxRefreshCount - 2)
        XCTAssertEqual(state, Device.State.fresh)
    }

    func testLastRefreshUpdatesCountAndDeclaresDeviceStale() {
        subject.refreshCount = 1
        let state = subject.refresh()
        XCTAssertEqual(subject.refreshCount, 0)
        XCTAssertEqual(state, Device.State.stale)
    }

    func testRefreshWhenStaleStillDeclaresDeviceStale() {
        subject.refreshCount = 0
        let state = subject.refresh()
        XCTAssertEqual(subject.refreshCount, 0)
        XCTAssertEqual(state, Device.State.stale)
    }

    func testUpdateTouchesRefreshAndDoesRSSIUpdate() {
        XCTAssertEqual(subject.rawRSSI, DeviceInitialRSSI)

        subject.refreshCount = 1

        let newTimeStamp: TimeInterval = DeviceInitialTimeStamp + 1
        let newRSSI: Double = DeviceInitialRSSI - 1
        let expectedFilteredRSSI: Double = -40.276209

        subject.update(timestamp: newTimeStamp, RSSI: newRSSI)

        XCTAssertEqual(subject.refreshCount, Device.MaxRefreshCount)

        XCTAssertEqual(subject.rawRSSI, newRSSI)
        XCTAssertEqual(subject.timestamp, newTimeStamp)
        XCTAssertEqual(subject.RSSI, expectedFilteredRSSI, accuracy: 0.000001)
    }

}
