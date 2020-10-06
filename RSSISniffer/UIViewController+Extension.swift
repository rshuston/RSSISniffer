//
//  UIViewController+Extension.swift
//  RSSISniffer
//
//  Created by Robert Huston on 7/20/20.
//  Copyright © 2016, 2020 Pinpoint Dynamics. All rights reserved.
//

import UIKit

public extension UIViewController {

    // Find the front view controller by traversing the view controller hierarchy
    class func frontViewController() -> UIViewController? {
        return _findBestViewControllerFrom(UIApplication.shared.windows.last?.rootViewController)
    }

    // Private recursive search function to find best front view controller
    fileprivate class func _findBestViewControllerFrom(_ viewController: UIViewController?) -> UIViewController? {
        var bestViewController: UIViewController?

        if viewController?.presentedViewController != nil {
            // Return something from modally presented view
            bestViewController = _findBestViewControllerFrom(viewController?.presentedViewController)
        } else {
            switch viewController {
            case is UISplitViewController:
                // Return something from right-hand side view
                let svc = viewController as! UISplitViewController
                bestViewController = _findBestViewControllerFrom(svc.viewControllers.last)
            case is UINavigationController:
                // Return something from top view
                let nc = viewController as! UINavigationController
                bestViewController = _findBestViewControllerFrom(nc.topViewController)
            case is UITabBarController:
                // Return something from visible view
                let tbc = viewController as! UITabBarController
                bestViewController = _findBestViewControllerFrom(tbc.selectedViewController)
            default:
                // Return what we already have
                bestViewController = viewController
            }
        }

        return bestViewController
    }

}
