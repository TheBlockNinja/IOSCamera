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
    
    static var FilterVideoFeed:UIImage! = UIImage()
    //current images nil if still being processed
    var CurrentPreviewImage:UIImage?
    
    //flip image so it previews properly
    private let rotatePreviewImage:CGFloat = ((180.0 * .pi) / 180)
    


    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if UICamera.shared.getCurrentCamera() != Cameras.non.name {
            let buffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            if let buffer = buffer{
                let image = CIImage(cvImageBuffer: buffer)
                
                let outputImage = ImageManipulation.applyFilterWith(name: UICamera.shared.getFilterInfo().name, image: image, percentage: UICamera.shared.getFilterInfo().effect)
                
                PhotoOutputDelegate.FilterVideoFeed = outputImage.imageFlippedForRightToLeftLayoutDirection()
                
            }
            
        }
        
        
        
        
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        let imagePreview = photo.previewPixelBuffer
        if UICamera.shared.getCurrentCamera() == Cameras.OldSchool.name || UICamera.shared.getCurrentCamera() == Cameras.PointAndShoot.name {
            CurrentPreviewImage = PhotoOutputDelegate.FilterVideoFeed
            NotificationCenter.default.post(name: PhotoOutputDelegate.PreviewNotification, object: nil)
        }else{
            createImagePreview(imagePreview)
        }
        Threads.PictureThread.async {
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

    func saveImage(photo:AVCapturePhoto,_ output: AVCapturePhotoOutput){
        
        let imageData = photo.fileDataRepresentation()
        if let imageData = imageData{
            var image =  UIImage(data: imageData)!
            image = ImageManipulation.applyFilterWith(name: UICamera.shared.getFilterInfo().name,image: image, percentage: UICamera.shared.getFilterInfo().effect)//change percentage
            
            let compressed = image.jpegData(compressionQuality: CGFloat(UICamera.shared.getCompression()))
            let newImg = Image(image: UIImage(data: compressed!)!)
            UICamera.shared.pictures.addImage(newImg)
            UICamera.shared.pictures.savePictures()
           Thread.current.cancel()
        }
    }
}
