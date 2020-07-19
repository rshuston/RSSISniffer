#!/usr/bin/env python3

import math
import numpy as np

# 6 fractional digits, suppress automatic scientific notation
np.set_printoptions(precision=6, suppress=True)

Eye = np.identity(2)

class IGM_KF:
    def __init__(self, P0=Eye, sigma=1, beta=1, R=1):
        self.state = 0
        self.t = 0
        self.P = P0
        self.sigma_sq = sigma * sigma
        self.beta = beta
        self.R = np.array([ [R] ])
        
    def update(self, t, z, trace=False):
        if self.state == 0:
            self.t = t
            self.x = np.array([ [z],
                                [0] ])
            self.state = 1
        else:
            tau = t - self.t
            self.t = t
            
            gm_phi = math.exp(- self.beta * tau)
            if trace:
                print(f'gm_phi={gm_phi:.6f}')
            exp_term_1 = (1 - gm_phi) / self.beta
            if trace:
                print(f'exp_term_1={exp_term_1:.6f}')
            exp_term_2 = (1 - gm_phi * gm_phi) / (2 * self.beta)
            if trace:
                print(f'exp_term_2={exp_term_2:.6f}')
            exp_term_3 = 1 - gm_phi * gm_phi
            if trace:
                print(f'exp_term_3={exp_term_3:.6f}')
            
            Phi = np.array([ [1, exp_term_1],
                             [0, gm_phi    ] ])
            if trace:
                print(f'Phi=\n{Phi}')
            Ex1x1 = 2 * self.sigma_sq * (tau - 2 * exp_term_1 + exp_term_2) / self.beta
            Ex1x2 = 2 * self.sigma_sq * (exp_term_1 - exp_term_2)
            Ex2x2 = self.sigma_sq * exp_term_3
            Q = np.array([ [Ex1x1, Ex1x2],
                           [Ex1x2, Ex2x2] ])
            if trace:
                print(f'Q=\n{Q}')
            H = np.array([ [1, 0] ])
            
            Phi_T = np.transpose(Phi)
            H_T = np.transpose(H)
            
            x_m = Phi @ self.x
            if trace:
                print(f'x_m=\n{x_m}')
            P_m = Phi @ self.P @ Phi_T + Q
            if trace:
                print(f'P_m=\n{P_m}')
            
            S = H @ P_m @ H_T + self.R
            if trace:
                print(f'S=\n{S}')
            S_inv = np.linalg.inv(S)
            if trace:
                print(f'S_inv=\n{S_inv}')
            K = P_m @ H_T @ S_inv
            if trace:
                print(f'K=\n{K}')
                        
            self.x = x_m + K @ (np.array([[z]]) - H @ x_m)
            if trace:
                print(f'x=\n{self.x}')
            self.P = (Eye - K @ H) @ P_m
            if trace:
                print(f'P=\n{self.P}')
    
    def x0(self):
        return self.x[0][0]
    
    def x1(self):
        return self.x[1][0]
    
    def P00(self):
        return self.P[0][0]
    
    def P01(self):
        return self.P[0][1]
    
    def P10(self):
        return self.P[1][0]
    
    def P11(self):
        return self.P[1][1]

def InitialUpdate():
    print('SimpleOneStepUpdate:')
    filter = IGM_KF(P0=2 * Eye, sigma=0.5, beta=0.1, R=2)
    t = 1
    z = 1
    filter.update(t, z)
    x0 = filter.x0()
    x1 = filter.x1()
    P00 = filter.P00()
    P01 = filter.P01()
    P10 = filter.P10()
    P11 = filter.P11()
    print(f't={t:.6f}, z={z:.6f}, x0={x0:.6f}, x1={x1:.6f}, P00={P00:.6f}, P01={P01:.6f}, P10={P10:.6f}, P11={P11:.6f}')
    print()

def SimpleTwoStepUpdate():
    print('SimpleTwoStepUpdate:')
    filter = IGM_KF(P0=2 * Eye, sigma=0.5, beta=0.1, R=2)
    t = 1
    z = 1
    filter.update(t, z)
    t = 1.1
    z = 1.5
    filter.update(t, z, trace=True)
    x0 = filter.x0()
    x1 = filter.x1()
    P00 = filter.P00()
    P01 = filter.P01()
    P10 = filter.P10()
    P11 = filter.P11()
    print(f't={t:.6f}, z={z:.6f}, x0={x0:.6f}, x1={x1:.6f}, P00={P00:.6f}, P01={P01:.6f}, P10={P10:.6f}, P11={P11:.6f}')
    print()

def SimpleThreeStepUpdate():
    print('SimpleThreeStepUpdate:')
    filter = IGM_KF(P0=2 * Eye, sigma=0.5, beta=0.1, R=2)
    t = 1
    z = 1
    filter.update(t, z)
    t = 1.1
    z = 1.5
    filter.update(t, z)
    t = 1.9
    z = 0.6
    filter.update(t, z)
    x0 = filter.x0()
    x1 = filter.x1()
    P00 = filter.P00()
    P01 = filter.P01()
    P10 = filter.P10()
    P11 = filter.P11()
    print(f't={t:.6f}, z={z:.6f}, x0={x0:.6f}, x1={x1:.6f}, P00={P00:.6f}, P01={P01:.6f}, P10={P10:.6f}, P11={P11:.6f}')
    print()

def FiveStepArbitraryUpdate():
    print('FiveStepArbitraryUpdate:')
    filter = IGM_KF(P0=5 * Eye, sigma=0.2, beta=0.1, R=25)
    t = 1
    z = -31
    filter.update(t, z)
    t = 1.1
    z = -35.5
    filter.update(t, z)
    t = 1.7
    z = -28.6
    filter.update(t, z)
    t = 2.9
    z = -41.2
    filter.update(t, z)
    t = 3.8
    z = -25.1
    filter.update(t, z)
    x0 = filter.x0()
    x1 = filter.x1()
    P00 = filter.P00()
    P01 = filter.P01()
    P10 = filter.P10()
    P11 = filter.P11()
    print(f't={t:.6f}, z={z:.6f}, x0={x0:.6f}, x1={x1:.6f}, P00={P00:.6f}, P01={P01:.6f}, P10={P10:.6f}, P11={P11:.6f}')
    print()

def ImplementedTwoStepUpdate():
    print('ImplementedTwoStepUpdate:')
    filter = IGM_KF(P0=Eye, sigma=0.2, beta=0.1, R=5)
    t = 1
    z = -40
    filter.update(t, z)
    t = 2
    z = -41
    filter.update(t, z)
    x0 = filter.x0()
    x1 = filter.x1()
    P00 = filter.P00()
    P01 = filter.P01()
    P10 = filter.P10()
    P11 = filter.P11()
    print(f't={t:.6f}, z={z:.6f}, x0={x0:.6f}, x1={x1:.6f}, P00={P00:.6f}, P01={P01:.6f}, P10={P10:.6f}, P11={P11:.6f}')
    print()

InitialUpdate()
SimpleTwoStepUpdate()
SimpleThreeStepUpdate()
FiveStepArbitraryUpdate()
ImplementedTwoStepUpdate()
