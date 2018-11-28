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
struct Cameras{
    static let non = Cameras(name: "non",
                              flash: [.off],
                              focus: [.autoFocus],
                              CameraSkin: nil,
                              filterName:[ImageManipulation.NON])
    
    static let OldSchool = Cameras(name: "Old School",
                                          flash: [.off,.on],
                                          focus: [.locked],
                                          CameraSkin: nil,
                                          defaultPos:.back,
                                          exposure:.continuousAutoExposure,
                                          focusPoint:nil,
                                          filterName:[ImageManipulation.GRAYSCALE])
    static let DSLR = Cameras(name: "DSLR",
                                     flash: [.off,.auto,.on],
                                     focus: [.autoFocus,.locked,.continuousAutoFocus],
                                     CameraSkin: nil,
                                     filterName:[ImageManipulation.NON])
    static let PointAndShoot = Cameras(name: "Point and Shoot",
                                              flash: [.off,.on],
                                              focus: [.continuousAutoFocus],
                                              CameraSkin: nil,
                                              defaultPos:.back,
                                              exposure:.autoExpose,
                                              focusPoint:CGPoint(x:0.5,y:0.5),
                                              filterName:[ImageManipulation.SEPIA])
    
    
    
    let name:String
    var flash:[AVCaptureDevice.FlashMode]
    var selectedFlash = 0
    var focus:[AVCaptureDevice.FocusMode]
    var selectedFocus = 0
    var exposure:AVCaptureDevice.ExposureMode
    let CameraSkin:UIImage?
    var defaultPos:AVCaptureDevice.Position?
    var focusPoint:CGPoint? = nil
    var contentMode = UIView.ContentMode.scaleAspectFill
    
    var settings = cameraSettings()
    
    init(name:String,flash:[AVCaptureDevice.FlashMode],
         focus:[AVCaptureDevice.FocusMode],
         CameraSkin:UIImage?,
         defaultPos:AVCaptureDevice.Position,
         exposure:AVCaptureDevice.ExposureMode,
         focusPoint:CGPoint?,filterName:[String]) {
        self.name = name
        self.flash = flash
        self.focus = focus
        self.CameraSkin = CameraSkin
        self.defaultPos = defaultPos
        self.exposure = exposure
        self.focusPoint = focusPoint
        settings.filter = filterName
    }
    
    init(name:String,flash:[AVCaptureDevice.FlashMode],focus:[AVCaptureDevice.FocusMode],CameraSkin:UIImage?,filterName:[String]) {
        self.name = name
        self.flash = flash
        self.focus = focus
        self.CameraSkin = CameraSkin
        self.defaultPos = .back
        exposure = .autoExpose
        settings.filter = filterName
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
    func getFocusMode()->AVCaptureDevice.FocusMode{
        return focus[selectedFocus]
    }
    mutating func switchFocusMode(){
        selectedFocus = selectedFocus + 1
        if selectedFocus >= focus.count{
            selectedFocus = 0
        }
    }
    
    
    
}

struct cameraSettings:Codable{
    private var imageCompression:Double = 0.8
    var filterEffect:Double = 0.8
    var filter:[String] = []
    private var imageQuality:Int = 2
    
    func getCompression()->Double{
        return imageCompression
    }
    mutating func setImageCompression(_ percent:Double){
        imageCompression = percent
        if imageCompression > 1{
            imageCompression = 1
        }
        if imageCompression < 0{
            imageCompression = 0
        }
    }
    
    mutating func setImageQuality(_ q:Int){
        imageQuality = q
    }
    
    var imagePreset:AVCaptureSession.Preset{
        if imageQuality == 0{
            return .low
        }
        if imageQuality == 1{
            return .medium
        }
        return .high
    }
    
}
