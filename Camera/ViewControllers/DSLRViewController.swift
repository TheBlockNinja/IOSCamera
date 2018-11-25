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
    @IBOutlet weak var cameraLensBtn: UIButton!
    
    @IBOutlet weak var FlashBTN: UIButton!
    
    @IBOutlet weak var focusModeBTN: UIButton!
    
    @IBOutlet weak var focusSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        focusModeBTN.setTitle(UICamera.shared.getFocusMode(), for: .normal)
        if UICamera.shared.getFocusMode() == "Locked"{
            focusSlider.isHidden = false;
        }else{
            focusSlider.isHidden = true;
        }
        focusSlider.transform = CGAffineTransform(rotationAngle: CGFloat.pi / -2)
        focusSlider.frame = CGRect(x: UIScreen.main.bounds.width-50, y: UIScreen.main.bounds.height*0.1, width: 50, height: UIScreen.main.bounds.height*0.75)
       // focusSlider.setValue(0.0, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addConnections(previewCameraFeed: liveCameraFeed, previewImage: imagePreview, cameraSettings: .DSLR)
        setCameraSkin(image: cameraSkinImageView)
        super.viewWillAppear(animated)
        let float = Float(UICamera.shared.getFocalDistanceF())
        focusSlider.setValue(float, animated: true)
        FlashBTN.setTitle("\(UICamera.shared.getCurrentFlash())", for: .normal)
    }
    @IBAction func clickedOnCameraLens(_ sender: Any) {
        enlargeCamera()
        cameraLensBtn.isHidden = true
    }
    
    @IBAction func doubleTapGesture(_ sender: UITapGestureRecognizer) {
        if cameraLensBtn.isHidden == true{
            enlargeCamera()
            cameraLensBtn.isHidden = false
        }
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

    @IBAction func changeFocusMode(_ sender: Any) {
        UICamera.shared.switchFocusMode()
        focusModeBTN.setTitle(UICamera.shared.getFocusMode(), for: .normal)
        if UICamera.shared.getFocusMode() == "Locked"{
            focusSlider.isHidden = false;
        }else{
            focusSlider.isHidden = true;
        }
    }
    

    @IBAction func changeFocusSlider(_ sender: Any) {
        if UICamera.shared.getFocusMode() == "Locked"{
            let distance = CGFloat(focusSlider!.value)
            UICamera.shared.setFocalDistance(distance)
        }else{
            focusSlider.isHidden = true;
        }
        
    }
}
