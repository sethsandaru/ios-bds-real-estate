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
import os

class Common
{
    // URL api
    enum ApiURL : String {
        case UrlLive = "http://nhom6bdsapi.sethphat.com/api/";
        case UrlLocal = "http://192.168.1.90:62549/api/";
    }
    
    public static let URLApi : ApiURL = .UrlLive;
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
        return URLApi.rawValue + NowController.rawValue + "/" + Action;
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
    
    //MARK: Parse Date to JSON
    public static func GetJSONDate(date : Date) -> String {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return dateFormatter.string(from: date);
    }
    
    //MARK: Random String
    public static func RandomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    //MARK: Hash MD5
    public static func MD5(string: String) -> Data {
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        return digestData
    }

}

//MARK: Controller name
enum Controller : String {
    case Post = "Post";
    case Comment = "Comment";
    case Category = "Category";
    case Upload = "Upload";
}

//MARK: UIImageView load URL
extension UIImageView {
    public func image(fromUrl urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Couldn't create URL from: \(urlString)")
            return
        }
        let theTask = URLSession.shared.dataTask(with: url) {
            data, response, error in
            if let response = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: response)
                }
            }
        }
        theTask.resume()
    }
}

//MARK: Extension to convert String => MD5
extension String{
    var MD5:String {
        get{
            let messageData = self.data(using:.utf8)!
            var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
            
            _ = digestData.withUnsafeMutableBytes {digestBytes in
                messageData.withUnsafeBytes {messageBytes in
                    CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
                }
            }
            
            return digestData.map { String(format: "%02hhx", $0) }.joined()
        }
    }
}

//MARK: Extension color hex => UIColor
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

//MAKR: Extension to close keyboard
// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: Loading Footer

extension UITableView {
    
    func showLoadingFooter(){
        let loadingFooter = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingFooter.frame.size.height = 50
        loadingFooter.hidesWhenStopped = true
        loadingFooter.startAnimating()
        tableFooterView = loadingFooter
    }
    
    func hideLoadingFooter(){
        let tableContentSufficentlyTall = (contentSize.height > frame.size.height)
        let atBottomOfTable = (contentOffset.y >= contentSize.height - frame.size.height)
        if atBottomOfTable && tableContentSufficentlyTall {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentOffset.y = self.contentOffset.y - 50
            }, completion: { finished in
                self.tableFooterView = UIView()
            })
        } else {
            self.tableFooterView = UIView()
        }
    }
    
    func isLoadingFooterShowing() -> Bool {
        return tableFooterView is UIActivityIndicatorView
    }
    
}
