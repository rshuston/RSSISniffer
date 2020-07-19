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

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.OptionsToLogViewSegue {
            segue.destination.modalPresentationStyle = .fullScreen
            segue.destination.modalTransitionStyle = .flipHorizontal
        }
    }

}
