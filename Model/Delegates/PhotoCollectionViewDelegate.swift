//
//  PhotoCollectionViewDelegae.swift
//  Camera
//
//  Created by Seann Moser on 11/17/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import Foundation
import UIKit
class PhotoCollectionViewDelegate:NSObject,UICollectionViewDelegate,UICollectionViewDataSource{
    //notifcation name to update collection view when photo is done saving
    static let UpdatedCollectionView = Notification.Name(rawValue: "UpdatedCollectionView")
    //sets delete button frame inside of the collectionview cell
    private let DeleteButtionRect = CGRect(x: 2, y: 2, width: 20, height: 20)
    //sets save button rect inside of collectionview cell
    private let SaveButtionRect = CGRect(x: 54, y: 2, width: 60, height: 20)
    //sets the scale size of the cell when selected
    private let cellScale = CGAffineTransform(scaleX: 1.5, y: 1.5)
    //creates a delete button
    private let deleteButton:UIButton? = UIButton()
    //creates save button
    let saveToCameraRoll:UIButton? = UIButton()
    //gets selected cell index
    var selectedCell = -1
    //if cell was just deleted
    var justDeleted = false
    
    override init() {
        super.init()
        setupSaveToCameraRoll()
        setupDeleteButton()
    }

    //sets up delete button and adds target and adds target method
    func setupDeleteButton(){
        if let deleteButton = deleteButton{
        deleteButton.setTitle("X", for: .normal)
        deleteButton.frame = DeleteButtionRect
        deleteButton.layer.cornerRadius = 10
        deleteButton.backgroundColor = .gray
        deleteButton.alpha = 0.6
        deleteButton.addTarget(self, action: #selector(deleteImage), for: .touchUpInside )
        }
        
    }
    //sets up saveButton and adds target method
    func setupSaveToCameraRoll(){
        if let saveToCameraRoll = saveToCameraRoll{
            saveToCameraRoll.setTitle("SAVE", for: .normal)
            saveToCameraRoll.frame = SaveButtionRect
            saveToCameraRoll.layer.cornerRadius = 5
            saveToCameraRoll.backgroundColor = .blue
            saveToCameraRoll.alpha = 0.6
            saveToCameraRoll.addTarget(self, action: #selector(saveImageToCameraRoll), for: .touchUpInside )
        }
    }
    //collection view protocal methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(UICamera.shared.pictures.count)
        return UICamera.shared.pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //createss a cell from the cell in the story board with name Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
    
        //checks if indexPath is valid
        if UICamera.shared.pictures.count > indexPath.item{
            if let picture = UICamera.shared.pictures.getImage(at: indexPath.item){
                picture.imageView.frame.size = cell.frame.size
                cell.addSubview(picture.imageView)
            }
        }
        cell.layer.cornerRadius = 2
        return cell;
        
    }
   // func numberOfSections(in collectionView: UICollectionView) -> Int {
       // return 4
   // }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView.cellForItem(at: indexPath)?.transform.isIdentity)!{
            
            //brings current cell to front of other UIViews(UICollectionView Cell)
            collectionView.bringSubviewToFront((collectionView.cellForItem(at: indexPath)!))
            animateCellTransform(cell: (collectionView.cellForItem(at: indexPath)),index:indexPath.item, cellScale)
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
    
    
    
    
    //animates cell when selected or deselected
    //brings cell to center or returns it to orginal spot by using CGAffineTransfrom.identity
    func animateCellTransform(cell:UICollectionViewCell?,index:Int = -1,_ transf:CGAffineTransform=CGAffineTransform.identity){
        
        //Checks if Cell exits
        if let cell = cell{
        
            //creates Distance stored variables
            var xDistance:CGFloat = 0
            var yDistance:CGFloat = 0
            
            //checks if cell is not in its orginal position
            if transf != CGAffineTransform.identity{
                
                //gets difference between the center of the screen and its current position
                xDistance =  (UIScreen.main.bounds.midX) - cell.frame.midX
                
                //if cell is at the bottom the cell will be offset to bring it up into the center of the view
                //will cut of the picture if not
                if UICamera.shared.pictures.isBottom(index: index){
                    yDistance = (cell.frame.midY-(cell.frame.height/2)) - cell.frame.midY
                }
                //if cell is at the top the cell will be brought down to the center
                //will cut of the picture if not
                if UICamera.shared.pictures.isTop(index: index){
                    yDistance = (UIScreen.main.bounds.midY) - cell.frame.midY
                }
            }
            
            //combines 2 transform methods ie. scale and distance
            //identity is the orginal position
            let combineTransfrom = transf.concatenating(CGAffineTransform(translationX: xDistance, y: yDistance))
            focusOn(cell, combineTransfrom)
        }
        
        
        
    }
    
    
    
    
    //is the acutal animation function
    private func focusOn(_ cell: UICollectionViewCell, _ combineTransfrom: CGAffineTransform) {
        //sets cell position and scale to combineTransform over a period of 0.15 seconds
        UIView.animate(withDuration: 0.15, animations: {
            cell.transform = combineTransfrom
        }){ (true) in
            //adds or removes buttons based of the cells current position
            //if cell = identity then remove buttons if they are in the cell
            //else load buttons into cell if they are not already in the cell
            self.isButtonIn(cell: cell, Button: self.deleteButton!)
            
            self.saveToCameraRoll?.frame = CGRect(x: (cell.frame.origin.x + (cell.frame.width/2)) - (self.SaveButtionRect.width*1.3),
                                                  y: 2,
                                                  width: (self.SaveButtionRect.width),
                                                  height: (self.SaveButtionRect.height))
            
            self.isButtonIn(cell: cell, Button: self.saveToCameraRoll!)
        }
    }
    private func isButtonIn(cell:UICollectionViewCell,Button:UIButton){
        //if cell is in its orginal position
        if cell.transform.isIdentity{
            
            //if button is in cell remove from cell
            if Button.isDescendant(of: cell){
                Button.removeFromSuperview()
            }
        }else{
            //if cell is in the center
            
            //if button is not in cell and to the cell
            if !Button.isDescendant(of: cell){
                cell.addSubview(Button)
            }
        }
    }
    
    //is called when the user presses the delete button
    @objc func deleteImage(){
        if selectedCell > -1{
            saveToCameraRoll?.removeFromSuperview()
            deleteButton?.removeFromSuperview()
            UICamera.shared.pictures.deleteImage(at: selectedCell)
            selectedCell = -1
            NotificationCenter.default.post(name: PhotoCollectionViewDelegate.UpdatedCollectionView, object: nil)
             justDeleted = true
 
        }
    }
    //is called when the user presses the save button
    @objc func saveImageToCameraRoll(){
        if selectedCell > -1{
            
            //saves image to camera roll if an image is selected
            UICamera.shared.pictures.saveImageToCameraRoll(at: selectedCell)
            
            //deselect the image to avoid confusion
            selectedCell = -1
        }
    }
}
