//
//  PhotoViewControllerBase.swift
//  Camera
//
//  Created by Seann Moser on 11/13/18.
//  Copyright © 2018 SOU. All rights reserved.
//


import AVFoundation
import UIKit

//all camera view controllers will inherit from this class
//contains basic functions in which they will all use
class BaseCameraViewController:UIViewController{
    private var previewCameraFeed: UIView!
    
    private var previewImage: UIImageView!
    
    private var cameraSkin: UIImageView!
    
    private var currentCamera:CameraSettings! = CameraSettings.PointAndShoot
    
    var isCameraEnlarged:Bool{
        if cameraSkin.transform.isIdentity
        {
            return false
        }
        return true
    }

    
    override func viewWillAppear(_ animated: Bool) {
        setFocused()
    }
    override func viewWillDisappear(_ animated: Bool) {
        previewCameraFeed = nil
        previewImage = nil
        cameraSkin = nil
        currentCamera = nil
        removeNotifications()
        
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        UICamera.shared.updateOrientation()
    }
    func setCameraSkin(image:UIImageView){
        cameraSkin = image
    }
    func addConnections(previewCameraFeed: UIView,previewImage: UIImageView,cameraSettings:CameraSettings){
        self.previewCameraFeed = previewCameraFeed
        self.previewImage = previewImage
        currentCamera = cameraSettings
        setup()
        setFocused()
    }

    func setFocused(){
        UICamera.shared.setupCamera(cameraFeed: previewCameraFeed, photoOutput: previewImage)
        UICamera.shared.setCameraSettings(currentCamera)
        UICamera.shared.focusCameraOnPoint()
        UICamera.shared.updateOrientation()
    }
    
    func enlargeCamera(){
        if let cameraSkin = cameraSkin{
            if isCameraEnlarged {
                cameraSkin.zoomOutFadeIn()
                //previewImage.frame = defaultImagePreviewLocation
            }else{
                cameraSkin.zoomInFade()
               // previewImage.frame = previewCameraFeed.frame
            }
        }
        
        
    }
    @objc func takePicture(){
        UICamera.shared.takePicture()
    }
    
    @objc func showPreview(){
        if let previewImage = previewImage{
            previewImage.image = UICamera.shared.photoDelegate.CurrentPreviewImage
            
            previewImage.image = UICamera.shared.photoDelegate.CurrentPreviewImage
            let _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(hidePicture), userInfo: nil, repeats: false)
            
        }
    }


    @objc private func hidePicture(){
        previewImage.image = nil
    }
    private func setup(){
        previewImage.contentMode = currentCamera.contentMode
        addNotifications()
    }
    
    private func addNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(showPreview), name: PhotoOutputDelegate.PreviewNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(takePicture), name: CameraData.takePictureNotification, object: nil)
    }
    private func removeNotifications(){
        NotificationCenter.default.removeObserver(self, name: PhotoOutputDelegate.PreviewNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: CameraData.takePictureNotification, object: nil)
    }

    
    
    
}
