//
//  ViewController.swift
//  SwiftEV3
//
//  Created by 謝飛飛 on 2019/6/13.
//  Copyright © 2019 謝飛飛. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let lmConncetManager = LMEV3ConnectManager.shared
        
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

