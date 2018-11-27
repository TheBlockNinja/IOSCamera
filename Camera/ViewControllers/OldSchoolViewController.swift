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
    
    @IBOutlet weak var focusSlider: UISlider!
    
    @IBOutlet weak var zoomBTN: UIButton!
    
    var previewTimer:Timer?
    
    @IBOutlet weak var filterImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        focusSlider.transform = CGAffineTransform(rotationAngle: CGFloat.pi / -2)
        focusSlider.frame = CGRect(x: 0, y: UIScreen.main.bounds.height*0.1, width: 50, height: UIScreen.main.bounds.height*0.75)
        focusSlider.setValue(0.0, animated: true)
        filterImageView.frame = zoomBTN.frame
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UICamera.shared.setCameraSettings(Cameras.non)
        previewTimer?.invalidate()
    }
    
    @IBAction func focusSliderChanged(_ sender: Any) {
        let distance = CGFloat(focusSlider!.value)
        UICamera.shared.setFocalDistance(distance)
    }
    @IBAction func zoomIn(_ sender: Any) {
        enlargeCamera()
        backBtn.isHidden = false
        zoomBTN.isHidden = true
        filterImageView.frame = cameraPreview.frame
    }
    @IBAction func zoomOut(_ sender: Any) {
        if zoomBTN.isHidden == true{
            enlargeCamera()
            backBtn.isHidden = true
            zoomBTN.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                 self.filterImageView.frame = self.zoomBTN.frame
                })
           
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        addConnections(previewCameraFeed: cameraPreview, previewImage: PreviewImage, cameraSettings: Cameras.OldSchool)
        setCameraSkin(image: cameraSkinImageView)
        let distance = CGFloat(focusSlider!.value)
        UICamera.shared.setFocalDistance(distance)
        super.viewWillAppear(animated)
        flashBTN.setTitle("\(UICamera.shared.getCurrentFlash())", for: .normal)
        previewTimer = Timer.scheduledTimer(timeInterval: 1/30, target: self, selector: #selector(preview), userInfo: nil, repeats: true)
    }
    @objc func preview(){
        filterImageView.image = videoFeed.Feed
    }
    
    @IBAction func switchFlash(_ sender: Any) {
        UICamera.shared.switchFlash()
        flashBTN.setTitle("\(UICamera.shared.getCurrentFlash())", for: .normal)
    }    

    
    @IBAction func TakePicture(_ sender: Any) {
        takePicture()
    }
    

    
}
