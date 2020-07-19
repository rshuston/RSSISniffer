//
//  OptionsViewController.swift
//  RSSISniffer
//
//  Created by Robert Huston on 7/18/20.
//  Copyright © 2020 Pinpoint Dynamics. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // This exists so that we can unwind the presentation segue from the Options Dismiss button
    @IBAction func OptionsUnwindAction(unwindSegue: UIStoryboardSegue) {
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.OptionsToLogViewSegue {
            segue.destination.modalPresentationStyle = .fullScreen
            segue.destination.modalTransitionStyle = .flipHorizontal
        }
    }

}
