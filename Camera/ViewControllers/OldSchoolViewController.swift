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
    
    @IBOutlet weak var focusLBL: UILabel!
    
    @IBOutlet weak var flashBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        addConnections(previewCameraFeed: cameraPreview, previewImage: PreviewImage, cameraSettings: CameraSettings.OldSchool)
        focusLBL.text = UICamera.shared.getFocalDistance()
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
    
    @IBAction func IncreaseFocalDistance(_ sender: Any) {
        UICamera.shared.changeFocualDistance()
        focusLBL.text = UICamera.shared.getFocalDistance()
    }
    
    @IBAction func DecreaseFocalDistance(_ sender: Any) {
        UICamera.shared.changeFocualDistance(by: -0.005)
        focusLBL.text = UICamera.shared.getFocalDistance()
    }
    
}
