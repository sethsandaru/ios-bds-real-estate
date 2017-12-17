//
//  PostInformationViewController.swift
//  BDSNhom6
//
//  Created by Phat Tran on 12/17/17.
//  Copyright © 2017 Nhom 6 Estate. All rights reserved.
//

import UIKit
import ImageSlideshow
import Kingfisher

class PostInformationViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var sliderIMG: ImageSlideshow!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UITextView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    //MARK: Configuration
    var post : Post? = nil;
    private let dateFormat : DateFormatter = DateFormatter();
    private let segueMapID = "PostMapViewController";
    private let segueCommentID = "CommentViewController";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard post != nil else {
            print("Post error");
            // show error message
            
            // pop to frontpage
            self.navigationController?.popViewController(animated: true);
            return;
        }
        
        // set date formatter
        dateFormat.dateFormat = "dd/MM/yyyy HH:mm";
        
        // config slider
        sliderIMG.backgroundColor = UIColor.white
        sliderIMG.slideshowInterval = 5.0
        sliderIMG.pageControlPosition = PageControlPosition.underScrollView
        sliderIMG.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        sliderIMG.pageControl.pageIndicatorTintColor = UIColor.black
        sliderIMG.contentScaleMode = UIViewContentMode.scaleAspectFit
        sliderIMG.activityIndicator = DefaultActivityIndicator();
        
        // gesture config for slider
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        sliderIMG.addGestureRecognizer(gestureRecognizer);
        
        // set info
        lblTitle.text = post?.Title;
        lblContent.text = post?.Content;
        lblDate.text = "Ngày đăng: " + dateFormat.string(from: (post?.CreatedDate)!);
        lblAddress.text = "Địa chỉ: " + (post?.Address)!;
        
        // source image for slider
        var sourceIMG : [KingfisherSource] = [KingfisherSource]();
        
        // slider IMG solving
        for img in (post?.Images)! {
            sourceIMG.append(KingfisherSource(url: URL(string: img.Path)!));
        }
        
        // add source to slider
        print("total imgs: \(sourceIMG.count) - \(post?.Images.count)")
        sliderIMG.setImageInputs(sourceIMG);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Slider fullscreen
    func didTap() {
        sliderIMG.presentFullScreenController(from: self)
    }

    //MARK: Menu item action (Show information)
    @IBAction func menuActionClick(_ sender: UIBarButtonItem) {
        present(Common.Notification(title: "Thông tin", mess: "Đăng bởi: \(post?.CreatedBy ?? "")\nSDT: \(post?.Phone ?? "")", okBtn: "Quay lại"), animated: true, completion: nil);
    }
    
    //MARK: Action when click phone
    @IBAction func btnPhoneClick(_ sender: UIButton) {
        callPhone(number: (post?.Phone)!);
    }
    
    
    //MARK: Action when click map
    @IBAction func btnMapClick(_ sender: UIButton) {
        // check if get fail
        guard let viewController : PostMapViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: segueMapID) as? PostMapViewController else {
            return;
        }
        
        // set data
        viewController.post = post;
        
        // send to navigation
        self.navigationController?.pushViewController(viewController, animated: true);
    }
    
    //MARK: Action when click Comment
    @IBAction func btnCommentClick(_ sender: UIButton) {
        // check if get fail
        guard let viewController : CommentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: segueCommentID) as? CommentViewController else {
            return;
        }
        
        // set data
        viewController.PostID = (post?.ID)!;
        
        // send to navigation
        self.navigationController?.pushViewController(viewController, animated: true);
    }
    
    //MARK: Phone call function
    private func callPhone(number : String)
    {
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
