//
//  AppDelegate.swift
//  SwiftEV3
//
//  Created by 謝飛飛 on 2019/6/13.
//  Copyright © 2019 謝飛飛. All rights reserved.
//

import UIKit
import ExternalAccessory

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /*Step By Step
     
     1.Make sure, iOS compatibility is enabled on the ev3 //How?
     
     2.Add the Ev3 Protocol to the 'info.plist'
         add row (if 'Supported external accessory protocols' not exists)
         choose 'Supported external accessory protocols'
         Set value for Item # to 'COM.LEGO.MINDSTORMS.EV3'
     
     3.The 'Ev3Brick' just needs a 'Ev3Connection', which needs a 'EAAccessory'.
     To optain a 'EAAccessory' you can access the 'EAAccessoryManager' and loop over all connected devices.
     
     */


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        NotificationCenter.default.addObserver(self, selector: #selector(accessoryConnected), name: .EAAccessoryDidConnect, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(accessoryDisconnected), name: EAAccessoryDidDisconnectNotification, object: nil)
//        EAAccessoryManager.sharedAccessoryManager().registerForLocalNotifications()
        
        return true
    }
    
    @objc func accessoryConnected()
    {
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

