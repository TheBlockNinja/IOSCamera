//
//  CameraSettings.swift
//  Camera
//
//  Created by Seann Moser on 11/27/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import Foundation
import AVFoundation

struct cameraSettings:Codable{
    private var imageCompression:Double = 0.8
    var filterEffect:Double = 0.8
    var filter:[String] = []
    private var imageQuality:Int = 2
    
    func getCompression()->Double{
        return imageCompression
    }
    mutating func setImageCompression(_ percent:Double){
        imageCompression = percent
        if imageCompression > 1{
            imageCompression = 1
        }
        if imageCompression < 0{
            imageCompression = 0
        }
    }
    
    mutating func setImageQuality(_ q:Int){
        imageQuality = q
    }
    
    var imagePreset:AVCaptureSession.Preset{
        if imageQuality == 0{
            return .low
        }
        if imageQuality == 1{
            return .medium
        }
        return .high
    }
    
}
