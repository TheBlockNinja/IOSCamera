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
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var flashBTN: UIButton!
    
  
    @IBOutlet weak var flashNotification: UIImageView!
    
    @IBOutlet weak var focusSlider: UISlider!
    
    @IBOutlet weak var zoomBTN: UIButton!
    
    @IBOutlet weak var filterImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        focusSlider.transform = CGAffineTransform(rotationAngle: CGFloat.pi / -2)
        focusSlider.frame = CGRect(x: 0, y: UIScreen.main.bounds.height*0.1, width: 50, height: UIScreen.main.bounds.height*0.75)
        focusSlider.setValue(0.0, animated: true)
        filterImageView.frame = zoomBTN.frame
        flashNotification.layer.cornerRadius = flashNotification.frame.width/2
    }
    override func viewWillAppear(_ animated: Bool) {
        addConnections(previewCameraFeed: cameraPreview, previewImage: PreviewImage, cameraSettings: Cameras.OldSchool)
        setFilterFeed(filterImageView)
        setCameraSkin(image: cameraSkinImageView)
        let distance = CGFloat(focusSlider!.value)
        UICamera.shared.setFocalDistance(distance)
        updateFlash()
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        filterImageView.image = nil
    }
    
    @IBAction func focusSliderChanged(_ sender: Any) {
        let distance = CGFloat(focusSlider!.value)
        UICamera.shared.setFocalDistance(distance)
    }
    @IBAction func zoomIn(_ sender: Any) {
        enlargeCamera()
        backBtn.isHidden = false
        zoomBTN.isHidden = true
        flashNotification.isHidden = true
        flashBTN.isHidden = true
        filterImageView.frame = cameraPreview.frame
    }
    @IBAction func zoomOut(_ sender: Any) {
        if zoomBTN.isHidden == true{
            enlargeCamera()
            backBtn.isHidden = true
            zoomBTN.isHidden = false
            flashNotification.isHidden = false
            flashBTN.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                 self.filterImageView.frame = self.zoomBTN.frame
            })
           
        }
    }


    @IBAction func switchFlash(_ sender: Any) {
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
    }
    
    @IBAction func TakePicture(_ sender: Any) {
        takePicture()
    }
    

    
}
