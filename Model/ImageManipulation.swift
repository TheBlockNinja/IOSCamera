//
//  ImageManipulation.swift
//  Camera
//
//  Created by Seann Moser on 11/5/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import Foundation
import UIKit

struct ImageManipulation{
    static let SEPIA = "CISepiaTone"
    static let GRAYSCALE = "CIPhotoEffectTonal"
    static let NON = ""
    static let NOISE = ""
    
    static func applyFilterWith(name:[String],image:UIImage,percentage:Double)->UIImage{
        var outputImage = image
        for n in name{
            let ciimage = CIImage(image: outputImage)
            if let ciimage = ciimage,let filter = CIFilter(name:n){
                let newImage = applyFilter(filter, image: ciimage,effect: percentage)
                outputImage = UIImage.init(cgImage: newImage!, scale: 1.0, orientation: image.imageOrientation)
            }
        }
        return outputImage
    }
    static func applyFilterWith(name:[String],image:CIImage,percentage:Double)->UIImage{
        var outputImage = UIImage()
        for n in name{
            if let filter = CIFilter(name:n){
                let newImage = applyFilter(filter, image: image,effect: percentage)
                if let newImage = newImage{
                    outputImage = UIImage(cgImage: newImage)
                }

            }else{
                outputImage = UIImage(ciImage: image)
            }
        }
        
        return outputImage
    }
    static let ctx = CIContext()
    private static func applyFilter(_ filter:CIFilter,image:CIImage,effect:Double)->CGImage?{
        //from https://developer.apple.com/documentation/coreimage/processing_an_image_using_built-in_filters
        //altered
        filter.setValue(image, forKey: kCIInputImageKey)
        if filter.name == SEPIA{
            filter.setValue(effect, forKey: kCIInputIntensityKey)
        }
        
        //https://stackoverflow.com/questions/27085225/getting-ciimage-from-uiimage-swift
        //altered
        let cgImage = ctx.createCGImage((filter.outputImage)!, from:filter.outputImage!.extent)
        
        return cgImage
    }
    
    
}
/*
struct drawOnImage{
    //https://stackoverflow.com/questions/39950125/how-do-i-draw-on-an-image-in-swift
    
    private var img:Image
    private var lastPoint:CGPoint?
    private var lineWidth:Double = 5
    private var lineColor:UIColor = UIColor.black;
    
    init(image:Image){
        img = image
    }
    
    mutating func drawLine(p1:CGPoint,p2:CGPoint){
        lastPoint = p2
        UIGraphicsBeginImageContext(img.data.size)
        img.data.draw(in:  CGRect(x: 0, y: 0, width: img.data.size.width, height: img.data.size.height))
        let context = UIGraphicsGetCurrentContext()!
        
        context.setLineWidth(CGFloat(lineWidth))
        context.setStrokeColor(lineColor.cgColor)
        context.move(to: p1)
        context.addLine(to: p2)
        context.strokePath()
        
        let myImage = UIGraphicsGetImageFromCurrentImageContext()
        if let myImage = myImage{
            img.data = myImage
        }
        UIGraphicsEndImageContext()
        
    }
    mutating func drawLineFromLastPoint(to point:CGPoint){
        if let lastPoint = lastPoint{
            drawLine(p1: lastPoint, p2: point)
        }
    }
    mutating func setColor(_ color:UIColor){
        lineColor = color
    }
    mutating func setLineWidth(_ width:Double){
        lineWidth = width
    }
    
    
}
*/
