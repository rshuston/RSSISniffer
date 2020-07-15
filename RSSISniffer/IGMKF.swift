//
//  IGMKF.swift
//  RSSISniffer
//
//  Created by Robert Huston on 7/13/20.
//  Copyright © 2020 Pinpoint Dynamics. All rights reserved.
//

import Foundation

class IGMKF {

    var running: Bool

    var t: TimeInterval
    var x0: Double
    var x1: Double
    var P00: Double
    var P01: Double
    var P11: Double

    var sigma_sq: Double
    var beta: Double
    var R: Double

    init(P0_00: Double = 1, P0_01: Double = 1, P0_11: Double = 1, sigma: Double = 1, beta: Double = 1, R: Double = 1) {
        self.running = false

        self.t = 0
        self.x0 = 0
        self.x1 = 0
        self.P00 = P0_00
        self.P01 = P0_01
        self.P11 = P0_11

        self.sigma_sq = sigma * sigma
        self.beta = beta
        self.R = R
    }

    func update(t: TimeInterval, z: Double) {
        if !running {
            self.t = t
            x0 = z
            x1 = 0
            running = true
        } else {
            let tau = t - self.t
            self.t = t

            let exp_mBt = exp(-beta * tau)
            let exp_m2Bt = exp_mBt * exp_mBt

            let one_m_exp_mBt_d_B = (1.0 - exp_mBt) / beta
            let one_m_exp_m2Bt = 1.0 - exp_m2Bt
            let one_m_exp_m2Bt_d_2B = one_m_exp_m2Bt / (2.0 * beta)

            let Phi00 = 1.0
            let Phi01 = (1.0 - exp_mBt) / beta
            let Phi11 = exp_mBt

            let Q00 = 2.0 * sigma_sq * (tau - 2 * one_m_exp_mBt_d_B + one_m_exp_m2Bt_d_2B) / beta
            let Q01 = 2.0 * sigma_sq * (one_m_exp_mBt_d_B - one_m_exp_m2Bt_d_2B)
            let Q11 = sigma_sq * one_m_exp_m2Bt

            let xm0 = Phi00 * x0 + Phi01 * x1
            let xm1 = Phi11 * x1

            let Pm00 = (Phi00 * P00 + Phi01 * P01) * Phi00 + (Phi00 * P01 + Phi01 * P11) * Phi01 + Q00
            let Pm01 = Phi00 * P01 * Phi11 + Phi01 * P11 * Phi11 + Q01
            let Pm11 = Phi11 * Phi11 * P11 + Q11

            let K0 = Pm00 / (Pm00 + R)
            let K1 = Pm01 / (Pm00 + R)

            let dz = z - xm0

            x0 = xm0 + K0 * dz
            x1 = xm1 + K1 * dz

            let temp = (1.0 - K0)
            P00 = temp * Pm00
            P01 = temp * Pm01
            P11 = -K1 * Pm01 + Pm11
        }
    }

}
