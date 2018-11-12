//
//  ViewController.swift
//  Camera
//
//  Created by Seann Moser on 10/31/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {

    @IBOutlet weak var previewCameraFeed: UIView!

    @IBOutlet weak var previewImage: UIImageView!
    
    var photoDelegate:PhotoOutputDelegate = PhotoOutputDelegate()
    var camera = CameraData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showPreview), name: PhotoOutputDelegate.PreviewNotification, object: nil)
        previewImage.contentMode = .scaleAspectFit
        previewCameraFeed.layer.addSublayer(camera.previewVideoLayer)
        camera.setPreviewFrame(previewCameraFeed.frame)
    }
    override func viewDidDisappear(_ animated: Bool) {
        camera.session.stopRunning()
    }
    override func viewWillAppear(_ animated: Bool) {
        camera.session.startRunning()
    }
    @IBAction func focusLong(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: previewImage)
        let calculatedPoint = CGPoint(x: location.x/previewImage.frame.width, y: location.y/previewImage.frame.height)
        camera.focusCamera(on: calculatedPoint)
    }

    @IBAction func switchCamera(_ sender: Any) {
        camera.flipPostion()
        
    }
    @IBAction func didTapScreen(_ sender: Any) {
        camera.photoOutput.capturePhoto(with: camera.getPhotoSettings(), delegate: photoDelegate)
    }

    @objc func showPreview(){
        previewImage.image = photoDelegate.CurrentPreviewImage
        UIView.animate(withDuration: 1.0, animations: {
            self.previewImage.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (true) in
            self.previewImage.transform = CGAffineTransform.identity
            self.previewImage.image = nil;
            
        }
    }

    
}

