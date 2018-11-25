//
//  OldSchoolViewController.swift
//  Camera
//
//  Created by Seann Moser on 11/14/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import UIKit

class OldSchoolViewController: BaseCameraViewController {

    @IBOutlet weak var cameraPreview: UIView!
    @IBOutlet weak var PreviewImage: UIImageView!
    @IBOutlet weak var cameraSkinImageView: UIImageView!
    
    
    @IBOutlet weak var flashBTN: UIButton!
    
    @IBOutlet weak var focusSlider: UISlider!
    
    @IBOutlet weak var zoomBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        focusSlider.transform = CGAffineTransform(rotationAngle: CGFloat.pi / -2)
        focusSlider.frame = CGRect(x: UIScreen.main.bounds.width-50, y: UIScreen.main.bounds.height*0.1, width: 50, height: UIScreen.main.bounds.height*0.75)
        focusSlider.setValue(0.0, animated: true)
    }
    
    @IBAction func focusSliderChanged(_ sender: Any) {
        let distance = CGFloat(focusSlider!.value)
        UICamera.shared.setFocalDistance(distance)
    }
    @IBAction func zoomIn(_ sender: Any) {
        enlargeCamera()
        zoomBTN.isHidden = true
    }
    @IBAction func zoomOut(_ sender: Any) {
        if zoomBTN.isHidden == true{
            enlargeCamera()
            zoomBTN.isHidden = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        addConnections(previewCameraFeed: cameraPreview, previewImage: PreviewImage, cameraSettings: CameraSettings.OldSchool)
        setCameraSkin(image: cameraSkinImageView)
        super.viewWillAppear(animated)
        flashBTN.setTitle("\(UICamera.shared.getCurrentFlash())", for: .normal)
    }
    
    @IBAction func switchFlash(_ sender: Any) {
        UICamera.shared.switchFlash()
        flashBTN.setTitle("\(UICamera.shared.getCurrentFlash())", for: .normal)
    }    

    
    @IBAction func TakePicture(_ sender: Any) {
        takePicture()
    }
    

    
}
