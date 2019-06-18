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
     
     1.先確定iOS相容EV3
     
     2.Plist加入 'Supported external accessory protocols'：'COM.LEGO.MINDSTORMS.EV3'
     
     3.import ExternalAccessory
     
     4.'Ev3Brick' < 'Ev3Connection' < 'EAAccessory'. (用EAAccessoryManager去掃)
     
     */


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        NotificationCenter.default.addObserver(self, selector: #selector(accessoryConnected), name: .EAAccessoryDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(accessoryDisconnected), name: .EAAccessoryDidDisconnect, object: nil)
        EAAccessoryManager.shared().registerForLocalNotifications()
        
        return true
    }
    
    //被動
    @objc func accessoryConnected(notif: Notification)
    {
        if let accessory = notif.userInfo?[EAAccessoryKey] as? EAAccessory
        {
            if Ev3Connection.supportsEv3Protocol(accessory: accessory)
            {
                connectEV3(accessory)
            }
        }
    }
    
    @objc func accessoryDisconnected()
    {
        
    }
    
    //主動
    func findEV3Accessory()
    {
        let manager = EAAccessoryManager.shared()
        let connecteds = manager.connectedAccessories
        for accessory in connecteds
        {
            if Ev3Connection.supportsEv3Protocol(accessory: accessory)
            {
                connectEV3(accessory)
            }
        }
    }
    
    fileprivate func connectEV3(_ accessory: EAAccessory)
    {
        let connection = Ev3Connection.init(accessory: accessory)
        connection.open()
        //        let brick = Ev3Brick.init(connection: connection)
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

