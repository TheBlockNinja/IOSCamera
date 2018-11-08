//
//  PhotoViewController.swift
//  Camera
//
//  Created by Seann Moser on 11/7/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    
    
    @IBOutlet weak var Collection: UICollectionView!
    
    @IBOutlet weak var PreviewImage: UIImageView!
    
   

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Pictures.shared.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        //cell.subviews


        cell.backgroundColor = UIColor.cyan
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 150));
        
        cell.addSubview(imageView)
        
        let image = Pictures.shared.getImage(at: indexPath.item)!.orgininalImage
        imageView.image = image
        
        
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        cell.layer.cornerRadius = 5
       // cell.addSubview(imageView)
        
        

        
        
        return cell;
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let image = Pictures.shared.getImage(at: indexPath.item){
            PreviewImage.image = image.data
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOADING")

        
       // Collection.reloadData()
        PreviewImage.contentMode = UIView.ContentMode.scaleAspectFit
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       // PreviewImage.image = Pictures.shared.getImage(at: 0)!.data
        //Collection.reloadData()
      //  print("RELOAD")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
