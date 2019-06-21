//
//  ViewController.swift
//  SwiftEV3
//
//  Created by 謝飛飛 on 2019/6/13.
//  Copyright © 2019 謝飛飛. All rights reserved.
//

import UIKit
import CoreMotion

class JoystickViewController: UIViewController
{
    let ev3ConncetManager = LMEV3ConnectManager.shared
    let motionManager = CMMotionManager.init()
    
    @IBOutlet weak var labHint: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ev3ConncetManager.findEV3Accessory()
        
        motionManager.accelerometerUpdateInterval = 0.25
        motionManager.startAccelerometerUpdates(to: OperationQueue.init())
        { (accelerometerData, error) in
            
            let isLandScapeRight = UIDevice.current.orientation == .landscapeRight
            if let acceleration = accelerometerData?.acceleration
            {
                var strDirection = ""
                if isLandScapeRight
                {
                    strDirection = acceleration.y > 0 ? "往右" : "往左"
                }
                else
                {
                    strDirection = acceleration.y > 0 ? "往左" : "往右"
                }
                let ceilY = ceil(acceleration.y * 1000) / 1000
                DispatchQueue.main.async
                {
                    self.labHint.text = strDirection + "\(fabs(ceilY))"
                }
            }
        }
        
        /*
         官方功能
         
         TypeA.
         
            搖桿(ABCD防呆不可能重複)
                左馬達
                    ABCD選一
                    左右方向選一
                右馬達
                    ABCD選一
                    左右方向選一
         
         二維TILT(ABCD防呆不可能重複)
         左馬達
         ABCD選一
         左右方向選一
         右馬達
         ABCD選一
         左右方向選一
         
         TypeB.
            水平滑桿
                ABCD選一
                左右方向選一
            垂直滑桿
                ABCD選一
                左右方向選一
         左右TILT(傾斜)
         ABCD選一
         左右方向選一
         前後TILT
         ABCD選一
         左右方向選一
         開關
         ABCD選一
         左右方向選一
         
         TypeC.
         按鈕
         ABCD選一
         左右方向選一
         秒數(0.2~5秒)
         
         TypeD.
            接觸感應器
                ABCD選一
            IR(紅外線)感應器
                ABCD選一
            顏色感應器
                ABCD選一
         
         */
        
        /* 命令篇
         
         1. DirectCommands 單次性
            馬達轉速
            取得資訊(有些感測器的沒有)
         2. BatchCommands 批次性(有個queue)
            (看太不出來怎麼應用)
         3. SystemCommands 系統性
            也是僅此一次
            (好像還沒實做出來= =)
         */
        
        /* 問題篇
         如果在短時間內發送大的直接命令（例如，輪詢傳感器值/按鈕狀態）或連續的許多命令，我們觀察到藍牙斷開連接。有時必須重新啟動Ev3，才能通過藍牙再次連接。(可能的原因EASession.outputStream.hasSpaceAvailable
         is always returning true)
            暫時解：
         /// max command buffer size
         let maxBufferSize = 2
         
         /// sleeping time after each command was send to ev3
         let connSleepTime = 0.125
         */
        
    }


}

