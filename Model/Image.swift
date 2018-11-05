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
    static let imageOriginalSaveName = "IMGOriginalSAVE"
    static let nameSaveName = "NAMESAVE"
    static let InfoSaveName = "InfoSave"
    static func < (lhs: Image, rhs: Image) -> Bool {
        return lhs.name < rhs.name;
    }
    
    
    var name:String = ""
    
    var data:UIImage
    
    let orgininalImage:UIImage
    
    private var info:String = "" // desciption of the photo
    
    
    override var description: String
    {
        return name;
    }
    
    
    init(image:UIImage){
        orgininalImage = image
        data = image
    }
    init(name:String,image:UIImage){
        orgininalImage = image
        self.name = name;
        data = image
    }
    init(name:String,image:UIImage,original:UIImage){
        orgininalImage = original
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
    
    func revertImage(){
      data = orgininalImage
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(data, forKey: Image.imageSaveName)
        aCoder.encode(name, forKey: Image.nameSaveName);
        aCoder.encode(info, forKey: Image.InfoSaveName);
        aCoder.encode(orgininalImage, forKey: Image.imageOriginalSaveName);
    }
    required convenience init?(coder aDecoder: NSCoder) {
        let img = aDecoder.decodeObject(forKey: Image.imageSaveName)
        let original = aDecoder.decodeObject(forKey: Image.imageOriginalSaveName)
        let nam = aDecoder.decodeObject(forKey: Image.nameSaveName)
        let inf = aDecoder.decodeObject(forKey: Image.InfoSaveName)
        if let img = img as? UIImage,let org = original as? UIImage,let name = nam as? String{
            self.init(name: name, image: img,original:org);
        }else{
            fatalError("UNABLE TO LOAD IMAGES");
        }
        if let inf = inf as? String{
            self.setInfo(inf)
        }
        
    }
    

    
    
    
}
