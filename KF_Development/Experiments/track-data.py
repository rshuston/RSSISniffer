#!/usr/bin/env python3

import sys
import csv
import math
import numpy as np
import matplotlib.pyplot as plt

class DeviceIdentity:
    def __init__(self, name):
        self.name = name

class DeviceReading:
    def __init__(self, uuid, rssi, name):
        self.uuid = uuid
        self.rssi = rssi
        self.name = name

class FilteredRSSI:
    def __init__(self, P0=1, sigma=1, beta=1, R=1):
        self.state = 0
        self.P = P0
        self.sigma_sq = sigma * sigma
        self.beta = beta
        self.R = R
        
    def update(self, t, z):
        if self.state == 0:
            self.t = t
            self.x = z
            self.state = 1
        else:
            tau = t - self.t
            self.t = t
            phi = math.exp(- self.beta * tau)
            Q = self.sigma_sq * self.beta * (1 - math.exp(-2 * tau))
            x_m = phi * self.x
            P_m = phi * phi * self.P + Q
            K = P_m / (P_m + self.R)
            self.x = x_m + K * (z - x_m)
            self.P = (1 - K) * P_m        

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
    
    filter = FilteredRSSI(P0=5, sigma=10, beta=0.001, R=10)

    for time in sorted(DeviceReadingDict):
        reading = DeviceReadingDict[time]
        uuid = reading.uuid
        if uuid == device_uuid:
            t = np.concatenate([t, [time]])
            rssi = np.concatenate([rssi, [reading.rssi]])
            filter.update(time, reading.rssi)
            rssi_f = np.concatenate([rssi_f, [filter.x]])

    print(f"Final P value = {filter.P}")
    
    plt.axes(ylim=(-100, 0))
    plt.grid(which='both')

    plt.plot(t, rssi, 'b.')
    plt.plot(t, rssi_f, 'r')

    plt.title(label=f"{DeviceIdentityDict[device_uuid].name}")

    plt.show()
