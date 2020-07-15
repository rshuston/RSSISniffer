//
//  KalmanFilterPerformanceTests.swift
//  RSSISnifferTests
//
//  Created by Robert Huston on 7/15/20.
//  Copyright © 2020 Pinpoint Dynamics. All rights reserved.
//

import XCTest

@testable import RSSISniffer

class KalmanFilterPerformanceTests: XCTestCase {

    let SampleDataSize = 100000

    func testGMKFPerformance() throws {
        let filter = GMKF(P0: 1, sigma: 1, beta: 1, R: 1)

        self.measure {
            for i in 0..<SampleDataSize {
                let t = TimeInterval(i)
                let z = 1.0 + Double(i) * 0.01
                filter.update(t: t, z: z)
            }
        }
    }

    func testIGMKFPerformance() throws {
        let filter = IGMKF(P0_00: 1, P0_01: 0, P0_11: 1, sigma: 1, beta: 1, R: 1)

        self.measure {
            for i in 0..<SampleDataSize {
                let t = TimeInterval(i)
                let z = 1.0 + Double(i) * 0.01
                filter.update(t: t, z: z)
            }
        }
    }

}
