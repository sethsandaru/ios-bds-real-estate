//
//  Post.swift
//  BDSNhom6
//
//  Created by Phat Tran on 12/3/17.
//  Copyright © 2017 Nhom 6 Estate. All rights reserved.
//

import UIKit

class Post
{
    var id : Int;
    var title : String;
    var content : String;
    var createdDate : Date;
    var createdBy : String;
    var activate : Bool;
    var images : [UIImage];
    
    init?(id : Int, title : String, content : String, createdDate : Date, createdBy : String, activate : Bool, images : [UIImage]) {
        
        if (images.count <= 0)
        {
            return nil;
        }
        
        self.id = id;
        self.title = title;
        self.content = content;
        self.createdBy = createdBy;
        self.createdDate = createdDate;
        self.activate = activate;
        self.images = images;
    }
}
