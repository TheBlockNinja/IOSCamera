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
    
    
    static let archiveName = "PhotoAlbum"
    
    private var dataFilePath = ""
    private var images:[Image] = [];
    private var dicImages:[String:Image] = [:];
    var count:Int{
        return images.count;
    }
    init(){
        loadPictures()
    }
    func getImage(at index:Int)->Image?
    {
        if index > 0 && index < images.count{
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

    private mutating func loadPictures(){
        let filemgr = FileManager.default
        let dirPaths =
            NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                .userDomainMask, true)
        let docsDir = dirPaths[0]
        dataFilePath = docsDir + Pictures.archiveName
        sort()
        if filemgr.fileExists(atPath: dataFilePath){
            if let images = NSKeyedUnarchiver.unarchiveObject(withFile:dataFilePath) as? [Image]{
                for i in images{
                    addImage(i);
                }
                
            }
        }
    }
    
    func savePictures(){
        NSKeyedArchiver.archiveRootObject(images, toFile: dataFilePath);
    }
    
    private mutating func sort(){
        images.sort();
    }
    
    func getAllImages()->[Image]{
        return images;
    }
}

