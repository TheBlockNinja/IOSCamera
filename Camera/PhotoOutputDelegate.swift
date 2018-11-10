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
    private let rotateImage:CGFloat = ((180.0 * .pi) / 180) / -2
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imagePreview = photo.previewPixelBuffer
        
        if let imgP = imagePreview{
            let tempImage = CIImage(cvPixelBuffer:imgP)
            let newImage = tempImage.transformed(by: (CGAffineTransform(rotationAngle: rotateImage)))
            
            let ciContext = CIContext()
            let cgImage = ciContext.createCGImage(newImage, from: newImage.extent)
            CurrentPreviewImage = UIImage(cgImage: cgImage!)
          
            NotificationCenter.default.post(name: PhotoOutputDelegate.PreviewNotification, object: nil)
        }
        
        DispatchQueue.global(qos: .default).async {
            // Download file or perform expensive task
            PhotoOutputDelegate.saveImage(photo: photo)
            DispatchQueue.main.async {
                // Update the UI
            }
        }
    }

    static func saveImage(photo:AVCapturePhoto){
        let imageData = photo.fileDataRepresentation()
        if let imageData = imageData{
            let newImg = Image(image: UIImage(data: imageData)!);
            Pictures.shared.addImage(newImg);
            Pictures.shared.savePictures();
            NotificationCenter.default.post(name: PhotoOutputDelegate.SavedImageNotification, object: nil)
        }
    }
}
