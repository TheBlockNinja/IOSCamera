//
//  DSLRViewController.swift
//  Camera
//
//  Created by Seann Moser on 11/14/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import UIKit

class DSLRViewController: BaseCameraViewController {

    @IBOutlet weak var liveCameraFeed: UIView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var cameraSkinImageView: UIImageView!
    
    @IBOutlet weak var FlashBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addConnections(previewCameraFeed: liveCameraFeed, previewImage: imagePreview, cameraSettings: .DSLR)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FlashBTN.setTitle("\(UICamera.shared.getCurrentFlash())", for: .normal)
    }
    
    @IBAction func doubleTapGesture(_ sender: UITapGestureRecognizer) {
        takePicture()
    }
    @IBAction func willTakePicture(_ sender: Any) {
        takePicture()
    }
    
    @IBAction func longGesture(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: liveCameraFeed)
        UICamera.shared.focusCameraOnPoint(location)
    }
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        UICamera.shared.flipCamera()
    }
     
    @IBAction func changeFlash(_ sender: Any) {
        UICamera.shared.switchFlash()
        FlashBTN.setTitle("\(UICamera.shared.getCurrentFlash())", for: .normal)
    }
    

}
