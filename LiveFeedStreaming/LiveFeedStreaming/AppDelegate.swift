//
//  AppDelegate.swift
//  LiveFeedStreaming
//
//  Created by Sarvesh Doshi on 17/12/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setRootView()
        return true
    }

}

extension AppDelegate {
    
    func setRootView() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let liveFeedsPreviewVC = LiveFeedsPreviewVC()
        window?.rootViewController = liveFeedsPreviewVC
        window?.makeKeyAndVisible()
    }
    
}
