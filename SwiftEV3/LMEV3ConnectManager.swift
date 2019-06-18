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
    
    init()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(accessoryConnected), name: .EAAccessoryDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(accessoryDisconnected), name: .EAAccessoryDidDisconnect, object: nil)
        EAAccessoryManager.shared().registerForLocalNotifications()
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
}
