//
//  ViewController.swift
//  Camera
//
//  Created by Seann Moser on 10/31/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import UIKit
import AVFoundation
class PointAndShootViewController: BaseCameraViewController{

    @IBOutlet weak var previewCameraFeed: UIView!

    @IBOutlet weak var previewImage: UIImageView!
    
    @IBOutlet weak var cameraSkinImageView: UIImageView!
    
    @IBOutlet weak var FlashBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addConnections(previewCameraFeed: previewCameraFeed, previewImage: previewImage, cameraSettings: CameraSettings.PointAndShoot)
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FlashBTN.setTitle("\(UICamera.shared.getCurrentFlash())", for: .normal)
    }

    @IBAction func focusLong(_ sender: UILongPressGestureRecognizer) {
        UICamera.shared.focusCameraOnPoint()
    }

    @IBAction func switchCamera(_ sender: Any) {
        UICamera.shared.flipCamera()
        
    }
    @IBAction func didTapScreen(_ sender: Any) {
        takePicture()
    }
    @IBAction func changeFlash(_ sender: Any) {
        UICamera.shared.switchFlash()
        FlashBTN.setTitle("\(UICamera.shared.getCurrentFlash())", for: .normal)
    }

}

