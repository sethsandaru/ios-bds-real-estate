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
    
    var pickerCate : UIPickerView = UIPickerView();
    var categoryID : Int = 0;
    
    //MARK: Image Picker Configuration
    let imagePicker = OpalImagePickerController()
    let maxiumPick = 5;
    
    //MARK: Other config
    let placeHolderContent = "Nội dung bài viết";
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate and config txtContent
        txtContent.delegate = self;
        txtContent.text = placeHolderContent;
        txtContent.textColor = UIColor.lightGray;
        txtContent.layer.borderWidth = 1.0;
        txtContent.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor;
        txtContent.layer.cornerRadius = 5.0;
        
        // config button radius
        btnIMG.layer.cornerRadius = 5.0;
        
        
        // image picker settings
        self.imagePicker.imagePickerDelegate = self;
        
        // slidershow settings
        sliderIMG.backgroundColor = UIColor.white
        sliderIMG.slideshowInterval = 5.0
        sliderIMG.pageControlPosition = PageControlPosition.underScrollView
        sliderIMG.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        sliderIMG.pageControl.pageIndicatorTintColor = UIColor.black
        sliderIMG.contentScaleMode = UIViewContentMode.scaleAspectFit
        sliderIMG.activityIndicator = DefaultActivityIndicator();
        
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
        var imgSource : [ImageSource] = [ImageSource]();
        
        for img in images {
            let src = ImageSource(image: img);
            imgSource.append(src);
        }
        
        sliderIMG.setImageInputs(imgSource);
        //sliderIMG.isHidden = false;
        //sliderIMG.frame = CGRect(x: 0, y: 0, width: sliderIMG.frame.width, height: 200)
        
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        //sliderIMG.isHidden = true;
        sliderIMG.setImageInputs([]);
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
        txtPhone.isHidden = !txtPhone.isHidden;
        print("isHidden:\(txtPhone.isHidden)")
    }
    
    //MARK: Common functions
    func stackViewUpdateSetHidden(order : Int, isHidden : Bool)
    {
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            DispatchQueue.main.async {  // UI updates on the main thread
                self.stackMain.arrangedSubviews[order].isHidden = isHidden
                print("Set hidden in order of \(order) with bool: \(isHidden)")
            }
        })
    }
    
    let data = ["", "ABC", "XYZ", "CCC"];
    
    //MARK: Picker solving
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count;
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryID = row;
        txtCategory.text = data[row];
    }
}
