//
//  IGMKFTests.swift
//  RSSISnifferTests
//
//  Created by Robert Huston on 7/13/20.
//  Copyright © 2020 Pinpoint Dynamics. All rights reserved.
//

import XCTest

@testable import RSSISniffer

class IGMKFTests: XCTestCase {

    func testUpdateStartsNewFilter() throws {
        let subject = IGMKF(P0_00: 2, P0_01: 0, P0_11: 2, sigma: 0.5, beta: 0.1, R: 2)

        XCTAssert(!subject.running)

        subject.update(t: 1, z: 1)

        XCTAssert(subject.running)
        XCTAssertEqual(subject.t, 1)
        XCTAssertEqual(subject.x0, 1)
        XCTAssertEqual(subject.x1, 0)
    }

    func testUpdateHandlesSecondUpdate() throws {
        let subject = IGMKF(P0_00: 2, P0_01: 0, P0_11: 2, sigma: 0.5, beta: 0.1, R: 2)

        subject.update(t: 1, z: 1)

        /*
         update(t: 1.1, z: 1.5)
           tau = 0.1
           Phi=
             [[1.       0.099502]
              [0.       0.99005 ]]
           Q=
             [[0.000017 0.000248]
              [0.000248 0.00495 ]]
           x_m=
             [[1.]
              [0.]]
           P_m=
             [[2.019818 0.197271]
              [0.197271 1.965348]]
           S=
             [[4.019818]]
             S_inv=
             [[0.248767]]
           K=
             [[0.502465]
              [0.049075]]
           x=
             [[1.251233]
              [0.024537]]
           P=
             [[1.00493  0.098149]
              [0.098149 1.955667]]
         */

        subject.update(t: 1.1, z: 1.5)

        XCTAssertEqual(subject.t, 1.1)
        XCTAssertEqual(subject.x0,  1.251233, accuracy: 0.000001)
        XCTAssertEqual(subject.x1,  0.024537, accuracy: 0.000001)
        XCTAssertEqual(subject.P00, 1.004930, accuracy: 0.000001)
        XCTAssertEqual(subject.P01, 0.098149, accuracy: 0.000001)
        XCTAssertEqual(subject.P11, 1.955667, accuracy: 0.000001)
    }

    func testUpdateHandlesThreeUpdates() throws {
        let subject = IGMKF(P0_00: 2, P0_01: 0, P0_11: 2, sigma: 0.5, beta: 0.1, R: 2)

        subject.update(t: 1,   z: 1)
        subject.update(t: 1.1, z: 1.5)
        subject.update(t: 1.9, z: 0.6)

        XCTAssertEqual(subject.t, 1.9)
        XCTAssertEqual(subject.x0,  0.910237, accuracy: 0.000001)
        XCTAssertEqual(subject.x1, -0.208998, accuracy: 0.000001)
        XCTAssertEqual(subject.P00, 1.074054, accuracy: 0.000001)
        XCTAssertEqual(subject.P01, 0.691389, accuracy: 0.000001)
        XCTAssertEqual(subject.P11, 1.187224, accuracy: 0.000001)
    }

    func testUpdateHandlesFiveArbitraryUpdates() throws {
        let subject = IGMKF(P0_00: 5, P0_01: 0, P0_11: 5, sigma: 0.2, beta: 0.1, R: 25)

        subject.update(t: 1,   z: -31)
        subject.update(t: 1.1, z: -35.5)
        subject.update(t: 1.7, z: -28.6)
        subject.update(t: 2.9, z: -41.2)
        subject.update(t: 3.8, z: -25.1)

        XCTAssertEqual(subject.t, 3.8)
        XCTAssertEqual(subject.x0, -31.475132, accuracy: 0.000001)
        XCTAssertEqual(subject.x1,   0.095416, accuracy: 0.000001)
        XCTAssertEqual(subject.P00, 10.434373, accuracy: 0.000001)
        XCTAssertEqual(subject.P01,  3.061988, accuracy: 0.000001)
        XCTAssertEqual(subject.P11,  1.230942, accuracy: 0.000001)
    }

}
