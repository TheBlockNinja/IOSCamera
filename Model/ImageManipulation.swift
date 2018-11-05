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
    
    func pixelateImage(_ image:UIImage,amount:Double){
        
        
    }
    func grayscale(_ image:UIImage){
        
    }
    func lineart(_ image:UIImage){
        
        
    }

    
    
    
}

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
        img.data.draw(in: CGRect(origin: .zero, size: img.data.size))
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
