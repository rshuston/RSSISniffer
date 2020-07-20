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

    var surveillanceManager: SurveillanceManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        DeviceTableView.dataSource = self

        // iOS Development 101:
        // UIKit won't create the empty rows when the table has a footer view
        DeviceTableView.tableFooterView = UIView(frame: CGRect.zero)

        // iOS Development 101:
        // Do this to allow cell height to autosize
        DeviceTableView.rowHeight = UITableView.automaticDimension
        DeviceTableView.estimatedRowHeight = 200

        surveillanceManager = SurveillanceManager(dataChangeNotificationHandler: dataChangeNotificationHandler)
    }

    func dataChangeNotificationHandler() {
        DispatchQueue.main.async {
            self.DeviceTableView.reloadData()
        }
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
        surveillanceManager?.startScanningForPeripherals()
        StartStopButton.setTitle("Stop", for: .normal)
    }

    func stopSurveillance() {
        surveillanceManager?.stopScanningForPeripherals()
        StartStopButton.setTitle("Start", for: .normal)
    }

}

// MARK: - UITableViewDataSource methods

extension SurveillanceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surveillanceManager?.getNumberOfDevices() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.DeviceCellReuseIdentifier) as! DeviceTableViewCell
        if let device = surveillanceManager?.getDevice(atIndex: indexPath.row) {
            cell.Name.text = device.name
            cell.UUID.text = device.uuid
            cell.FilteredRSSI.text = String(format: "F: %.1f", device.RSSI)
            cell.RawRSSI.text = String(format: "R: %.1f", device.rawRSSI)
        } else {
            cell.Name.text = ""
            cell.UUID.text = ""
            cell.FilteredRSSI.text = ""
            cell.RawRSSI.text = ""
        }
        return cell
    }

}
