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
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var focusSlider: UISlider!
    
    @IBOutlet weak var infoLabel: UILabel!
    
   
    @IBOutlet weak var flashNotification: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFocusMode()
        focusSlider.transform = CGAffineTransform(rotationAngle: CGFloat.pi / -2)
        focusSlider.frame = CGRect(x: 0, y: UIScreen.main.bounds.height*0.1, width: 50, height: UIScreen.main.bounds.height*0.75)
       // focusSlider.setValue(0.0, animated: true)
        flashNotification.layer.cornerRadius = flashNotification.frame.width/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addConnections(previewCameraFeed: liveCameraFeed, previewImage: imagePreview, cameraSettings: .DSLR)
        setCameraSkin(image: cameraSkinImageView)
        
        let float = Float(UICamera.shared.getFocalDistanceF())
        focusSlider.setValue(float, animated: true)
 
        updateFocusMode()
        updateFlash()
        super.viewWillAppear(animated)
   
    }
    @IBAction func clickedOnCameraLens(_ sender: Any) {
        enlargeCamera()
        backBtn.isHidden = false
        cameraLensBtn.isHidden = true
        flashNotification.isHidden = true
        infoLabel.isHidden = true
        focusModeBTN.isHidden = true
        FlashBTN.isHidden = true
    }
    

    @IBAction func zoomIn(_ sender: Any) {
        if cameraLensBtn.isHidden == true{
            enlargeCamera()
            backBtn.isHidden = true
            cameraLensBtn.isHidden = false
            flashNotification.isHidden = false
            infoLabel.isHidden = false
            focusModeBTN.isHidden = false
            FlashBTN.isHidden = false
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
        updateFlash()
        
    }

    private func updateFlash(){
        if UICamera.shared.getCurrentFlash() == "ON"{
            flashNotification.isHidden = false;
            flashNotification.backgroundColor = .red
            flashNotification.addShadow(color: .red, radius: 10)
        }else if UICamera.shared.getCurrentFlash() == "AUTO"{
            flashNotification.isHidden = false;
            flashNotification.backgroundColor = .cyan
            flashNotification.addShadow(color: .cyan, radius: 10)
        }else{
            flashNotification.isHidden = true;
        }
        updateInfoLabel()
    }
    @IBAction func changeFocusMode(_ sender: Any) {
        UICamera.shared.switchFocusMode()
        updateFocusMode()
    }
    

    @IBAction func changeFocusSlider(_ sender: Any) {
        updateFocusMode()
    }
    func updateFocusMode(){
        //focusModeBTN.setTitle(UICamera.shared.getFocusMode(), for: .normal)
        
        if UICamera.shared.getFocusMode() == "Manual"{
            let distance = CGFloat(focusSlider!.value)
            UICamera.shared.setFocalDistance(distance)
            focusSlider.isHidden = false;
        }else{
            focusSlider.isHidden = true;
        }
          updateInfoLabel()
    }
    func updateInfoLabel(){
        infoLabel.text = "Focus:\(UICamera.shared.getFocusMode())"
        infoLabel.text?.append("    Flash:\(UICamera.shared.getCurrentFlash())")
    }
}
