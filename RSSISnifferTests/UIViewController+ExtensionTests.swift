//
//  UIViewController+ExtensionTests.swift
//  RSSISnifferTests
//
//  Created by Robert Huston on 7/20/20.
//  Copyright © 2016, 2020 Pinpoint Dynamics. All rights reserved.
//


import XCTest

class UIViewController_ExtensionTests: XCTestCase {

    func test_frontViewController_HandlesEmptyViewControllerHierarchy() {
        let window0 = UIApplication.shared.windows[0]
        window0.rootViewController = nil
        
        window0.makeKey()
        
        let frontViewController = UIViewController.frontViewController()

        XCTAssertNil(frontViewController)
    }

    func test_frontViewController_FindsRootViewController() {
        let window0 = UIApplication.shared.windows[0]
        let rootViewController = UIViewController()
        window0.rootViewController = rootViewController
        
        window0.makeKey()

        let frontViewController = UIViewController.frontViewController()

        XCTAssert(frontViewController === rootViewController)
    }

    func test_frontViewController_FindsRootViewControllerOfSubclass() {
        let window0 = UIApplication.shared.windows[0]
        let rootViewController = TestUIViewController()
        window0.rootViewController = rootViewController
        
        window0.makeKey()

        let frontViewController = UIViewController.frontViewController()

        XCTAssert(frontViewController === rootViewController)
    }
    
    func test_frontViewController_FindsPresentedViewControllerOfSubclass() {
        let window0 = UIApplication.shared.windows[0]
        let rootViewController = UIViewController()
        let rootView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        rootViewController.view = rootView
        window0.rootViewController = rootViewController
        window0.addSubview(rootView)
        
        window0.makeKey()

        let presentedController = TestUIViewController()
        rootViewController.present(presentedController, animated: false, completion: nil)

        let frontViewController = UIViewController.frontViewController()

        XCTAssert(frontViewController === presentedController)
    }

    func test_frontViewController_FindsSplitViewController() {
        let window0 = UIApplication.shared.windows[0]
        let splitViewController = UISplitViewController()
        let masterViewController = UIViewController()
        let detailViewController = UIViewController()
        window0.rootViewController = splitViewController
        splitViewController.viewControllers = [masterViewController, detailViewController]

        window0.makeKey()

        let frontViewController = UIViewController.frontViewController()

        XCTAssert(frontViewController === detailViewController)
    }

    func test_frontViewController_FindsSplitViewControllerOfSubclasses() {
        let window0 = UIApplication.shared.windows[0]
        let splitViewController = TestUISplitViewController()
        let masterViewController = TestUIViewController()
        let detailViewController = TestUIViewController()
        window0.rootViewController = splitViewController
        splitViewController.viewControllers = [masterViewController, detailViewController]

        window0.makeKey()

        let frontViewController = UIViewController.frontViewController()

        XCTAssert(frontViewController === detailViewController)
    }

    func test_frontViewController_FindsNavigationViewController() {
        let window0 = UIApplication.shared.windows[0]
        let navigationViewController = UINavigationController()
        window0.rootViewController = navigationViewController
        let pushedViewController = UIViewController()
        navigationViewController.pushViewController(pushedViewController, animated: false)

        window0.makeKey()

        let frontViewController = UIViewController.frontViewController()

        XCTAssert(frontViewController === pushedViewController)
    }

    func test_frontViewController_FindsNavigationViewControllerOfSubclass() {
        let window0 = UIApplication.shared.windows[0]
        let navigationViewController = TestUINavigationController()
        window0.rootViewController = navigationViewController
        let pushedViewController = TestUIViewController()
        navigationViewController.pushViewController(pushedViewController, animated: false)

        window0.makeKey()

        let frontViewController = UIViewController.frontViewController()

        XCTAssert(frontViewController === pushedViewController)
    }

    func test_frontViewController_FindsTabBarViewController() {
        let window0 = UIApplication.shared.windows[0]
        let tabBarViewController = UITabBarController()
        window0.rootViewController = tabBarViewController
        let firstViewController = UIViewController()
        let secondViewController = UIViewController()
        tabBarViewController.viewControllers = [firstViewController, secondViewController]
        tabBarViewController.selectedIndex = 1
        
        window0.makeKey()

        let frontViewController = UIViewController.frontViewController()

        XCTAssert(frontViewController === secondViewController)
    }

    func test_frontViewController_FindsTabBarViewControllerOfSubclasses() {
        let window0 = UIApplication.shared.windows[0]
        let tabBarViewController = TestUITabBarController()
        window0.rootViewController = tabBarViewController
        let firstViewController = TestUIViewController()
        let secondViewController = TestUIViewController()
        tabBarViewController.viewControllers = [firstViewController, secondViewController]
        tabBarViewController.selectedIndex = 1

        window0.makeKey()

        let frontViewController = UIViewController.frontViewController()

        XCTAssert(frontViewController === secondViewController)
    }

    func test_frontViewController_FindsFrontViewControllerInCombinationHierarchy() {
        let window0 = UIApplication.shared.windows[0]
        let tabBarViewController = TestUITabBarController()
        window0.rootViewController = tabBarViewController
        let navigationViewController = TestUINavigationController()
        let viewController = TestUIViewController()
        tabBarViewController.viewControllers = [navigationViewController, viewController]
        tabBarViewController.selectedIndex = 0

        let pushedViewController = TestUIViewController()
        navigationViewController.pushViewController(pushedViewController, animated: false)

        window0.makeKey()

        let frontViewController = UIViewController.frontViewController()

        XCTAssert(frontViewController === pushedViewController)
    }

    class TestUIViewController: UIViewController {
        let name = "TestUIViewController"
    }

    class TestUISplitViewController: UISplitViewController {
        let name = "TestUISplitViewController"
    }

    class TestUINavigationController: UINavigationController {
        let name = "TestUINavigationController"
    }

    class TestUITabBarController: UITabBarController {
        let name = "TestUITabBarController"
    }

}
