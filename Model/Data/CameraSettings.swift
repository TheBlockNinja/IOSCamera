//
//  CameraSkin.swift
//  Camera
//
//  Created by Seann Moser on 11/8/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
struct CameraSettings{
    static let OldSchool = CameraSettings(name: "Old School",
                                          flash: [.off,.on],
                                          focus: .locked,
                                          CameraSkin: nil,
                                          defaultPos:.back,
                                          exposure:.continuousAutoExposure,
                                          focusPoint:nil)
    static let DSLR = CameraSettings(name: "DSLR",
                                     flash: [.off,.auto,.on],
                                     focus: .autoFocus,
                                     CameraSkin: nil)
    static let PointAndShoot = CameraSettings(name: "Point and Shoot",
                                              flash: [.off,.on],
                                              focus: .continuousAutoFocus,
                                              CameraSkin: nil,
                                              defaultPos:.back,
                                              exposure:.autoExpose,
                                              focusPoint:CGPoint(x:0.5,y:0.5))
    
    
    let name:String
    var flash:[AVCaptureDevice.FlashMode]
    var selectedFlash = 0
    var focus:AVCaptureDevice.FocusMode
    var exposure:AVCaptureDevice.ExposureMode
    let CameraSkin:UIImage?
    var defaultPos:AVCaptureDevice.Position?
    var focusPoint:CGPoint? = nil
    
    
    var contentMode = UIView.ContentMode.scaleAspectFill
    
    
    init(name:String,flash:[AVCaptureDevice.FlashMode],
         focus:AVCaptureDevice.FocusMode,
         CameraSkin:UIImage?,
         defaultPos:AVCaptureDevice.Position,
         exposure:AVCaptureDevice.ExposureMode,
         focusPoint:CGPoint?) {
        self.name = name
        self.flash = flash
        self.focus = focus
        self.CameraSkin = CameraSkin
        self.defaultPos = defaultPos
        self.exposure = exposure
        self.focusPoint = focusPoint
    }
    
    init(name:String,flash:[AVCaptureDevice.FlashMode],focus:AVCaptureDevice.FocusMode,CameraSkin:UIImage?,defaultPos:AVCaptureDevice.Position) {
        self.name = name
        self.flash = flash
        self.focus = focus
        self.CameraSkin = CameraSkin
        self.defaultPos = defaultPos
        exposure = .autoExpose
    }
    
    
    init(name:String,flash:[AVCaptureDevice.FlashMode],focus:AVCaptureDevice.FocusMode,CameraSkin:UIImage?) {
        self.name = name
        self.flash = flash
        self.focus = focus
        self.CameraSkin = CameraSkin
        self.defaultPos = .back
        exposure = .autoExpose
    }
    private mutating func incrementFlash(){
        selectedFlash = selectedFlash + 1
        if selectedFlash >= flash.count{
            selectedFlash = 0
        }
    }
    mutating func switchFlash()->AVCaptureDevice.FlashMode{
        self.incrementFlash()
        let currentFlash = flash[selectedFlash]
        return currentFlash
        
    }
    
    
    
}

