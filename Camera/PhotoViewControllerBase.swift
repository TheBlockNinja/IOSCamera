//
//  PhotoViewControllerBase.swift
//  Camera
//
//  Created by Seann Moser on 11/13/18.
//  Copyright © 2018 SOU. All rights reserved.
//


import AVFoundation
import UIKit


class BaseCameraViewController:UIViewController{
    var camera = CameraData()
    
    private var previewCameraFeed: UIView!
    
    private var previewImage: UIImageView!
    
    private var photoDelegate:PhotoOutputDelegate = PhotoOutputDelegate()
    
    var currentCamera = cameraSettings.cameras[0]
    
    func addConnections(previewCameraFeed: UIView,previewImage: UIImageView,cameraSettings:cameraSettings){
        self.previewCameraFeed = previewCameraFeed
        self.previewImage = previewImage
        currentCamera = cameraSettings
        setup()
    }
    private func setup(){
        previewImage.contentMode = .scaleAspectFit
        previewCameraFeed.layer.addSublayer(camera.previewVideoLayer)
        camera.setPreviewFrame(previewCameraFeed.frame)
        DispatchQueue.global().async {
            Pictures.shared.loadPictures()
        }
        addNotifications()
        camera.setAutoFocus(currentCamera.autoFocus)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        camera.session.stopRunning()
    }
    override func viewWillAppear(_ animated: Bool) {
        camera.session.startRunning()
    }
    
    
    private func addNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(showPreview), name: PhotoOutputDelegate.PreviewNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(takePicture), name: CameraData.takePictureNotification, object: nil)
    }
    
    @objc func showPreview(){
        if let previewImage = previewImage{
            previewImage.image = photoDelegate.CurrentPreviewImage
            UIView.animate(withDuration: 1.0, animations: {
                self.previewImage.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }) { (true) in
                previewImage.transform = CGAffineTransform.identity
                previewImage.image = nil;
            
            }
        }
    }
    @objc func takePicture(){
        if let output = camera.photoOutput.connection(with: .video){
            output.videoOrientation = .landscapeLeft
            print("updated")
        }else{
            print("failed")
        }
        camera.photoOutput.capturePhoto(with: camera.getPhotoSettings(flash: currentCamera.hasFlash), delegate: photoDelegate)
    }
    
    
    
}
