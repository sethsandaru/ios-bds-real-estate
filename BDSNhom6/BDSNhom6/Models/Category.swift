//
//  Category.swift
//  BDSNhom6
//
//  Created by Phat Tran on 12/2/17.
//  Copyright © 2017 Nhom 6 Estate. All rights reserved.
//

import Foundation

struct Category
{
    var ID : Int;
    var Name : String;
    
    
    var dictionaryParams : [String : Any?]
    {
        return [
            "ID": ID,
            "Name": Name
        ];
    }
}
