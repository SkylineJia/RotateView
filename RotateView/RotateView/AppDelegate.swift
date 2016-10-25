//
//  AppDelegate.swift
//  RotateView
//
//  Created by skyline on 16/6/30.
//  Copyright © 2016年 skyline. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let rootController = UINavigationController(rootViewController: RotateViewDemo())
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = rootController
        window!.makeKeyAndVisible()
        return true
    }


}

