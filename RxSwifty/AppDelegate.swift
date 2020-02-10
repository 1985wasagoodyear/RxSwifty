//
//  AppDelegate.swift
//  RxSwifty
//
//  Created by Kevin Yu on 1/21/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = self.window ?? UIWindow(frame: UIScreen.main.bounds)
        let vc = MenuViewController()
        vc.title = "RxSwift Demo Options"
        let rootNav = UINavigationController.init(rootViewController: vc)
        self.window?.rootViewController = rootNav
        self.window?.makeKeyAndVisible()
        
        return true
    }
}
