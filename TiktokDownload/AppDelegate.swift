//
//  AppDelegate.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        FontFamily.registerAllCustomFonts()
        setRootViewcontroller()
        return true
    }

    func setRootViewcontroller() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeVC = HomeRouter.setupModule()
        let nav = UINavigationController(rootViewController: homeVC)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}

