//
//  SettingsViewController.swift
//  Camera
//
//  Created by Theodore Holden on 11/12/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var deleteAllImagesBTN: UIButton!
    var countDownTimer:Timer!
    var countDown = 3;
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
   
    }
    override func viewWillAppear(_ animated: Bool) {
        deleteAllImagesBTN.setTitle("Delete \(UICamera.shared.pictures.count) pictures", for: .normal)
        UICamera.shared.setCameraSettings(Cameras.non)
    }

    @IBAction func deleteAllImages(_ sender: Any) {
        if countDownTimer != nil{
            countDownTimer.invalidate()
            countDownTimer = nil
            countDown = 3
            update()
        }else{
            countDownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(deletePictures), userInfo: nil, repeats: true)
        }
    }
    @objc private func deletePictures(){
        if countDown < 0 {
            countDownTimer.invalidate()
            countDownTimer = nil
            countDown = 3
            UICamera.shared.pictures.deleteAllImages()
            update()
        }else{
            deleteAllImagesBTN.setTitle("Deleting in \(countDown)", for: .normal)
            countDown -= 1
        }
    }
    func update(){
        deleteAllImagesBTN.setTitle("Delete \(UICamera.shared.pictures.count) pictures", for: .normal)
    }
}
