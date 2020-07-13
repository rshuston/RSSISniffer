//
//  GMKFTests.swift
//  RSSISnifferTests
//
//  Created by Robert Huston on 7/5/20.
//  Copyright © 2020 Pinpoint Dynamics. All rights reserved.
//

import XCTest

@testable import RSSISniffer

class GMKFTests: XCTestCase {

    func testUpdateStartsNewFilter() throws {
        let subject = GMKF(P0: 1, sigma: 1, beta: 1, R: 1)

        XCTAssert(!subject.running)

        subject.update(t: 1, z: 1)

        XCTAssert(subject.running)
        XCTAssertEqual(subject.t, 1)
        XCTAssertEqual(subject.x, 1)
    }

    func testUpdateHandlesSecondUpdate() throws {
        let subject = GMKF(P0: 1, sigma: 1, beta: 1, R: 1)

        subject.update(t: 1, z: 1)

        /*
         update(t: 2, z: 1)
           tau = 1
           phi = exp(-1) = 0.367879
           Q = (1 - exp(-2)) = 0.864665
           x_m = phi * x = 0.367879
           P_m = phi * phi * P + Q = 1
           K = 0.5
           x_p = 0.367879 + 0.5 (1 - 0.367879) = 0.683940
           P_p = 0.5
         */

        subject.update(t: 2, z: 1)

        XCTAssertEqual(subject.t, 2)
        XCTAssertEqual(subject.x, 0.683940, accuracy: 0.000001)
        XCTAssertEqual(subject.P, 0.5, accuracy: 0.000001)
    }

    func testUpdateHandlesArbitraryData() throws {
        let subject = GMKF(P0: 0.5, sigma: 0.5, beta: 0.1, R: 2)

        subject.update(t: 1, z: 0.2)

        /*
         update(t: 1.1, z: 1)
           tau = 1.1 - 1 = 0.1
           phi = exp(-0.01) = 0.990050
           Q = 0.25 * (1 - exp(-0.02)) = 0.004950
           x_m = 0.990050 * 0.2 = 0.198010
           P_m = 0.990050 * 0.990050 * 0.5 + 0.004950 = 0.495050
           K = 0.495050 / (0.495050 + 2) = 0.198413
           x_p = 0.198010 + 0.198413 (1 - 0.198010) = 0.357135
           P_p = (1 - 0.198413) * 0.396826
         */

        subject.update(t: 1.1, z: 1)

        XCTAssertEqual(subject.t, 1.1)
        XCTAssertEqual(subject.x, 0.357135, accuracy: 0.000001)
        XCTAssertEqual(subject.P, 0.396826, accuracy: 0.000001)
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
