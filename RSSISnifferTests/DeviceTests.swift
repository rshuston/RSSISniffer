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
    let DeviceInitialTimeStamp: TimeInterval = 3.14
    let DeviceInitialRSSI: Float = -40

    var subject: Device!

    override func setUpWithError() throws {
        subject = Device(name: DeviceName, uuid: DeviceIdentifier, timestamp: DeviceInitialTimeStamp, RSSI: DeviceInitialRSSI)
    }

    override func tearDownWithError() throws {
        subject = nil
    }

    func testTouchMaximizesRefreshCount() throws {
        subject.refreshCount = 0
        subject.touch()
        XCTAssertEqual(subject.refreshCount, Device.MaxCount)
    }

    func testFirstRefreshUpdatesCountAndDeclaresDeviceFresh() {
        XCTAssertEqual(subject.refreshCount, Device.MaxCount)
        let state = subject.refresh()
        XCTAssertEqual(subject.refreshCount, Device.MaxCount - 1)
        XCTAssertEqual(state, Device.State.fresh)
    }

    func testSecondRefreshUpdatesCountAndDeclaresDeviceFresh() {
        XCTAssertEqual(subject.refreshCount, Device.MaxCount)
        _ = subject.refresh()
        let state = subject.refresh()
        XCTAssertEqual(subject.refreshCount, Device.MaxCount - 2)
        XCTAssertEqual(state, Device.State.fresh)
    }

    func testThirdRefreshUpdatesCountAndDeclaresDeviceStale() {
        XCTAssertEqual(subject.refreshCount, Device.MaxCount)
        _ = subject.refresh()
        _ = subject.refresh()
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

    func testCanUpdateRSSI() {
        let newTimeStamp: TimeInterval = 6.0223E-23
        let newRSSI: Float = -42
        subject.update(timestamp: newTimeStamp, RSSI: newRSSI)
        XCTAssertEqual(subject.timestamp, newTimeStamp)
        XCTAssertEqual(subject.RSSI, newRSSI)
    }

}