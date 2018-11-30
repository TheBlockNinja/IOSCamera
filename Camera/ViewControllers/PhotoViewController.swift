//
//  PhotoViewController.swift
//  Camera
//
//  Created by Seann Moser & Theodore Holden on 11/7/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    
    @IBOutlet weak var Collection: UICollectionView!
    
    let CollectionDelegate = PhotoCollectionViewDelegate()
    var SaveImageRect:CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Collection.delegate = CollectionDelegate
        Collection.dataSource = CollectionDelegate
        SaveImageRect = CGRect(x: 0, y: 0, width: 75, height: 30)

    }
    override func viewWillAppear(_ animated: Bool) {
        addNotifications()
        CollectionDelegate.justDeleted = false
        didaddmoreImages()
        UICamera.shared.setCameraSettings(Cameras.non)
    }

    override func viewWillDisappear(_ animated: Bool) {
        deseletItems()
        removeNotifications()
    }
    
    func didUpdateViewController(){
        DispatchQueue.main.async {
            self.Collection.reloadData()
        }
    }
    
    @objc func didaddmoreImages(){
        if !CollectionDelegate.justDeleted {
           didUpdateViewController()
        }else{
            CollectionDelegate.justDeleted = false
        }
    }
    
    @objc func savedImage(){
        deseletItems()
        
    }
    
    private func deseletItems(){
         DispatchQueue.main.async {
            self.view.showLabelWith(frame: self.SaveImageRect!, text: "Saved", duration: 1.5)
            if let items = self.Collection.indexPathsForSelectedItems{
                for i in items{
                    if let cell = self.Collection.cellForItem(at: i){
                        self.CollectionDelegate.animateCellTransform(cell: cell)
                    }
                }
            }
          //  Thread.exit()
        }
    }
    private func addNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(didaddmoreImages), name: PhotoOutputDelegate.SavedImageNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didaddmoreImages), name: Pictures.UpdateLoadingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didaddmoreImages), name: PhotoCollectionViewDelegate.UpdatedCollectionView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(savedImage), name: Pictures.SavedToCameraRollNotification, object: nil)
    }
    
    private func removeNotifications(){
        NotificationCenter.default.removeObserver(self, name: PhotoOutputDelegate.SavedImageNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: Pictures.UpdateLoadingNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: PhotoCollectionViewDelegate.UpdatedCollectionView, object: nil)
        NotificationCenter.default.removeObserver(self, name: Pictures.SavedToCameraRollNotification, object: nil)
    }




    

    

}
