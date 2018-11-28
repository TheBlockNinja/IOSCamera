//
//  UICamera.swift
//  Camera
//
//  Created by Seann Moser on 11/15/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class UICamera{
    //creates a singlton model of the UICamera
    static let shared = UICamera()
    
    //Photo Delegate processes Photos taken by the camera
    var photoDelegate = PhotoOutputDelegate()
    
    //Stores all of the user pictures in side of arrays
    var pictures = Pictures()
    
    //Has all of the camera data
    private var camera = CameraData()
    
    //contains the current camera settings
    private var cameraSettings = Cameras.PointAndShoot
    
    //the current focalDistance of the camera
    private var focalDistance:CGFloat = 0.0
    
    
    private var CurrentCamera = ""
    
    
    init() {
        //adds a new thread that loads the pictures
        //intesive process
        Threads.PictureThread.async {
            self.pictures.loadPictures()
        }
        camera.applyLiveFilterToCameraFeed(delegate:photoDelegate)
    }
    
    //updates orientationg
    func updateOrientation(){
        camera.updateOrientation()
    }
    //sets the camera settings
    func setCameraSettings(_ cameraSettings:Cameras){
        self.cameraSettings = cameraSettings
        camera.setCameraData(self.cameraSettings)
        applyCameraSettings()
        CurrentCamera = cameraSettings.name
        camera.setPosition(self.cameraSettings.defaultPos!)
    }
    
    func getCurrentCamera()->String{
        return CurrentCamera
    }
    //gets the current focal distance as a string
    func getFocalDistance()->String{
        return String(format: "%0.f%", focalDistance*100)
    }
    func getFocalDistanceF()->CGFloat{
        return focalDistance
    }
    func switchFocusMode(){
        cameraSettings.switchFocusMode()
        camera.setFocusMode(cameraSettings.getFocusMode())
    }
    func getFocusMode()->String{
        switch cameraSettings.getFocusMode() {
        case .locked :return "Manual"
        case .autoFocus: return "Tap To Focus"
        case .continuousAutoFocus: return "Cont.Auto Focus"
            
        }
    }
    //switches between available flash settings
    func switchFlash(){
        camera.setFlashMode(cameraSettings.switchFlash())
    }
    
    //converts the current flash settings into a String
    func getCurrentFlash()->String{
        switch cameraSettings.flash[cameraSettings.selectedFlash] {
        case .auto:return "AUTO"
        case .off: return "OFF"
        case .on: return "ON"
            
        }
    }
    
    //focuses Camera on point where user presses,or where the camera sets the focus
    //focus point is scaled between 0.0 and 1.0
    func focusCameraOnPoint(_ point:CGPoint?=nil,distance:CGFloat=0){
        if let focuspoint=cameraSettings.focusPoint{
            camera.focusCamera(point: focuspoint)
        }else if let focuspoint = point{
            let calculatedPoint = CGPoint(x: focuspoint.x/UIScreen.main.bounds.width, y: focuspoint.y/UIScreen.main.bounds.height)
            camera.focusCamera(point: calculatedPoint)
        }else if cameraSettings.getFocusMode() == .locked{
            camera.focusCamera(distance:distance)
        }
        
    }
    
    //sets up current camera from one of the UIViews
    func setupCamera(cameraFeed:UIView,photoOutput:UIImageView){
        if var subLayers = cameraFeed.layer.sublayers{
            subLayers.removeAll()
        }
        cameraFeed.layer.addSublayer(camera.previewVideoLayer)
        focusCameraOnPoint()
        camera.setPreviewFrame(cameraFeed.frame)
        
    }
    
    //takes a picture
    //make sures the picture is in landscape mode
    //gets camera settings
    func takePicture(){
        if let output = camera.photoOutput.connection(with: .video){
            output.videoOrientation = UIView.getCurrentOrientation()
        }
       camera.photoOutput.capturePhoto(with: camera.getPhotoSettings(), delegate: UICamera.shared.photoDelegate)
    }
    
    //flips the camera between the front and back facing camera
    func flipCamera(){
        camera.flipPostion()
    }
    
    func getCompression()->Double{
        return cameraSettings.settings.getCompression()
    }
    func getFilterInfo()->(name:[String],effect:Double){
        return (cameraSettings.settings.filter,cameraSettings.settings.filterEffect)
    }
    //changes the current focal distance
    func changeFocualDistance(by num:CGFloat=0.005)
    {
        focalDistance += num
        if focalDistance < 0{
            focalDistance = 0
        }else if focalDistance > 1{
            focalDistance = 1
        }
        focusCameraOnPoint(distance: focalDistance)
    }
    func setFocalDistance(_ num:CGFloat){
        focalDistance = num
        if focalDistance < 0{
            focalDistance = 0
        }else if focalDistance > 1{
            focalDistance = 1
        }
        focusCameraOnPoint(distance: focalDistance)
    }
    
    //applies camera settings to the camera
    private func applyCameraSettings(){
        focusCameraOnPoint(cameraSettings.focusPoint, distance: focalDistance)
    }
}
