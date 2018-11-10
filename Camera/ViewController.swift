//
//  ViewController.swift
//  Camera
//
//  Created by Seann Moser on 10/31/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {

    @IBOutlet weak var previewCameraFeed: UIView!

    @IBOutlet weak var previewImage: UIImageView!
    
    var currentCameraSession: AVCaptureSession!
    var outputCaptureImage: AVCapturePhotoOutput!
    var previewVideoLayer: AVCaptureVideoPreviewLayer!
    
    var currentCaptureDevice: AVCaptureDevice!
    var photoDelegate:PhotoOutputDelegate = PhotoOutputDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // sets up camera Settings
        NotificationCenter.default.addObserver(self, selector: #selector(showPreview), name: PhotoOutputDelegate.PreviewNotification, object: nil)
        currentCameraSession = AVCaptureSession()
        currentCameraSession.sessionPreset = .hd1920x1080
        previewImage.contentMode = .scaleAspectFit
        
        selectCamera()
    }
    
    @IBAction func didTapScreen(_ sender: Any) {
        print("TAKE")
        
        outputCaptureImage.capturePhoto(with:getPhotoSettings(), delegate: photoDelegate)
    }
    
    func getCaptureDevice(){
    //    let allVideoInput = AVCaptureDevice.DiscoverySession.de
        
        
    }
    func getPhotoSettings()->AVCapturePhotoSettings{
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        if settings.availablePreviewPhotoPixelFormatTypes.count > 0{
            settings.previewPhotoFormat = [
                kCVPixelBufferPixelFormatTypeKey : settings.availablePreviewPhotoPixelFormatTypes.first!,
                kCVPixelBufferWidthKey : 1024,
                kCVPixelBufferHeightKey : 1024,
                ] as [String: Any]
            print("can preview");
        }
        return settings
    }

    func selectCamera(){
        //https://stackoverflow.com/questions/38122040/set-grayscale-on-output-of-avcapturedevice-in-ios
      
        currentCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)        
        do {
            let input = try AVCaptureDeviceInput(device: currentCaptureDevice)
            setupSession(with: input)
        }catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    private func setupSession(with input:AVCaptureDeviceInput){
        
        outputCaptureImage = AVCapturePhotoOutput()
        if  canAlterSession(with: input){
            currentCameraSession.addInput(input)
            currentCameraSession.addOutput(outputCaptureImage)
            setupLivePreview()
        }
    }
    private func canAlterSession(with input:AVCaptureDeviceInput)->Bool{
        return currentCameraSession.canAddInput(input) && currentCameraSession.canAddOutput(outputCaptureImage)
    }
    
    func setupLivePreview() {
        
        previewVideoLayer = AVCaptureVideoPreviewLayer(session: currentCameraSession)
        previewVideoLayer.frame = previewCameraFeed.frame
        previewVideoLayer.videoGravity = .resizeAspect
        previewVideoLayer.connection?.videoOrientation = .portrait
        
        previewCameraFeed.layer.addSublayer(previewVideoLayer)
        self.currentCameraSession.startRunning()
    }

    
    @IBAction func didTakePhoto(_ sender: Any) {
       
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        outputCaptureImage.capturePhoto(with: settings, delegate: photoDelegate)
        
    }
    
    @objc func showPreview(){
        previewImage.image = photoDelegate.CurrentPreviewImage

        UIView.animate(withDuration: 1.0, animations: {
            self.previewImage.frame = CGRect(x: 0, y: self.previewCameraFeed.frame.height, width: self.previewImage.frame.width, height: self.previewImage.frame.height)
        }) { (true) in
            self.previewImage.image = nil;
            self.previewImage.frame = self.view.frame
        }
    }

    
}

