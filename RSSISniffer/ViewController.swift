//
//  ViewController.swift
//  RSSISniffer
//
//  Created by Robert Huston on 6/30/20.
//  Copyright © 2020 Pinpoint Dynamics. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {

    @IBOutlet weak var StartStopButton: UIButton!
    @IBOutlet weak var CentralStateLabel: UILabel!

    let Red_Green_UUID = CBUUID(string: "573548B2-440F-39E4-6F2E-C7ABDE070D96")

    var centralManager: CBCentralManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    @IBAction func doStartStop(_ sender: Any) {
        if let buttonText = StartStopButton.title(for: .normal) {
            switch buttonText {
            case "Start":
                startScanningForPeripherals()
            case "Stop":
                stopScanningForPeripherals()
            default:
                break
            }
        }
    }

    func startScanningForPeripherals() {
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        StartStopButton.setTitle("Stop", for: .normal)
    }

    func stopScanningForPeripherals() {
        centralManager.stopScan()
        StartStopButton.setTitle("Start", for: .normal)
    }

}

extension ViewController: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let stateMsg: String
        switch central.state {
        case .unknown:
            stateMsg = "central.state is .unknown"
        case .resetting:
            stateMsg = "central.state is .resetting"
        case .unsupported:
            stateMsg = "central.state is .unsupported"
        case .unauthorized:
            stateMsg = "central.state is .unauthorized"
        case .poweredOff:
            stateMsg = "central.state is .poweredOff"
            stopScanningForPeripherals()
        case .poweredOn:
            stateMsg = "central.state is .poweredOn"
            startScanningForPeripherals()
        @unknown default:
            stateMsg = "central.state default is \(central.state)"
        }
        print(stateMsg)
        CentralStateLabel.text = stateMsg
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        let uuid = peripheral.identifier
        let name = peripheral.name ?? "?"

        print("peripheral: uuid = \(uuid), RSSI = \(RSSI.stringValue), name = \(name)")
    }

}
