//
//  LMEV3ConnectManager.swift
//  SwiftEV3
//
//  Created by Mark33699 on 2019/6/18.
//  Copyright © 2019 謝飛飛. All rights reserved.
//

import Foundation
import ExternalAccessory

class LMEV3ConnectManager //LM = LEGO mindstorms
{
    static let shared = LMEV3ConnectManager.init()
    var brick: Ev3Brick?
    
    init()
    {
//        EAAccessoryManager.shared().unregisterForLocalNotifications()
        
        EAAccessoryManager.shared().registerForLocalNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(accessoryConnected), name: .EAAccessoryDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(accessoryDisconnected), name: .EAAccessoryDidDisconnect, object: nil)
    }
    
    //被動
    @objc func accessoryConnected(notif: Notification) //只有第一次才會call, 無法復現
    {
        print("已經連上休士頓了")
//        if let accessory = notif.userInfo?[EAAccessoryKey] as? EAAccessory
//        {
//            if Ev3Connection.supportsEv3Protocol(accessory: accessory)
//            {
//                connectEV3(accessory)
//            }
//        }
    }
    
    @objc func accessoryDisconnected()
    {
        
    }
    
    //主動
    func findEV3Accessory()
    {
        let manager = EAAccessoryManager.shared()
        
        manager.showBluetoothAccessoryPicker(withNameFilter: nil)
        { (error) in
            
            if error != nil
            {
                print("到底怎樣啦\(error.debugDescription)")
            }
            
            if let accessory = manager.connectedAccessories.first
            {
                if Ev3Connection.supportsEv3Protocol(accessory: accessory)
                {
                    self.connectEV3(accessory)
                }
            }
        }
        
//        let connecteds = manager.connectedAccessories
//        if connecteds.count > 0
//        {
//            for accessory in connecteds
//            {
//                if Ev3Connection.supportsEv3Protocol(accessory: accessory)
//                {
//                    connectEV3(accessory)
//                }
//            }
//        }
    }
    
    fileprivate func connectEV3(_ accessory: EAAccessory)
    {
        let connection = Ev3Connection.init(accessory: accessory)
        connection.open()
        brick = Ev3Brick.init(connection: connection)
        print("\(brick.debugDescription)")
    }
}
