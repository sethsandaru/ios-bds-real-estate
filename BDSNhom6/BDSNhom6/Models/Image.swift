//
//  Image.swift
//  BDSNhom6
//
//  Created by Phat Tran on 12/12/17.
//  Copyright © 2017 Nhom 6 Estate. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Image
{
    var ID : Int;
    var PostID : Int;
    var Path : String;
    
    static func ImagesFromJsonArray(jsonArr : JSON) -> [Image]
    {
        var imgs = [Image]();
        for (_, dict) in jsonArr {
            imgs.append(Image(ID: dict["ID"].intValue, PostID: dict["PostID"].intValue, Path: dict["Path"].stringValue))
        }
        
        return imgs;
    }
    
    // object => json parameter helper
    var dictionaryParams : [String : Any?]
    {
        return [
            "ID": ID,
            "PostID": PostID,
            "Path": Path,
        ];
    }
}
