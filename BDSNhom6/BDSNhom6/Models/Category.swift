//
//  Category.swift
//  BDSNhom6
//
//  Created by Phat Tran on 12/2/17.
//  Copyright © 2017 Nhom 6 Estate. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Category
{
    var ID : Int;
    var Name : String;
    
    static func JsonToObject(json : JSON) -> Category
    {
        return Category(ID: json["ID"].intValue, Name: json["Name"].stringValue);
    }
    
    var dictionaryParams : [String : Any?]
    {
        return [
            "ID": ID,
            "Name": Name
        ];
    }
}
