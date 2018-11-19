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
    
    private var smallCameraFeed: UIView!
    
    private var previewImage: UIImageView!
    
    private var currentCamera = CameraSettings.PointAndShoot
    
    
    override func viewWillAppear(_ animated: Bool) {
        setFocused()
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
    }
    
    @objc func takePicture(){
        UICamera.shared.takePicture()
    }
    
    @objc private func showPreview(){
        if let previewImage = previewImage{
            previewImage.image = UICamera.shared.photoDelegate.CurrentPreviewImage
            let scaletransform = CGAffineTransform(scaleX: 0.05, y: 0.05)
            UIView.animate(withDuration: 1.0, animations: {
                self.previewImage.transform = scaletransform
            }) { (true) in
                previewImage.transform = CGAffineTransform.identity
                previewImage.image = nil;
                
            }
        }
    }

    private func setup(){
        previewImage.contentMode = currentCamera.contentMode
        addNotifications()
    }
    
    private func addNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(showPreview), name: PhotoOutputDelegate.PreviewNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(takePicture), name: CameraData.takePictureNotification, object: nil)
    }

    
    
    
}
