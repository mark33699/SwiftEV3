//
//  LMEV3ConnectManager.swift
//  SwiftEV3
//
//  Created by Mark33699 on 2019/6/18.
//  Copyright © 2019 謝飛飛. All rights reserved.
//

import Foundation
import ExternalAccessory

let LMEV3ConnectSuccess = NSNotification.Name(rawValue: "LMEV3ConnectSuccess")
let LMEV3ConnectFail = NSNotification.Name(rawValue: "LMEV3ConnectFail")

class LMEV3ConnectManager //LM = LEGO mindstorms
{
    static let shared = LMEV3ConnectManager.init()
    var brick: Ev3Brick?
    
    init()
    {
        EAAccessoryManager.shared().registerForLocalNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(accessoryConnected), name: .EAAccessoryDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(accessoryDisconnected), name: .EAAccessoryDidDisconnect, object: nil)
    }
    
    //被動
    @objc func accessoryConnected(notif: Notification) //只有第一次Alert才會call, 無法復現 (好像EV3重開就會了)
    {
        print("已經連上休士頓了")
    }
    
    @objc func accessoryDisconnected()
    {
        /* https://stackoverflow.com/questions/16227594/disconnect-external-accessory-without-physically-disconnecting
         
         The only way I see for a soft disconnect is to close the EASession's inputStream and outputStream.
         
         */
    }
    
    //主動
    func findEV3Accessory()
    {
        let manager = EAAccessoryManager.shared()
        let connecteds = manager.connectedAccessories
        if connecteds.count > 0 //只要Picker曾經選過, 這邊就會有
        {
            for accessory in connecteds
            {
                if Ev3Connection.supportsEv3Protocol(accessory: accessory)
                {
                    connectEV3(accessory)
                }
            }
        }
        else
        {
            manager.showBluetoothAccessoryPicker(withNameFilter: nil)
            { (error) in
    
                if error != nil
                {
                    print("選擇EV3時錯誤：\(error.debugDescription)")
                }
    
                if let accessory = manager.connectedAccessories.first
                {
                    if Ev3Connection.supportsEv3Protocol(accessory: accessory)
                    {
                        self.connectEV3(accessory)
                    }
                    else
                    {
                        NotificationCenter.default.post(name: LMEV3ConnectFail, object: nil)
                    }
                }
            }
        }
    }
    
    fileprivate func connectEV3(_ accessory: EAAccessory)
    {
        let connection = Ev3Connection.init(accessory: accessory)
        connection.open()
        brick = Ev3Brick.init(connection: connection) //經測試, 好像原因是不生brick就有一定機率閃退
        NotificationCenter.default.post(name: LMEV3ConnectSuccess, object: nil)
    }
}
