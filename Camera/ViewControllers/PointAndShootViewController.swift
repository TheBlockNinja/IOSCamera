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
    
    @IBOutlet weak var flashIndicator: UILabel!
    @IBOutlet weak var cameraLensBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        self.addConnections(previewCameraFeed: previewCameraFeed, previewImage: previewImage, cameraSettings: CameraSettings.PointAndShoot)
        setCameraSkin(image: cameraSkinImageView)
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    

    @IBAction func CameraLensClicked(_ sender: Any) {
        if cameraLensBtn.isHidden == false{
            enlargeCamera()
            cameraLensBtn.isHidden = true
            FlashBTN.isHidden = true
            flashIndicator.isHidden = true
        }
    }
    @IBAction func focusLong(_ sender: UILongPressGestureRecognizer) {
        UICamera.shared.focusCameraOnPoint()
    }
    @IBAction func zoomOutTap(_ sender: Any) {
        if cameraLensBtn.isHidden == true{
            enlargeCamera()
            cameraLensBtn.isHidden = false
            FlashBTN.isHidden = false
            flashIndicator.isHidden = false
        }
    }
    
    @IBAction func switchCamera(_ sender: Any) {
        UICamera.shared.flipCamera()
        
    }
    @IBAction func didTapScreen(_ sender: Any) {
        takePicture()
    }
    @IBAction func changeFlash(_ sender: Any) {
        UICamera.shared.switchFlash()
        if UICamera.shared.getCurrentFlash() == "ON"{
            flashIndicator.backgroundColor = .yellow
            flashIndicator.addShadow(color: .yellow, radius: 15)
            flashIndicator.alpha = 0.3
        }else{
            flashIndicator.backgroundColor = .clear
            flashIndicator.addShadow(color: .clear, radius: 0)
        }
        
      //  FlashBTN.setTitle("\(UICamera.shared.getCurrentFlash())", for: .normal)
    }

}

