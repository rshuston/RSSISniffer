//
//  DeviceTableViewCell.swift
//  RSSISniffer
//
//  Created by Robert Huston on 7/19/20.
//  Copyright © 2020 Pinpoint Dynamics. All rights reserved.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var UUID: UILabel!
    @IBOutlet weak var FilteredRSSI: UILabel!
    @IBOutlet weak var RawRSSI: UILabel!

}
