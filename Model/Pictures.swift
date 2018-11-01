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
    
    
    private var Images:[Image] = [];
    
    
    
    
    
    func getImage(at index:Int)->Image?
    {
     
        return nil
    }
    func getImage(with:String)->Image?{
        return nil
    }
    func addImage(_ img:Image){
        
    }
    func deleteImage(at index:Int){
        
    }
    func savePictures(){
        
    }
    func sort(){
        
    }
    
}


struct Image:Codable,Comparable{
    static func < (lhs: Image, rhs: Image) -> Bool {
        return lhs.name < rhs.name;
    }
    
    
    var name:String = ""
    var data:UIImage
    
    
    
    init(image:UIImage){
        data = image
    }
    init(name:String,image:UIImage){
        self.name = name;
        data = image
    }
    

    
}
