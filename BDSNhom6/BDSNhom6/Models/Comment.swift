//
//  Comment.swift
//  BDSNhom6
//
//  Created by Phat Tran on 12/3/17.
//  Copyright © 2017 Nhom 6 Estate. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Comment {
    var ID : Int;
    var PostID : Int;
    var Name : String;
    var Message : String;
    var CreatedDate : Date;
    
    static func parseJsonToObject(jsonData : JSON) -> Comment
    {
        return Comment(ID: jsonData["ID"].intValue, PostID: jsonData["PostID"].intValue, Name: jsonData["Name"].stringValue, Message: jsonData["Message"].stringValue, CreatedDate: Common.getDate(dateString: jsonData["CreatedDate"].stringValue));
    }
    
    var dictionaryParams : [String : Any?]
    {
        return [
            "ID": ID,
            "PostID": PostID,
            "Name": Name,
            "Message": Message,
            "CreatedDate": Common.GetJSONDate(date: CreatedDate),
        ];
    }
}
