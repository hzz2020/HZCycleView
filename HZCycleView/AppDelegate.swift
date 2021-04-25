//
//  AppDelegate.swift
//  HZCycleView
//
//  Created by laolai on 2020/7/16.
//  Copyright © 2020 llh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = BaseTabbarController();
        
        // 开始网络状态监测
        // 由于可能多个地方需要知道网络状态，所以添加通知`kNetworkStatusNotification`即可
        // 在通知回调方法里面，判断`HN.networkStatus`即可
        HN.startMonitoring()
        
        return true
    }
}

