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
    static let CameraTypeSaveName = "CameraTypeSaveName"
    
    static func < (lhs: Image, rhs: Image) -> Bool {
        return lhs.name < rhs.name;
    }
    
    
    var name:String = ""
    
    var data:UIImage!
    
    var imageView:UIImageView!
    
    var cameraName:String = ""
    
    private var info:String = "" // desciption of the photo
    
    
    override var description: String
    {
        return name;
    }
    
    
    init(image:UIImage){
        data = image
       super.init()
        setImageView()
    }
    init(name:String,image:UIImage){
        
        self.name = name;
        data = image
        super.init()
        setImageView()
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(data, forKey: Image.imageSaveName)
        aCoder.encode(name, forKey: "NAME");
        aCoder.encode(info, forKey: Image.InfoSaveName)
        aCoder.encode(cameraName, forKey: Image.CameraTypeSaveName)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        let img = aDecoder.decodeObject(forKey: Image.imageSaveName) as? UIImage
        let nam = aDecoder.decodeObject(forKey: Image.nameSaveName)
        let inf = aDecoder.decodeObject(forKey: Image.InfoSaveName)
        let cameraName = aDecoder.decodeObject(forKey: Image.CameraTypeSaveName) as? String
        if let img = img,let name = nam as? String{
            self.init(name: name, image: img);
        }else{
            self.init(image: img ?? UIImage())
        }
        if let inf = inf as? String{
            self.setInfo(inf)
        }
        if let cameraName = cameraName{
            self.setCameraType(cameraName)
        }
        
    }
    func setCameraType(_ str:String){
        cameraName = str;
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
    
    private func setImageView(){
        DispatchQueue.main.async {
            self.imageView = UIImageView(image: self.data)
            self.imageView.contentMode = .scaleAspectFill
        }
        
        
    }
    func delete(){
        data = nil
        imageView.removeFromSuperview()
        imageView = nil
    }
    
    
    
}
