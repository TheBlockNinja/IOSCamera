//
//  UserCameraData.swift
//  Camera
//
//  Created by Seann Moser on 11/1/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


struct CameraData{
    
    
    static let takePictureNotification = Notification.Name(rawValue: "TakePictureNotifcation")
    
    let session = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    let previewVideoLayer = AVCaptureVideoPreviewLayer()
    //add another preview layer for a scaled version
    
    private var position = AVCaptureDevice.Position.back
    private var quailty = AVCaptureSession.Preset.high
    private var currentCamera:AVCaptureDevice?
    private var autoFocus:Bool = false
    
    init() {
        configureSession()
        setupPreview()
    }
    mutating func setAutoFocus(_ focus:Bool){
        autoFocus = focus
        configureSession()
    }
    mutating func flipPostion(){
        if position == .back{
            position = .front
        }else{
            position = .back
        }
        configureSession()
    }
    mutating func setPosition(_ pos:AVCaptureDevice.Position){
        position = pos
        configureSession()
    }
    mutating func setQuailty(_ quality:AVCaptureSession.Preset){
        self.quailty = quality
        configureSession()
    }
    
    func setPreviewFrame(_ rect:CGRect){
        previewVideoLayer.frame = rect
    }
    func getPhotoSettings(flash:Bool)->AVCapturePhotoSettings{
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        if flash{
            settings.flashMode = .auto
        }else{
            settings.flashMode = .off
        }
        if settings.availablePreviewPhotoPixelFormatTypes.count > 0{
            settings.previewPhotoFormat = [
                kCVPixelBufferPixelFormatTypeKey : settings.availablePreviewPhotoPixelFormatTypes.first!,
                kCVPixelBufferWidthKey : 1024,
                kCVPixelBufferHeightKey : 1024,
                ] as [String: Any]
        }
        return settings
    }
    func focusCamera(on point:CGPoint){
        
       try? currentCamera?.lockForConfiguration()
        //check focus mode
        if (currentCamera?.isFocusPointOfInterestSupported)! && !autoFocus{
            currentCamera?.focusMode = .autoFocus
            currentCamera?.focusPointOfInterest = point
        }
        if (currentCamera?.isExposurePointOfInterestSupported)! && !autoFocus{
            currentCamera?.exposureMode = .autoExpose
            currentCamera?.exposurePointOfInterest = point
        }
        currentCamera?.unlockForConfiguration()
        
        
    }
    private mutating func configureSession(){
        session.stopRunning()
        
        session.beginConfiguration()
    
        session.sessionPreset = quailty
        let camera = getCamera()
        currentCamera = camera
        
        for i in session.inputs{
            session.removeInput(i)
        }
        
        addInput(camera: camera)
        if session.canAddOutput(photoOutput){
            setupOutput()
            session.addOutput(photoOutput)
        }
        previewVideoLayer.session = session
        session.commitConfiguration()
        
        session.startRunning()
    }
    private func addInput(camera:AVCaptureDevice?){
        if let camera = camera {
            if autoFocus{
            try? camera.lockForConfiguration()
                camera.focusMode =  .continuousAutoFocus
                camera.exposureMode = .continuousAutoExposure
                camera.unlockForConfiguration()
            }
            applyCameraSettings(camera: camera)
            let inputCamera = try? AVCaptureDeviceInput(device: camera)
            if let inputCamera = inputCamera{
                if session.canAddInput(inputCamera){
                    session.addInput(inputCamera)
                    
                }
            }
        }
    }
    private func setupOutput(){
        photoOutput.isLivePhotoCaptureEnabled = false;
        photoOutput.isHighResolutionCaptureEnabled = true;
        

    }
    private func applyCameraSettings(camera:AVCaptureDevice){
        
        try? camera.lockForConfiguration()
        if camera.isLowLightBoostSupported{
            camera.automaticallyEnablesLowLightBoostWhenAvailable = true
        }
        if camera.isVideoHDREnabled{
            camera.automaticallyAdjustsVideoHDREnabled = true
        }
        if (camera.isSmoothAutoFocusSupported){
            camera.isSmoothAutoFocusEnabled = true
        }
        camera.unlockForConfiguration()
        
    }
    private func getCamera()->AVCaptureDevice?{
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes:  [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera,.builtInTelephotoCamera], mediaType: .video, position: position)
        for d in discoverySession.devices {
 
            return d
        }
        
        
        return nil
    }
    private func setupPreview(){
        previewVideoLayer.videoGravity = .resizeAspect
        previewVideoLayer.connection?.videoOrientation = .landscapeLeft
    }

}


