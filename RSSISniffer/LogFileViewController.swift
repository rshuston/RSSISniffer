//
//  LogFileViewController.swift
//  RSSISniffer
//
//  Created by Robert Huston on 7/4/20.
//  Copyright © 2020 Pinpoint Dynamics. All rights reserved.
//

import UIKit

class LogFileViewController: UIViewController {

    @IBOutlet weak var logTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        loadLogFile()
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @IBAction func doClear(_ sender: Any) {
        LogFileManager.clear(fileName: Constants.Files.DeviceSurveillance)
        loadLogFile()
    }

    @IBAction func doCopy(_ sender: Any) {
        UIPasteboard.general.string = LogFileManager.read(fileName: Constants.Files.DeviceSurveillance)
    }

    func loadLogFile() {
        logTextView.text = LogFileManager.read(fileName: Constants.Files.DeviceSurveillance)
    }

}
