//
//  UIViewController+ExtensionTests.swift
//  RSSISnifferTests
//
//  Created by Robert Huston on 7/20/20.
//  Copyright © 2016, 2020 Pinpoint Dynamics. All rights reserved.
//


import XCTest

class UIViewController_ExtensionTests: XCTestCase {
    
    var topWindow: UIWindow!
    var savedRootViewController: UIViewController!
    
    override func setUpWithError() throws {
        topWindow = UIApplication.shared.windows.last
        savedRootViewController = topWindow.rootViewController
    }
    
    override func tearDownWithError() throws {
        topWindow.rootViewController = savedRootViewController
        savedRootViewController = nil
        topWindow = nil
    }
    
    func test_frontViewController_HandlesEmptyViewControllerHierarchy() {
        topWindow.rootViewController = nil
        
        let frontViewController = UIViewController.frontViewController()
        
        XCTAssertNil(frontViewController)
    }
    
    func test_frontViewController_FindsRootViewController() {
        let rootViewController = UIViewController()
        topWindow.rootViewController = rootViewController
        
        let frontViewController = UIViewController.frontViewController()
        
        XCTAssert(frontViewController === rootViewController)
    }
    
    func test_frontViewController_FindsRootViewControllerOfSubclass() {
        let rootViewController = TestUIViewController()
        topWindow.rootViewController = rootViewController
        
        let frontViewController = UIViewController.frontViewController()
        
        XCTAssert(frontViewController === rootViewController)
    }
    
    func test_frontViewController_FindsPresentedViewControllerOfSubclass() {
        let rootViewController = UIViewController()
        let rootView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        rootViewController.view = rootView
        topWindow.rootViewController = rootViewController
        topWindow.addSubview(rootView)
        
        let presentedController = TestUIViewController()
        rootViewController.present(presentedController, animated: false, completion: nil)
        
        let frontViewController = UIViewController.frontViewController()
        
        XCTAssert(frontViewController === presentedController)
    }
    
    func test_frontViewController_FindsSplitViewController() {
        let splitViewController = UISplitViewController()
        let masterViewController = UIViewController()
        let detailViewController = UIViewController()
        topWindow.rootViewController = splitViewController
        splitViewController.viewControllers = [masterViewController, detailViewController]
        
        let frontViewController = UIViewController.frontViewController()
        
        XCTAssert(frontViewController === detailViewController)
    }
    
    func test_frontViewController_FindsSplitViewControllerOfSubclasses() {
        let splitViewController = TestUISplitViewController()
        let masterViewController = TestUIViewController()
        let detailViewController = TestUIViewController()
        topWindow.rootViewController = splitViewController
        splitViewController.viewControllers = [masterViewController, detailViewController]
        
        let frontViewController = UIViewController.frontViewController()
        
        XCTAssert(frontViewController === detailViewController)
    }
    
    func test_frontViewController_FindsNavigationViewController() {
        let navigationViewController = UINavigationController()
        topWindow.rootViewController = navigationViewController
        let pushedViewController = UIViewController()
        navigationViewController.pushViewController(pushedViewController, animated: false)
        
        let frontViewController = UIViewController.frontViewController()
        
        XCTAssert(frontViewController === pushedViewController)
    }
    
    func test_frontViewController_FindsNavigationViewControllerOfSubclass() {
        let navigationViewController = TestUINavigationController()
        topWindow.rootViewController = navigationViewController
        let pushedViewController = TestUIViewController()
        navigationViewController.pushViewController(pushedViewController, animated: false)
        
        let frontViewController = UIViewController.frontViewController()
        
        XCTAssert(frontViewController === pushedViewController)
    }
    
    func test_frontViewController_FindsTabBarViewController() {
        let tabBarViewController = UITabBarController()
        topWindow.rootViewController = tabBarViewController
        let firstViewController = UIViewController()
        let secondViewController = UIViewController()
        tabBarViewController.viewControllers = [firstViewController, secondViewController]
        tabBarViewController.selectedIndex = 1
        
        let frontViewController = UIViewController.frontViewController()
        
        XCTAssert(frontViewController === secondViewController)
    }
    
    func test_frontViewController_FindsTabBarViewControllerOfSubclasses() {
        let tabBarViewController = TestUITabBarController()
        topWindow.rootViewController = tabBarViewController
        let firstViewController = TestUIViewController()
        let secondViewController = TestUIViewController()
        tabBarViewController.viewControllers = [firstViewController, secondViewController]
        tabBarViewController.selectedIndex = 1
        
        let frontViewController = UIViewController.frontViewController()
        
        XCTAssert(frontViewController === secondViewController)
    }
    
    func test_frontViewController_FindsFrontViewControllerInCombinationHierarchy() {
        let tabBarViewController = TestUITabBarController()
        topWindow.rootViewController = tabBarViewController
        let navigationViewController = TestUINavigationController()
        let viewController = TestUIViewController()
        tabBarViewController.viewControllers = [navigationViewController, viewController]
        tabBarViewController.selectedIndex = 0
        
        let pushedViewController = TestUIViewController()
        navigationViewController.pushViewController(pushedViewController, animated: false)
        
        let frontViewController = UIViewController.frontViewController()
        
        XCTAssert(frontViewController === pushedViewController)
    }
    
    private class TestUIViewController: UIViewController {
        let name = "TestUIViewController"
    }
    
    private class TestUISplitViewController: UISplitViewController {
        let name = "TestUISplitViewController"
    }
    
    private class TestUINavigationController: UINavigationController {
        let name = "TestUINavigationController"
    }
    
    private class TestUITabBarController: UITabBarController {
        let name = "TestUITabBarController"
    }

}
