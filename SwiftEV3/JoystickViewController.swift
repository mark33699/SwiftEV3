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
         motionManager = [CMMotionManager new];
         motionManager.accelerometerUpdateInterval = 0.01;
         [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error)
         {
         if (currentBoboAction != BoboActionTypeGosh)
         {
         NSInteger intLandScape = UIDevice.currentDevice.orientation == UIDeviceOrientationLandscapeRight ? -1 : 1;
         //             CCLOG(@"方向為%d",intLandScape);
         
         CMAcceleration acceleration = accelerometerData.acceleration;
         currentBoboAction = acceleration.y > 0 ? BoboActionTypeLeft : BoboActionTypeRight;
         
         CGFloat newX = boboWalking.position.x + (acceleration.y * -offsetBobo * intLandScape);
         newX = MIN(MAX(newX, minX),maxX);
         [self performSelectorOnMainThread:@selector(updateBobo:) withObject:@(newX) waitUntilDone:NO];
         
         CGFloat thisMoveBg1 = (acceleration.y * offsetBg1 * intLandScape);
         if (fabs(totleMoveBg1) < canMoveDistanceBg1){
         totleMoveBg1 += thisMoveBg1;
         CGFloat newXbg1 = bg1.position.x + thisMoveBg1;
         [self performSelectorOnMainThread:@selector(updateBg1:) withObject:@(newXbg1) waitUntilDone:NO];
         }
         else if (totleMoveBg1 > 0 && thisMoveBg1 < 0){
         totleMoveBg1 += thisMoveBg1;
         }
         else if (totleMoveBg1 < 0 && thisMoveBg1 > 0){
         totleMoveBg1 += thisMoveBg1;
         }
         }];
         
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

