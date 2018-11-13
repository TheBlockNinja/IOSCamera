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

class PhotoOutputDelegate:NSObject,AVCapturePhotoCaptureDelegate{
    static let PreviewNotification = Notification.Name(rawValue: "PreviewNotification")
    static let SavedImageNotification = Notification.Name(rawValue: "SavedImageNotification")
    var CurrentPreviewImage:UIImage?
    private let rotatePreviewImage:CGFloat = ((180.0 * .pi) / 180)
    
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imagePreview = photo.previewPixelBuffer
        
        if let imgP = imagePreview{
            let tempImage = CIImage(cvPixelBuffer:imgP)
            let newImage = tempImage.transformed(by: (CGAffineTransform(rotationAngle: rotatePreviewImage)))
            
            let ciContext = CIContext()
            let cgImage = ciContext.createCGImage(newImage, from: newImage.extent)
            CurrentPreviewImage = UIImage(cgImage: cgImage!)
            NotificationCenter.default.post(name: PhotoOutputDelegate.PreviewNotification, object: nil)
        }
        
        DispatchQueue.global().async {
            // Download file or perform expensive task
            self.saveImage(photo: photo,output)
        }
    }

    func saveImage(photo:AVCapturePhoto,_ output: AVCapturePhotoOutput){
        
        let imageData = photo.fileDataRepresentation()
        if let imageData = imageData{
           let image =  UIImage(data: imageData)!
        
            let compressed = image.jpegData(compressionQuality: 0.5)
            let newImg = Image(image: UIImage(data: compressed!)!);

            Pictures.shared.addImage(newImg);
            Pictures.shared.savePictures();
           
        }
    }
}
