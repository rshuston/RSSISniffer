#!/usr/bin/env python3

import sys
import csv
import math
import numpy as np
import matplotlib.pyplot as plt

Eye = np.identity(2)

class DeviceIdentity:
    def __init__(self, name):
        self.name = name

class DeviceReading:
    def __init__(self, uuid, rssi, name):
        self.uuid = uuid
        self.rssi = rssi
        self.name = name

class GMRB_FilteredRSSI:
    def __init__(self, P0=Eye, sigma_b=1, sigma_g=1, beta_g=1, R=1):
        self.state = 0
        self.t = 0
        self.P = P0
        self.sigma_b_sq = sigma_b * sigma_b
        self.sigma_g_sq = sigma_g * sigma_g
        self.beta_g = beta_g
        self.R = np.array([ [R] ])
        
    def update(self, t, z):
        if self.state == 0:
            self.t = t
            self.x = np.array([ [z],
                                [0] ])
            self.state = 1
        else:
            tau = t - self.t
            self.t = t
            
            Phi = np.array([ [1, 0],
                             [0, math.exp(- self.beta_g * tau)] ])
            Q = np.array([ [self.sigma_b_sq, 0],
                           [0, self.sigma_g_sq * (1 - math.exp(-2 * self.beta_g * tau))] ])
            H = np.array([ [1, 1] ])
            
            Phi_T = np.transpose(Phi)
            H_T = np.transpose(H)
            
            x_m = Phi @ self.x
            P_m = Phi @ self.P @ Phi_T + Q
            
            S = H @ P_m @ H_T + self.R
            S_inv = np.linalg.inv(S)
            K = P_m @ H_T @ S_inv
                        
            self.x = x_m + K @ (np.array([[z]]) - H @ x_m)
            self.P = (Eye - K) @ P_m
    
    def x1(self):
        return self.x[0][0]

csv_file_name = ""
device_uuid = ""

if len(sys.argv) == 2:
    csv_file_name = sys.argv[1]
elif len(sys.argv) == 3:
    csv_file_name = sys.argv[1]
    device_uuid = sys.argv[2]
else:
    print(f"usage: {sys.argv[0]} CSV-file [UUID]")
    exit(0)

DeviceIdentityDict = {}
DeviceReadingDict = {}

# Use encoding='utf-8-sig' to ignore Byte Order Mark at beginning of lines
with open(csv_file_name, mode='r', encoding='utf-8-sig') as csv_file:
    reader = csv.DictReader(csv_file)    
    for row in reader:
        time_str = row['Time']
        uuid_str = row['UUID']
        rssi_str = row['RSSI']
        name_str = row['Name']
        time = float(time_str)
        rssi = float(rssi_str)
        DeviceIdentityDict[uuid_str] = DeviceIdentity(name_str)
        DeviceReadingDict[time] = DeviceReading(uuid_str, rssi, name_str)

print(f"Number of devices = {len(DeviceIdentityDict)}")
print(f"Number of readings = {len(DeviceReadingDict)}")

for uuid in sorted(DeviceIdentityDict):
    identity = DeviceIdentityDict[uuid]
    print(f"{uuid} : {identity.name}")

if device_uuid != "":
    t = np.array([])
    rssi = np.array([])
    rssi_f = np.array([])
    
    filter = GMRB_FilteredRSSI(P0=5*Eye, sigma_b=0.5, sigma_g=1, beta_g=0.1, R=25)

    for time in sorted(DeviceReadingDict):
        reading = DeviceReadingDict[time]
        uuid = reading.uuid
        if uuid == device_uuid:
            t = np.concatenate([t, [time]])
            rssi = np.concatenate([rssi, [reading.rssi]])
            filter.update(time, reading.rssi)
            rssi_f = np.concatenate([rssi_f, [filter.x1()]])
            
    print(f"Final P value =\n{filter.P}")
    
    plt.axes(ylim=(-100, 0))
    plt.grid(which='both')

    plt.plot(t, rssi, 'b.')
    plt.plot(t, rssi_f, 'r')

    plt.title(label=f"{DeviceIdentityDict[device_uuid].name}")

    plt.show()
