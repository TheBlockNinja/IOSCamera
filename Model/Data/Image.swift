//
//  Image.swift
//  Camera
//
//  Created by Seann Moser & Theodore Holden on 11/5/18.
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
    
    var data:UIImage!
    
    var imageView:UIImageView!
    
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

    required convenience init?(coder aDecoder: NSCoder) {
        let img = aDecoder.decodeObject(forKey: Image.imageSaveName) as? UIImage
        let nam = aDecoder.decodeObject(forKey: Image.nameSaveName)
        let inf = aDecoder.decodeObject(forKey: Image.InfoSaveName)
        if let img = img,let name = nam as? String{
            self.init(name: name, image: img);
        }else{
            self.init(image: img ?? UIImage())
        }
        if let inf = inf as? String{
            self.setInfo(inf)
        }

        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(data, forKey: Image.imageSaveName)
        aCoder.encode(name, forKey: "NAME");
        aCoder.encode(info, forKey: Image.InfoSaveName)
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
    
    func delete(){
        data = nil
        imageView.removeFromSuperview()
        imageView = nil
    }
    
    private func setImageView(){
        DispatchQueue.main.async {
            self.imageView = UIImageView(image: self.data)
            self.imageView.contentMode = .scaleAspectFill
       }
        
        
    }

    
    
    
}
