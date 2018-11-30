//
//  Pictures.swift
//  Camera
//
//  Created by Seann Moser & Theodore Holden on 11/1/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import Foundation
import UIKit
import Photos
struct Pictures{
    //Shared Instance of Pictures (Singleton Model)
    
    
    static let UpdateLoadingNotification = Notification.Name(rawValue: "UpdateLoading")
    static let SavedToCameraRollNotification = Notification.Name(rawValue: "SavedToCameraRollNotification")
    static let archiveName = "PhotoAlbum"
    
    private var dataFilePath = ""
    private var images:[Image] = [];
    private var selectedImages:[Int] = [] // not in use yet
    private var picturesAreLoaded = false // to prevent loading images multiplute times, just in case
    
    var count:Int{
        return images.count;
    }

    
    func getImage(at index:Int)->Image?
    {
        if index >= 0 && index < images.count{
            return images[index];
        }
        return nil
    }
    
    func savePictures(){
        Threads.PictureThread.async {
            let success = NSKeyedArchiver.archiveRootObject(self.images, toFile: self.filePath(fileName: Pictures.archiveName));
            if success{
                NotificationCenter.default.post(name: PhotoOutputDelegate.SavedImageNotification, object: nil)
            }
        }
        
    }
    func isBottom(index:Int)->Bool{
        if index < 0{
            return false
        }
        if 0 == count % 2{
            return index >= count-2
        }else{
            return index >= count-1
        }
    }
    
    func isTop(index:Int)->Bool{
        if index >= 0{
            return index < 2;
        }
        return false
    }
    
    func saveImageToCameraRoll(at index:Int){
        if let image = getImage(at: index)?.data {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { (didSaveImage, DidThrowError) in
                if didSaveImage{
                    NotificationCenter.default.post(name: Pictures.SavedToCameraRollNotification, object: nil)
                }
            }
        }
    }
    
    func getAllImages()->[Image]{
        return images;
    }
    
    mutating func addImage(_ img:Image){
        images.append(img);
    }
    mutating func addImages(_ img:[Image]){
        for i in img{
            addImage(i);
        }
    }
    
    mutating func deleteImage(at index:Int){
        if let _ = getImage(at: index){
            let image = images[index]
            image.delete()
            images.remove(at: index);
            savePictures()
        }
    }
    mutating func deleteAllImages(){
        for i in images{
            i.delete()
        }
        images.removeAll()
        savePictures()
    }
    
    //has no use yet
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
    //ends no use yet
    

    mutating func loadPictures(){
        
        let filemgr = FileManager.default
        if !picturesAreLoaded{
            if filemgr.fileExists(atPath: filePath(fileName: Pictures.archiveName)){
                if let images = NSKeyedUnarchiver.unarchiveObject(withFile:filePath(fileName: Pictures.archiveName)) as? [Image]{
                    picturesAreLoaded = true
                    for i in images{
                        addImage(i);
                    }
                    NotificationCenter.default.post(name: Pictures.UpdateLoadingNotification, object: nil)
                }
            }
        }
        
    }
    
    private func filePath(fileName:String) -> String {
        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (directory!.appendingPathComponent(fileName).path)
    }
    
    private mutating func sort(){
        images.sort();
    }

    

}

