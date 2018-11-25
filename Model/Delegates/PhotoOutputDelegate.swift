//
//  PhotoOutputDelegate.swift
//  Camera
//
//  Created by Seann Moser on 11/9/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PhotoOutputDelegate:NSObject,AVCapturePhotoCaptureDelegate,AVCaptureVideoDataOutputSampleBufferDelegate{
    //notifications
    static let PreviewNotification = Notification.Name(rawValue: "PreviewNotification")
    static let SavedImageNotification = Notification.Name(rawValue: "SavedImageNotification")
    //current images nil if still being processed
    var CurrentPreviewImage:UIImage?
    
    //flip image so it previews properly
    private let rotatePreviewImage:CGFloat = ((180.0 * .pi) / 180)
    
    
    private var currentCameraName:String = ""


    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        let imagePreview = photo.previewPixelBuffer
        createImagePreview(imagePreview)
        
        DispatchQueue.global().async {
            self.saveImage(photo: photo,output)
        }
    }
    
    
    
    private func createImagePreview(_ imagePreview: CVPixelBuffer?) {
        if let imgP = imagePreview{
            let tempImage = CIImage(cvPixelBuffer:imgP)
            if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight{
                let newImage = tempImage.transformed(by: (CGAffineTransform(rotationAngle: rotatePreviewImage)))
                let ciContext = CIContext()
                let cgImage = ciContext.createCGImage(newImage, from: newImage.extent)
                CurrentPreviewImage = UIImage(cgImage: cgImage!)
            }else{
               CurrentPreviewImage = UIImage(ciImage: tempImage)
            }
            NotificationCenter.default.post(name: PhotoOutputDelegate.PreviewNotification, object: nil)
        }
    }
    func setCurrentCameraName(_ str:String){
        currentCameraName = str
    }
    func saveImage(photo:AVCapturePhoto,_ output: AVCapturePhotoOutput){
        
        let imageData = photo.fileDataRepresentation()
        if let imageData = imageData{
           let image =  UIImage(data: imageData)!
        
            let compressed = image.jpegData(compressionQuality: 0.5)
            let newImg = Image(image: UIImage(data: compressed!)!)
            newImg.setCameraType(currentCameraName)
            UICamera.shared.pictures.addImage(newImg)
            UICamera.shared.pictures.savePictures()
           
        }
    }
}
