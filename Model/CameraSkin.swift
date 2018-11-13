//
//  CameraSkin.swift
//  Camera
//
//  Created by Seann Moser on 11/8/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import Foundation
import UIKit

struct cameraSettings{
    static let cameras:[cameraSettings] = [cameraSettings(name:"DSLR",hasFlash: true, autoFocus: true, CameraSkin: nil)]
    
    
    var name:String
    var hasFlash:Bool
    var autoFocus:Bool
    var CameraSkin:UIImage? = nil
    //other filters
    
}

struct CameraSkin{
    //create a static array of camera skins
    
   // static let Cameras = []
    
    //holds the camera img
    var CameraSkin:UIImage?
    //changes the scale of the video preview to fit in the image view
    var videoPreviewRect:CGRect?
    //takes a picture
    var takePictureBTN:UIButton?
    //changes flash settings
    var flashBtn:UIButton?
    //changes image quality settings
    var ImageQualityBtn:UIButton?
    
    
    //func to get and set Camera skin,video preview
    
    
    

    
    
}
