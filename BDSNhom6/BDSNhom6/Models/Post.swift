//
//  Post.swift
//  BDSNhom6
//
//  Created by Phat Tran on 12/3/17.
//  Copyright © 2017 Nhom 6 Estate. All rights reserved.
//

import UIKit

struct Post
{
    var ID : Int;
    var CategoryID : Int;

    var Title : String;
    var Content : String;
    var Phone : String;
    var Address : String;
    var Latt : Double;
    var Long : Double;
    var CreatedDate : Date;
    var CreatedBy : String;
    var Activate : Bool;
    
    var Category : Category?;
    var Comments : [Comment]?;
    var Images : [Image];
    
    
    // parse json parameter
    var dictionaryParams : [String : Any?]
    {
        // solving images
        var imgs : [[String : Any?]] = [[String : Any?]]();
        for img in Images
        {
            imgs.append(img.dictionaryParams)
        }
        
        return [
            "ID": ID,
            "CategoryID": CategoryID,
            
            "Title": Title,
            "Content": Content,
            "Phone": Phone,
            "Address": Address,
            "Latt": Latt,
            "Long": Long,
            "CreatedDate": Common.GetJSONDate(date: CreatedDate),
            "CreatedBy": CreatedBy,
            "Activate": Activate,
            
            "Category": Category?.dictionaryParams,
            "Comments": "null",
            "Images": imgs,
        ];
    }
    
}
