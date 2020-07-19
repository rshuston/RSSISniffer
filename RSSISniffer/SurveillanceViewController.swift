//
//  SurveillanceViewController.swift
//  RSSISniffer
//
//  Created by Robert Huston on 6/30/20.
//  Copyright © 2020 Pinpoint Dynamics. All rights reserved.
//

import UIKit

class SurveillanceViewController: UIViewController {

    @IBOutlet weak var StartStopButton: UIButton!
    @IBOutlet weak var DeviceTableView: UITableView!

    var surveillanceManager: SurveillanceManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        surveillanceManager = SurveillanceManager()
    }
    
    @IBAction func doStartStop(_ sender: Any) {
        if let buttonText = StartStopButton.title(for: .normal) {
            switch buttonText {
            case "Start":
                startSurveillance()
            case "Stop":
                stopSurveillance()
            default:
                break
            }
        }
    }

    func startSurveillance() {
        surveillanceManager.startScanningForPeripherals()
        StartStopButton.setTitle("Stop", for: .normal)
    }

    func stopSurveillance() {
        surveillanceManager.stopScanningForPeripherals()
        StartStopButton.setTitle("Start", for: .normal)
    }

}
