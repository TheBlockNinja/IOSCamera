//
//  Image.swift
//  Camera
//
//  Created by Seann Moser on 11/5/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import Foundation
import UIKit

class Image:NSObject,NSCoding,Comparable{
    static let imageSaveName = "IMGSAVE"
    static let nameSaveName = "NAMESAVE"
    static let InfoSaveName = "InfoSave"
    
    
    static func < (lhs: Image, rhs: Image) -> Bool {
        return lhs.name < rhs.name;
    }
    
    
    var name:String = ""
    
    var data:UIImage
    
    private var info:String = "" // desciption of the photo
    
    
    override var description: String
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

    
    func setInfo(_ info:String){
        self.info = info
    }
    func getInfo()->String{
        return info;
    }
    
    func conatains(_ str:String)->Bool{
        if info.lowercased().contains(str.lowercased()) || name.lowercased().contains(str.lowercased()){
            return true
        }
        return true
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(data, forKey: Image.imageSaveName)
        aCoder.encode(name, forKey: "NAME");
        aCoder.encode(info, forKey: Image.InfoSaveName);
      //  aCoder.encode(orgininalImage, forKey: Image.imageOriginalSaveName);
        
    }
    required convenience init?(coder aDecoder: NSCoder) {
       //let i = UIImage.init
        
        let img = aDecoder.decodeObject(forKey: Image.imageSaveName) as? UIImage
      //  let original = aDecoder.decodeObject(forKey: Image.imageOriginalSaveName) as? UIImage
        let nam = aDecoder.decodeObject(forKey: Image.nameSaveName)
        let inf = aDecoder.decodeObject(forKey: Image.InfoSaveName)
        
        if let img = img,let name = nam as? String{
            self.init(name: name, image: img);
        }else{
            //fatalError("UNABLE TO LOAD IMAGES");
            self.init(image: img ?? UIImage())
        }
        if let inf = inf as? String{
            self.setInfo(inf)
        }
        
    }
    

    
    
    
}
