//
//  GMKF.swift
//  RSSISniffer
//
//  Created by Robert Huston on 7/5/20.
//  Copyright © 2020 Pinpoint Dynamics. All rights reserved.
//

import Foundation

class GMKF {

    var running: Bool

    var t: TimeInterval
    var x: Double
    var P: Double

    var sigma_sq: Double
    var beta: Double
    var R: Double

    init(P0: Double = 1, sigma: Double = 1, beta: Double = 1, R: Double = 1) {
        self.running = false

        self.t = 0
        self.x = 0
        self.P = P0

        self.sigma_sq = sigma * sigma
        self.beta = beta
        self.R = R
    }

    func update(t: TimeInterval, z: Double) {
        if !running {
            self.t = t
            x = z
            running = true
        } else {
            let tau = t - self.t
            self.t = t
            let exp_mBt = exp(-beta * tau)
            let exp_m2Bt = exp_mBt * exp_mBt
            let phi = exp_mBt
            let Q = sigma_sq * (1 - exp_m2Bt)
            let x_m = phi * x
            let P_m = P * exp_m2Bt + Q
            let K = P_m / (P_m + R)
            x = x_m + K * (z - x_m)
            P = (1 - K) * P_m
        }
    }

}
