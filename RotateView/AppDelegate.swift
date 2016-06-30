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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let rootController = UINavigationController(rootViewController: RotateViewDemo())
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = rootController
        window!.makeKeyAndVisible()
        return true
    }


}

