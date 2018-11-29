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
    
    @IBOutlet weak var filteredImageFeed: UIImageView!
    @IBOutlet weak var FlashBTN: UIButton!
    
    @IBOutlet weak var flashIndicator: UILabel!
    @IBOutlet weak var cameraLensBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        self.addConnections(previewCameraFeed: previewCameraFeed, previewImage: previewImage, cameraSettings: Cameras.PointAndShoot)
        setCameraSkin(image: cameraSkinImageView)
        setFilterFeed(filteredImageFeed)
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
            backBtn.isHidden = false
            flashIndicator.isHidden = true
            filteredImageFeed.frame = previewCameraFeed.frame
        }
    }
    @IBAction func focusLong(_ sender: UILongPressGestureRecognizer) {
        UICamera.shared.focusCameraOnPoint()
    }
    @IBAction func zoomOut(_ sender: Any) {
        if cameraLensBtn.isHidden == true{
            enlargeCamera()
            cameraLensBtn.isHidden = false
            FlashBTN.isHidden = false
            backBtn.isHidden = true
            flashIndicator.isHidden = false
            filteredImageFeed.frame = cameraLensBtn.frame
        }
    }

    
    @IBAction func switchCamera(_ sender: Any) {
        UICamera.shared.flipCamera()
        
    }
    @IBAction func didTapScreen(_ sender: Any) {
        takePicture()
        checkFilterFeedSize()
    }

    @IBAction func changeFlash(_ sender: Any) {
        UICamera.shared.switchFlash()
        if UICamera.shared.getCurrentFlash() == "ON"{
            flashIndicator.backgroundColor = .yellow
            flashIndicator.addShadow(color: .yellow, radius: 15)
            flashIndicator.alpha = 0.6
            cameraSkinImageView.image = UIImage(named: "Point and shootv0.png")
        }else{
            flashIndicator.backgroundColor = .clear
            flashIndicator.addShadow(color: .clear, radius: 0)
            cameraSkinImageView.image = UIImage(named: "Point and shoot flash off.png")
        }
        
    }

}

