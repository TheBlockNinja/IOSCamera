//
//  UIViewExtension.swift
//  Camera
//
//  Created by Seann Moser on 11/17/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
extension UIView{
    //creates a tempory label that will appear on top of any obj that inherits the UIView
    func showLabelWith(frame:CGRect,text:String,duration:Double){
        
        //creates and sets up the label
        let lbl = UILabel(frame: frame)
        
        //moves label to the front of the current view
        self.bringSubviewToFront(lbl)
        lbl.backgroundColor = .gray
        lbl.alpha = 0.7
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 34)
        lbl.textColor = .white
        lbl.text = text
        
        //displays the label
        self.addSubview(lbl)
        
        //animates the current Uiview
        UIView.animate(withDuration: duration, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            lbl.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }) { (success) in
            
            //once animations are completed the lbl is removed from the superview
            //gets deallocated becasuse nothing else is pointing to it
            lbl.removeFromSuperview()
        }
    }
    
     //fades the view out while zooming into the view
    func zoomInFade(){
        if self.transform.isIdentity{
            let scaleUp = CGAffineTransform(scaleX: 4, y: 4)
            UIView.animate(withDuration: 0.5, animations: {
                self.transform = scaleUp
                self.alpha = 0.05
            })
        }
    }
    
    //fades the view in while zooming in
    func zoomOutFadeIn(){
        if !self.transform.isIdentity{
            UIView.animate(withDuration: 0.5, animations: {
                self.transform = CGAffineTransform.identity
                self.alpha = 1.0
            })
        }
    }
    static func getCurrentOrientation()->AVCaptureVideoOrientation{
        switch UIDevice.current.orientation
        {
            
        case .unknown:
            return AVCaptureVideoOrientation.landscapeLeft
    //    case .portrait:
            
      //  case .portraitUpsideDown:
            
        case .landscapeLeft:
            return AVCaptureVideoOrientation.landscapeLeft
        case .landscapeRight:
            return AVCaptureVideoOrientation.landscapeRight
        default:
            return AVCaptureVideoOrientation.landscapeLeft
            
        }
        
    }
    
}

