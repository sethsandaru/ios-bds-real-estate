//
//  NewPostViewController.swift
//  BDSNhom6
//
//  Created by Phat Tran on 12/7/17.
//  Copyright © 2017 Nhom 6 Estate. All rights reserved.
//

import UIKit
import OpalImagePicker
import ImageSlideshow
import Alamofire
import SwiftyJSON
import FirebaseCore
import FirebaseStorage

class NewPostViewController: UIViewController, OpalImagePickerControllerDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    //MARK: Properties
    @IBOutlet weak var lblTitle: UITextField!
    @IBOutlet weak var lblName: UITextField!
    @IBOutlet weak var txtContent: UITextView!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var stackMain: UIStackView!
    @IBOutlet weak var sliderIMG: ImageSlideshow!
    @IBOutlet weak var btnIMG: UIButton!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    //MAKR: Configurations
    var pickerCate : UIPickerView = UIPickerView();
    var categoryID : Int = 0;
    var latt : Double = 0;
    var long : Double = 0;
    var Categories : [Category] = [Category]();
    var Images : [Image] = [Image]();
    var progressBarRatio : Float = 0;
    
    //MARK: Image Picker Configuration
    let imagePicker = OpalImagePickerController()
    let maxiumPick = 5;
    
    //MARK: Other config
    let placeHolderContent = "Nội dung bài viết";
    private let dateFormat : DateFormatter = DateFormatter(); // to format date
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // date format
        dateFormat.dateFormat = "dd_MM_yyyy_HH_mm_ss";
        
        // delegate and config txtContent
        txtContent.delegate = self;
        txtContent.text = placeHolderContent;
        txtContent.textColor = UIColor.lightGray;
        txtContent.layer.borderWidth = 1.0;
        txtContent.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor;
        txtContent.layer.cornerRadius = 5.0;
        
        // config button radius
        btnIMG.layer.cornerRadius = 5.0;
        btnMap.layer.cornerRadius = 5.0;
        
        
        // image picker settings
        self.imagePicker.imagePickerDelegate = self;
        imagePicker.maximumSelectionsAllowed = maxiumPick;
        imagePicker.allowedMediaTypes = Set([.image])
        imagePicker.navigationBar.tintColor = UIColor.white;
        imagePicker.navigationBar.barTintColor = UIColor(hexString: "#27ae60");
        imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white];
        let configuration = OpalImagePickerConfiguration()
        configuration.maximumSelectionsAllowedMessage = NSLocalizedString("Bạn không thể chọn quá \(maxiumPick) hình!", comment: "")
        configuration.navigationTitle = "Chọn hình ảnh";
        imagePicker.configuration = configuration

        
        // slidershow settings
        sliderIMG.backgroundColor = UIColor.white
        sliderIMG.slideshowInterval = 5.0
        sliderIMG.pageControlPosition = PageControlPosition.underScrollView
        sliderIMG.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        sliderIMG.pageControl.pageIndicatorTintColor = UIColor.black
        sliderIMG.contentScaleMode = UIViewContentMode.scaleAspectFit
        sliderIMG.activityIndicator = DefaultActivityIndicator();
        
        // data config
        Categories.removeFirst(); // Remove "Trang Chu"
        
        // load picker category
        pickerCate.delegate = self;
        pickerCate.dataSource = self;
        txtCategory.inputView = pickerCate;
        
        //sliderIMG.isHidden = true;
        
        // Do any additional setup after loading the view.
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

    //MARK: Images Picker and Process to show
    @IBAction func btnPictureClick(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        // get source
        var imgSource : [ImageSource] = [ImageSource]();
        
        // config progressbar
        progressBar.isHidden = false;
        progressBar.setProgress(0, animated: false);
        self.progressBarRatio = Float(1) / Float(images.count); // set ratio per finished
        
        Images.removeAll();
        // add and show to slide
        for img in images {
            let src = ImageSource(image: img);
            imgSource.append(src);
            
            // upload to firebase
            uploadImage(image: img);
            
            // add source
            //Images.append(Image(ID: 0, PostID: 0, Path: Common.IMGToBase64(img: img)));
        }
        
        sliderIMG.setImageInputs(imgSource);
        //sliderIMG.isHidden = false;
        //sliderIMG.frame = CGRect(x: 0, y: 0, width: sliderIMG.frame.width, height: 200)
        
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        //sliderIMG.isHidden = true;
        sliderIMG.setImageInputs([]);
        progressBar.isHidden = true;
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: TextView Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtContent.textColor == UIColor.lightGray {
            txtContent.text = ""
            txtContent.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtContent.text == "" {
            txtContent.text = placeHolderContent
            txtContent.textColor = UIColor.lightGray
        }
    }
    
    //MARK: Save changes
    @IBAction func menuSave(_ sender: UIBarButtonItem) {
        // check du lieu
        let title = lblTitle.text;
        if title?.isEmpty == true
        {
            present(Common.Notification(title: "Lỗi", mess: "Xin hãy nhập tiêu đề", okBtn: "Ok"), animated: true, completion: nil)
            return;
        }
        
        let content = txtContent.text;
        if content?.isEmpty == true
        {
            present(Common.Notification(title: "Lỗi", mess: "Xin hãy nhập nội dung bài viết", okBtn: "Ok"), animated: true, completion: nil)
            return;
        }
        
        let name = lblName.text;
        if name?.isEmpty == true
        {
            present(Common.Notification(title: "Lỗi", mess: "Xin hãy nhập tên của bạn", okBtn: "Ok"), animated: true, completion: nil)
            return;
        }
        
        let address = txtAddress.text;
        if address?.isEmpty == true
        {
            present(Common.Notification(title: "Lỗi", mess: "Xin hãy nhập địa chỉ", okBtn: "Ok"), animated: true, completion: nil)
            return;
        }
        
        let phone = txtPhone.text;
        if phone?.isEmpty == true
        {
            present(Common.Notification(title: "Lỗi", mess: "Xin hãy nhập số điện thoại của bạn", okBtn: "Ok"), animated: true, completion: nil)
            return;
        }
        
        if categoryID == 0 {
            present(Common.Notification(title: "Lỗi", mess: "Xin hãy chọn danh mục", okBtn: "Ok"), animated: true, completion: nil)
            return;
        }
        
        if sliderIMG.images.count <= 0 {
            present(Common.Notification(title: "Lỗi", mess: "Xin hãy chọn ít nhất 1 tấm hình", okBtn: "Ok"), animated: true, completion: nil)
            return;
        }
        
        if progressBar.progress < 1.0 {
            present(Common.Notification(title: "Lỗi", mess: "Xin hãy đợi quá trình upload hình hoàn tất!", okBtn: "Ok"), animated: true, completion: nil)
            return;
        }
        
        // new object
        var newPost = Post(ID: 0, CategoryID: categoryID, Title: title!, Content: content!, Phone: phone!, Address: address!, Latt: latt, Long: long, CreatedDate: Date(), CreatedBy: name!, Activate: false, Category: nil, Comments: nil, Images: Images);
        
        // set controller and get URL
        Common.SetController(controller: .Post);
        let URL = Common.GetActionURL(Action: "AddOrUpdate");
        
        // send request
        Alamofire.request(URL, method: .post, parameters: newPost.dictionaryParams, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    let result = JSON(response.result.value);
                    
                    print("Result posting: \(result) - \(result.intValue)")
                    
                    if result.intValue > 0 {
                        // success
                        let alert = UIAlertController(title: "Thành công", message: "Bạn đã đăng bài viết thành công. Sẽ có kiểm duyệt viên xét duyệt bài của bạn trong thời gian ngắn. Xin cám ơn!", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "Quay về trang chủ", style: UIAlertActionStyle.destructive, handler: {
                            action in
                            
                            // back to front page
                            self.navigationController?.popViewController(animated: true);
                        }));
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        // failed
                        self.present(Common.Notification(title: "Thất bại", mess: "Đăng bài không thành công! Xin hãy thử lại!", okBtn: "Ok"), animated: true, completion: nil);
                    }
                }
                break
                
            case .failure(_):
                print(response.result.error)
                self.present(Common.Notification(title: "Thất bại", mess: "Không thể đăng bài, xin hãy thử lại sau!", okBtn: "Ok"), animated: true, completion: nil);
                break
                
            }
        }
    }
    
    
    //MARK: Picker category solving
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Categories.count;
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Categories[row].Name;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryID = Categories[row].ID;
        txtCategory.text = Categories[row].Name;
        txtCategory.resignFirstResponder();
        pickerView.resignFirstResponder();
    }
    
    //MARK: Solving unwind
    @IBAction func unWindMapSelected(sender : UIStoryboardSegue)
    {
        if let source = sender.source as? NewPostMapViewController, let coord = source.coord {
            // set coord
            self.latt = Double(coord.latitude);
            self.long = Double(coord.longitude);
            
            print("Chon map thanh cong: \(latt) - \(long)");
            
            // notify
            //let alert = Common.Notification(title: "Thành công", mess: "Bạn đã chọn địa điểm thành công trên map, bạn có thể chọn lại nếu muốn!", okBtn: "Tiếp tục đăng bài")
            //self.present(alert, animated: true, completion: nil)
            
            let alert = UIAlertView()
            alert.title = "Thành công"
            alert.message = "Bạn đã chọn địa điểm thành công trên map, bạn có thể chọn lại nếu muốn!"
            alert.addButton(withTitle: "Tiếp tục đăng bài")
            alert.show()
        }
    }
    
    //MARK: Firebase Upload Image
    private func uploadImage(image: UIImage) {
        // name
        let nowDate = Date();
        let randomName = Common.RandomString(length: 10);
        
        // preparing data
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        
        // declare upload
        let uploadRef = Storage.storage().reference().child("Posts/\(dateFormat.string(from: nowDate))_\(randomName.MD5)_SethPhat.jpg")
        
        // upload now
        uploadRef.putData(imageData!, metadata: nil) { metadata,
            error in
            if error == nil {
                // tang progress
                DispatchQueue.main.async { [unowned self] in
                    self.progressBar.setProgress(self.progressBar.progress + self.progressBarRatio, animated: true);
                }
                
                print("Upload hinh thanh cong: \(self.progressBar.progress) - Ratio: \(self.progressBarRatio)")

                
                // add to list img
                self.Images.append(Image(ID: 0, PostID: 0, Path: (metadata?.downloadURL()?.absoluteString)!));
            }
            // ko thanh cong thi thui :D
        }
    }
}
