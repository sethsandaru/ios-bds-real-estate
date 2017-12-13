//
//  Comment.swift
//  BDSNhom6
//
//  Created by Phat Tran on 12/3/17.
//  Copyright © 2017 Nhom 6 Estate. All rights reserved.
//

import UIKit

struct Comment {
    var ID : Int;
    var PostID : String;
    var Name : String;
    var Message : String;
    var CreatedDate : Date;
    
    var Post : Post;
}
