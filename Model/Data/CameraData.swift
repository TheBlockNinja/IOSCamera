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
    
    
    
    private var position = AVCaptureDevice.Position.back
    private var quailty = AVCaptureSession.Preset.high
    private var currentCamera:AVCaptureDevice?
    private var autoFocus = AVCaptureDevice.FocusMode.autoFocus
    private var flashMode = AVCaptureDevice.FlashMode.off
    private var exposureMode = AVCaptureDevice.ExposureMode.autoExpose

    init() {
        configureSession()
        setupPreview()
    }
    
    func setPreviewFrame(_ rect:CGRect){
        previewVideoLayer.frame = rect
    }
    func updateOrientation()
    {
         previewVideoLayer.connection?.videoOrientation = UIView.getCurrentOrientation()
        videoOutput.connection(with: .video)?.videoOrientation = UIView.getCurrentOrientation()
    }
    mutating func setCameraData(_ camera:Cameras){
        setFocusMode(camera.getFocusMode())
        setExposureMode(camera.exposure)
        setFlashMode(camera.flash.first ?? .off)
        quailty = camera.settings.imagePreset
    }
    func getPhotoSettings()->AVCapturePhotoSettings{
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        settings.flashMode = flashMode
        if settings.availablePreviewPhotoPixelFormatTypes.count > 0{
            settings.previewPhotoFormat = [
                kCVPixelBufferPixelFormatTypeKey : settings.availablePreviewPhotoPixelFormatTypes.first!,
                kCVPixelBufferWidthKey : 1024,
                kCVPixelBufferHeightKey : 1024,
                ] as [String: Any]
        }
        return settings
    }
    
    func focusCamera(point:CGPoint){
        focusCameraPoint(on: point)
    }
    
    func focusCamera(distance:CGFloat){
        setCameraFocalLength(distance)
    }
    
    mutating func setFocusMode(_ focus:AVCaptureDevice.FocusMode){
        autoFocus = focus
    }
    mutating func setFlashMode(_ flash:AVCaptureDevice.FlashMode){
        flashMode = flash
    }
    mutating func setExposureMode(_ exposure:AVCaptureDevice.ExposureMode){
        exposureMode = exposure
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
    private func focusCameraPoint(on point:CGPoint){
        
        try? currentCamera?.lockForConfiguration()
        if (currentCamera?.isFocusPointOfInterestSupported)! && (currentCamera?.isFocusModeSupported(autoFocus))!{
            currentCamera?.focusMode = autoFocus
            currentCamera?.focusPointOfInterest = point
        }
        if (currentCamera?.isExposurePointOfInterestSupported)! && (currentCamera?.isExposureModeSupported(exposureMode))!{
            currentCamera?.exposureMode = exposureMode
            currentCamera?.exposurePointOfInterest = point
        }
        currentCamera?.unlockForConfiguration()
    }
    private func setCameraFocalLength(_ distance:CGFloat){
        if autoFocus == .locked && distance <= 1{
            try? currentCamera?.lockForConfiguration()
            if (currentCamera?.isLockingFocusWithCustomLensPositionSupported)! && (currentCamera?.isFocusModeSupported(autoFocus))!{
                
                currentCamera?.focusMode = autoFocus
                currentCamera?.setFocusModeLocked(lensPosition: Float(distance), completionHandler: { (true) in

                })
            }
            
            if (currentCamera?.isExposurePointOfInterestSupported)! && (currentCamera?.isExposureModeSupported(exposureMode))!{
                currentCamera?.exposureMode = exposureMode
            }
            currentCamera?.unlockForConfiguration()
        }
        
    }
    private func addInput(camera:AVCaptureDevice?){
        if let camera = camera {
            if camera.isFocusModeSupported(autoFocus) && camera.isExposureModeSupported(exposureMode){
            try? camera.lockForConfiguration()
                camera.focusMode =  autoFocus
                camera.exposureMode = exposureMode
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
        previewVideoLayer.videoGravity = .resizeAspectFill
        previewVideoLayer.connection?.videoOrientation = UIView.getCurrentOrientation()

    }

    
    
    
    //extra stuff
    let videoOutput = AVCaptureVideoDataOutput()
    let videoF = videoFeed()
    func applyLiveFilterToCameraFeed(){
        if !session.outputs.contains(videoOutput){
            session.stopRunning()
            videoOutput.connection(with: .video)?.videoOrientation = UIView.getCurrentOrientation()
            // videoOutput.connection?.videoOrientation = UIView.getCurrentOrientation()
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.setSampleBufferDelegate(videoF, queue: DispatchQueue.global())
        
            session.addOutput(videoOutput)
        
        session.startRunning()
        }
    }

    
}
class videoFeed:NSObject, AVCaptureVideoDataOutputSampleBufferDelegate{
    static var Feed:UIImage! = UIImage()

    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
     //   print("here")
        
        if UICamera.shared.getCurrentCamera() == Cameras.OldSchool.name{
            let buffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            if let buffer = buffer{
                let image = CIImage(cvImageBuffer: buffer)
                
                let outputImage = ImageManipulation.applyFilterWith(name: UICamera.shared.getFilterInfo().name, image: image, percentage: UICamera.shared.getFilterInfo().effect)

                    //videoFeed.Feed = nil
                
                    videoFeed.Feed = outputImage.imageFlippedForRightToLeftLayoutDirection()
                
            }
            
        }
            
        
        
        
        
    }
}


