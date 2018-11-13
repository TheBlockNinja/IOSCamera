//
//  ViewController.swift
//  Camera
//
//  Created by Seann Moser on 10/31/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: BaseCameraViewController{

    @IBOutlet weak var previewCameraFeed: UIView!

    @IBOutlet weak var previewImage: UIImageView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addConnections(previewCameraFeed: previewCameraFeed, previewImage: previewImage, cameraSettings: cameraSettings.cameras[0])
    }

    @IBAction func focusLong(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: previewImage)
        let calculatedPoint = CGPoint(x: location.x/previewImage.frame.width, y: location.y/previewImage.frame.height)
        camera.focusCamera(on: calculatedPoint)
    }

    @IBAction func switchCamera(_ sender: Any) {
        camera.flipPostion()
        
    }
    @IBAction func didTapScreen(_ sender: Any) {
        takePicture()
    }


}

