//
//  PhotoViewControllerBase.swift
//  Camera
//
//  Created by Seann Moser on 11/13/18.
//  Copyright © 2018 SOU. All rights reserved.
//


import AVFoundation
import UIKit
import MediaPlayer
//all camera view controllers will inherit from this class
//contains basic functions in which they will all use
class BaseCameraViewController:UIViewController{
    static let VolumeNotification = NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification")
    
    private var previewCameraFeed: UIView!
    
    private var previewImage: UIImageView!
    
    private var cameraSkin: UIImageView!
    
    private var currentCamera:Cameras! = Cameras.PointAndShoot
    
    private var volumeView:MPVolumeView?
    private var audioSession:AVAudioPlayer!
    var isCameraEnlarged:Bool{
        if cameraSkin.transform.isIdentity
        {
            return false
        }
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        audioSession = AVAudioPlayer()
        try? AVAudioSession.sharedInstance().setActive(true)
        
        volumeView = MPVolumeView(frame:view.frame)
        volumeView?.alpha = 0.01
        volumeView?.isHidden = false
        self.view.addSubview(volumeView!)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setFocused()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        previewImage.image = nil
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
    func addConnections(previewCameraFeed: UIView,previewImage: UIImageView,cameraSettings:Cameras){
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
        UICamera.shared.changeFocualDistance(by: 0)
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
        if let previewImage = previewImage{
            previewImage.image = nil
        }
    }
    private func setup(){
        previewImage.contentMode = currentCamera.contentMode
        addNotifications()
    }
    
    private func addNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(showPreview), name: PhotoOutputDelegate.PreviewNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(takePicture), name: CameraData.takePictureNotification, object: nil)
        addVolumeControl()
    }
    private func removeNotifications(){
        NotificationCenter.default.removeObserver(self, name: PhotoOutputDelegate.PreviewNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: CameraData.takePictureNotification, object: nil)
         NotificationCenter.default.removeObserver(self, name: BaseCameraViewController.VolumeNotification, object: nil)
        volumeView?.removeFromSuperview()
    
    }
    private func addVolumeControl(){
     //   AVAudioSession.sharedInstance().

        //volumeView?.showsVolumeSlider = false
      //  view.sendSubviewToBack(volumeView!)
        NotificationCenter.default.addObserver(self, selector: #selector(takePicture), name: BaseCameraViewController.VolumeNotification, object: nil)
        //NotificationCenter.default.post(name: BaseCameraViewController.VolumeNotification, object: nil)
        
    }

    
    
    
}
