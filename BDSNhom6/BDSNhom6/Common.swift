//
//  Common.swift
//  BDSNhom6
//
//  Created by Phat Tran on 12/12/17.
//  Copyright © 2017 Nhom 6 Estate. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class Common
{
    public static let URLApi : String = "http://nhom6bdsapi.sethphat.com/api/";
    public static var NowController : Controller = .Post;
    
    //MARK: UIImage to Base64 STR
    public static func IMGToBase64(img : UIImage) -> String
    {
        let data : NSData = UIImagePNGRepresentation(img)! as NSData;
        return data.base64EncodedString(options: .lineLength64Characters);
    }
    
    //MARK: Base64 STR to UIImage
    public static func Base64ToIMG(str : String) -> UIImage
    {
        let data : Data = Data(base64Encoded: str, options: .ignoreUnknownCharacters)!;
        return UIImage(data: data)!;
    }
    
    //MARK: Set controller
    public static func SetController(controller : Controller)
    {
        NowController = controller;
    }
    
    //MARK: Get URL API
    public static func GetActionURL(Action : String) -> String
    {
        return URLApi + NowController.rawValue + "/" + Action;
    }

    //MARK: Alert dialog
    public static func Notification(title : String, mess : String, okBtn : String) -> UIAlertController
    {
        let alert = UIAlertController(title: title, message: mess, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: okBtn, style: UIAlertActionStyle.default, handler: nil))
        
        return alert
    }
    
    //MARK: Parse Date from String
    public static func getDate(dateString:String) -> Date {
        
        
        var dateFormatter = DateFormatter()
        
        if(dateString.characters.count == 19)
        {
            dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss" //This is the format returned by .Net website
        }
        else if(dateString.characters.count == 21)
        {
            dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.S" //This is the format returned by .Net website
        }
        else if(dateString.characters.count == 22)
        {
            dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SS" //This is the format returned by .Net website
        }
        else if(dateString.characters.count == 23)
        {
            dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSS"
        }
        
        let date = dateFormatter.date(from: dateString);
        
        
        return date!;
        
    }

}

//MARK: Controller name
enum Controller : String {
    case Post = "Post";
    case Comment = "Comment";
    case Category = "Category";
    case Upload = "Upload";
}

extension JSON {
    public var date: Date? {
        get {
            if let str = self.string {
                return JSON.jsonDateFormatter.date(from: str)
            }
            return nil
        }
    }
    
    private static let jsonDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        return dateFormatter
    }()
}
