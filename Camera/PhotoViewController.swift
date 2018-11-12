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
    
    let DeleteButtionRect = CGRect(x: 2, y: 2, width: 50, height: 20)
    
    let cellScale = CGAffineTransform(scaleX: 2, y: 2)
    
    let deleteButton = UIButton()
    
    var selectedCell = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global().async {
            Pictures.shared.loadPictures()
        }
        setupDeleteButton()
        NotificationCenter.default.addObserver(self, selector: #selector(didaddmoreImages), name: PhotoOutputDelegate.SavedImageNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didaddmoreImages), name: Pictures.UpdateLoadingNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        // imageView.removeAll()
        selectedCell = -1
      
       // Collection.reloadData()
    }
    func setupDeleteButton(){
        deleteButton.setTitle("DEL", for: .normal)
        deleteButton.frame = DeleteButtionRect
        deleteButton.layer.cornerRadius = 5
        deleteButton.backgroundColor = .cyan
        deleteButton.alpha = 0.7
        deleteButton.addTarget(self, action: #selector(deleteImage), for: .touchUpInside )
    }

    @objc func didaddmoreImages(){
        DispatchQueue.main.async {
           // self.updateImages()
            self.Collection.reloadData()
        }
    }
    @objc func deleteImage(){
        if selectedCell > -1{
            Pictures.shared.deleteImage(at: selectedCell)
            Collection.reloadData();
            if let items = Collection.indexPathsForSelectedItems{
                for i in items{
                    Collection.deselectItem(at: i, animated: true)
                }
            }
            selectedCell = -1
        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Pictures.shared.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        if Pictures.shared.count > indexPath.item{
            if let picture = Pictures.shared.getImage(at: indexPath.item){
                picture.imageView.frame.size = cell.frame.size
                cell.addSubview(picture.imageView)
            }
        }
        cell.layer.cornerRadius = 10
        return cell;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView.cellForItem(at: indexPath)?.transform.isIdentity)!{
            let isTop = indexPath.item < 2
            var isBottom = false
            
            //make this a method in picture model
            if 0 == Pictures.shared.count % 2{
                isBottom = indexPath.item >= Pictures.shared.count-2
            }else{
                isBottom = indexPath.item >= Pictures.shared.count-1
            }


            animateCellTransform(cell: (collectionView.cellForItem(at: indexPath)), isTop: isTop, isBottom:isBottom, cellScale)
            selectedCell = indexPath.item
            
        }else{
            animateCellTransform(cell: (collectionView.cellForItem(at: indexPath)))
            selectedCell = -1
            
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        animateCellTransform(cell: (collectionView.cellForItem(at: indexPath)))
        selectedCell = -1
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let items = Collection.indexPathsForSelectedItems{
            for i in items{
                Collection.deselectItem(at: i, animated: true)
            }
        }
    }

    
    private func animateCellTransform(cell:UICollectionViewCell?,isTop:Bool=false,isBottom:Bool=false,_ transf:CGAffineTransform=CGAffineTransform.identity){
        if let cell = cell{ //Checks if Cell exits
            
            //brings current cell to front of other UIViews(UICollectionView Cell)
            Collection.bringSubviewToFront(cell)
            //creates Distance stored variables
            var xDistance:CGFloat = 0
            var yDistance:CGFloat = 0
            if transf == CGAffineTransform.identity{
                xDistance =  0
                yDistance = 0
            }else{
                xDistance =  (UIScreen.main.bounds.midX) - cell.frame.midX
                if isBottom{
                    yDistance = (cell.frame.midY-(cell.frame.height/2)) - cell.frame.midY
                }
                if isTop{
                    yDistance = (UIScreen.main.bounds.midY) - cell.frame.midY
                }

            }
            //combines 2 transform methods ie. scale and distance
            //identity is the orginal position
            let combineTransfrom = transf.concatenating(CGAffineTransform(translationX: xDistance, y: yDistance))
            UIView.animate(withDuration: 0.15, animations: {
                cell.transform = combineTransfrom
            }){ (true) in
                if cell.transform.isIdentity{
                    if self.deleteButton.isDescendant(of: cell){
                        self.deleteButton.removeFromSuperview()
                    }
                }else{
                    if !self.deleteButton.isDescendant(of: cell){
                       cell.addSubview(self.deleteButton)
                    }
                }
           
            }
        }
        
        
    }
}
