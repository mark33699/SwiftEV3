//
//  LMEV3ConnectManager.swift
//  SwiftEV3
//
//  Created by Mark33699 on 2019/6/18.
//  Copyright © 2019 謝飛飛. All rights reserved.
//

/*
 2019-06-21 01:07:42.767500+0800 SwiftEV3[3253:563781] [MC] System group container for systemgroup.com.apple.configurationprofiles path is /private/var/containers/Shared/SystemGroup/systemgroup.com.apple.configurationprofiles
 2019-06-21 01:07:42.769359+0800 SwiftEV3[3253:563781] [MC] Reading from public effective user settings.
 2019-06-21 01:07:42.824258+0800 SwiftEV3[3253:563781] A constraint factory method was passed a nil layout anchor.  This is not allowed, and may cause confusing exceptions. Break on BOOL _NSLayoutConstraintToNilAnchor(void) to debug.  This will be logged only once.  This may break in the future.
 */

import Foundation
import ExternalAccessory

//extension NSNotification.Name
//{
//    static let LMEV3ConnectSuccess: NSNotification.Name
//    static let LMEV3ConnectFail: NSNotification.Name
//}

let LMEV3ConnectSuccess = NSNotification.Name(rawValue: "LMEV3ConnectSuccess")
let LMEV3ConnectFail = NSNotification.Name(rawValue: "LMEV3ConnectFail")

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
    @objc func accessoryConnected(notif: Notification) //只有第一次Alert才會call, 無法復現 (好像EV3重開就會了)
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
                }
                else
                {
                    NotificationCenter.default.post(name: .EAAccessoryDidConnect, object: nil)
                }
            }
        }
    }
    
    fileprivate func connectEV3(_ accessory: EAAccessory)
    {
        let connection = Ev3Connection.init(accessory: accessory)
        connection.open()
        brick = Ev3Brick.init(connection: connection) //經測試, 好像原因是不生brick就有一定機率閃退
        print("\(brick.debugDescription)")
        NotificationCenter.default.post(name: LMEV3ConnectSuccess, object: nil)
    }
}
