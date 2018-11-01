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
    
    
    private var images:[Image] = [];
    private var dicImages:[String:Image] = [:];
    
    
    
    
    func getImage(at index:Int)->Image?
    {
     
        return nil
    }
    func getImage(with:String)->Image?{
        return nil
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
    func deleteImage(at index:Int){
        
    }
    func savePictures(){
        
    }
    func sort(){
        
    }
    
}



struct Image:Codable,Comparable,CustomStringConvertible{
    
    static func < (lhs: Image, rhs: Image) -> Bool {
        return lhs.name < rhs.name;
    }
    
    
    var name:String = ""
    
    var data:UIImage
    
    
    var description: String
    {
        return name;
    }
    
    
    init(image:UIImage){
        data = image
    }
    init(name:String,image:UIImage){
        self.name = name;
        data = image
    }
    

    
}
