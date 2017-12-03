//
//  Comment.swift
//  BDSNhom6
//
//  Created by Phat Tran on 12/3/17.
//  Copyright © 2017 Nhom 6 Estate. All rights reserved.
//

import UIKit

class Comment {
    var id : Int;
    var name : String;
    var email : String;
    var comment : String;
    var createdDate : Date;
    
    init(id : Int, name : String, email : String, comment : String, createdDate : Date) {
        self.id = id;
        self.name = name;
        self.comment = comment;
        self.email = email;
        self.createdDate = createdDate;
    }
}
