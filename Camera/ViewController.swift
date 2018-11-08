//
//  ViewController.swift
//  Camera
//
//  Created by Seann Moser on 10/31/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController,AVCapturePhotoCaptureDelegate {

    @IBOutlet weak var previewCameraFeed: UIView!

    @IBOutlet weak var previewImage: UIImageView!
    
    var currentCameraSession: AVCaptureSession!
    var outputCaptureImage: AVCapturePhotoOutput!
    var previewVideoLayer: AVCaptureVideoPreviewLayer!
    
    var currentCaptureDevice: AVCaptureDevice!
    
    @IBAction func didTapScreen(_ sender: Any) {
      //  let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
       // currentCaptureDevice.focusMode = .autoFocus
       // currentCaptureDevic
       // let set = AVCapturePhotoSettings(rawPixelFormatType: OSType.min)
       // outputCaptureImage.capturePhoto(with: set, delegate: self)
        
    }
    
    func getCaptureDevice(){
    //    let allVideoInput = AVCaptureDevice.DiscoverySession.de
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // sets up camera Settings
        
        currentCameraSession = AVCaptureSession()
        currentCameraSession.sessionPreset = .hd1920x1080
        selectCamera()
        
        

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
        currentCameraSession.startRunning()
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        outputCaptureImage.capturePhoto(with: settings, delegate: self)
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        let image = UIImage(data: imageData)
        previewImage.contentMode = UIView.ContentMode.scaleAspectFit
        let newImg = Image(image: image!);
        Pictures.shared.addImage(newImg);
        Pictures.shared.savePictures();
       
        previewImage.image = image
        
        Pictures.shared.listallPictures()
        currentCameraSession.startRunning()
    }
    
}

