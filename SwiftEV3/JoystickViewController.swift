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
    
    let rightPort: OutputPort = .C
    let leftPort: OutputPort = .B
    //為什麼可以這樣寫????型別根本不是陣列啊
    let defaultPorts: OutputPort = [.B, .C]
    
    var directionValue: Double = 0.0
    var isTurnRight: Bool = true
    
    @IBOutlet weak var labHint: UILabel!
    @IBOutlet var switchPower: UISwitch!
    @IBOutlet var switchGoForward: UISwitch!
    @IBOutlet var sliderSpeed: UISlider!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(eV3ConnectSuccess), name: LMEV3ConnectSuccess, object: nil)
        ev3ConncetManager.findEV3Accessory()
        
        startAccelerometer()
        switchPower.addTarget(self, action: #selector(powerDidChange), for: .valueChanged)
//        sliderSpeed.transform = CGAffineTransform.init(rotationAngle: .pi * 0.5) //這樣操作一次就壞掉
    }
    
    @objc func eV3ConnectSuccess()
    {
        switchPower.isEnabled = true
    }
    
    func startAccelerometer()
    {
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
                    self.isTurnRight = acceleration.y > 0
                }
                else
                {
                    strDirection = acceleration.y > 0 ? "往左" : "往右"
                    self.isTurnRight = acceleration.y < 0
                }
                let ceilY = ceil(acceleration.y * 1000) / 1000
                self.directionValue = fabs(ceilY)
                DispatchQueue.main.async
                {
                    self.labHint.text = strDirection + "\(self.directionValue)"
                    self.sendTurnCommand()
                }
            }
        }
    }
    
    func sendTurnCommand()
    {
        if switchPower.isOn
        {
            let command = Ev3Command(commandType: .directNoReply)
            let slowSpeed = Int16( sliderSpeed!.value * (1 - Float(directionValue)))
            command.turnMotorAtPower(ports: isTurnRight ? rightPort : leftPort,
                                     power: switchGoForward.isOn ? slowSpeed : -slowSpeed)
            let fastSpeed = Int16(sliderSpeed!.value)
            command.turnMotorAtPower(ports: isTurnRight ? leftPort : rightPort,
                                     power: switchGoForward.isOn ? fastSpeed : -fastSpeed)
            command.startMotor(ports: defaultPorts)
            ev3ConncetManager.brick?.sendCommand(command)
        }
    }
    
    @objc func powerDidChange()
    {
        if switchPower.isOn == false
        {
            ev3ConncetManager.brick?.directCommand.stopMotor(onPorts: defaultPorts, withBrake: true)
        }
    }
    
}
