//
//  Pictures.swift
//  Camera
//
//  Created by Seann Moser on 11/1/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import Foundation
import UIKit

struct Pictures{
    //Shared Instance of Pictures (Singleton Model)
    
    static var shared:Pictures = Pictures()
    
    static let UpdateLoadingNotification = Notification.Name(rawValue: "UpdateLoading")
    static let archiveName = "PhotoAlbum"
    
    private var dataFilePath = ""
    private var images:[Image] = [];
    private var dicImages:[String:Image] = [:];
    private var selectedImages:[Int] = []
    
    var count:Int{
        return images.count;
    }
    init(){
       // DispatchQueue.global().async {
          //  self.loadPictures()
        //}
       // savePictures()
    }

    func getImage(at index:Int)->Image?
    {
        if index >= 0 && index < images.count{
            return images[index];
        }
        return nil
    }
    
    func getImage(with name:String)->Image?{
        return dicImages[name]
    }
    
    func getImagesContaining(_ str:String)->[Image]{
        var imgs:[Image] = []
        for i in images{
            if i.conatains(str){
                imgs.append(i);
            }
        }
        return imgs;
    }
    func getAllImages()->[Image]{
        return images;
    }
    
    mutating func addImage(_ img:Image){
        var isFound = false
        if let _ = getImage(with:img.description){
            isFound = true
        }
        if isFound{
            img.name = "img_\(images.count)";
        }
        images.append(img);
        dicImages[img.description]=img;
    }
    mutating func addImages(_ img:[Image]){
        for i in img{
            addImage(i);
        }
    }
    
    mutating func deleteImage(at index:Int){
        if let i = getImage(at: index){
            images.remove(at: index);
            dicImages.removeValue(forKey: i.description)
            
            savePictures()
            
        }
    }
    mutating func deleteImagesContaining(_ str:String){
        let i = getImagesContaining(str)
        for img in i {
            if let index = images.firstIndex(of: img){
                deleteImage(at: index)
            }
        }
  
        
    }
    
    //selects and deselects Images
    mutating func selectImagesBetween(index1:Int,index2:Int){
        for i in index1..<index2{
            selectedImages.append(i);
        }
    }
    mutating func selectImage(at index:Int){
        selectedImages.append(index);
    }
    
    mutating func deSelectImage(at index:Int){
        if let i = selectedImages.firstIndex(of: index){
            selectedImages.remove(at: i);
        }
    }
    mutating func deSelectAllImages(){
        selectedImages.removeAll();
    }

    
    func savePictures(){
        DispatchQueue.global().async {
            let success = NSKeyedArchiver.archiveRootObject(self.images, toFile: self.filePath(fileName: Pictures.archiveName));
            if success{
                NotificationCenter.default.post(name: PhotoOutputDelegate.SavedImageNotification, object: nil)
            }
        }

    }
    
    mutating func loadPictures(){
        
        let filemgr = FileManager.default
        //sort()
        if filemgr.fileExists(atPath: filePath(fileName: Pictures.archiveName)){
            if let images = NSKeyedUnarchiver.unarchiveObject(withFile:filePath(fileName: Pictures.archiveName)) as? [Image]{
                for i in images{
                    addImage(i);
                    NotificationCenter.default.post(name: Pictures.UpdateLoadingNotification, object: nil)
                }
                
            }
        }
    }

    private mutating func sort(){
        images.sort();
    }
    func filePath(fileName:String) -> String {
        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (directory!.appendingPathComponent(fileName).path)
    }
}

