//
//  CommentViewController.swift
//  BDSNhom6
//
//  Created by TIEN on 12/16/17.
//  Copyright © 2017 Nhom 6 Estate. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Properties
    @IBOutlet weak var tbComment: UITableView!
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    //MARK: Configurations
    var Comments : [Comment] = [Comment]();
    var PostID : Int = 0;
    var Name : String = ""
    let dateFormat : DateFormatter = DateFormatter();
    
    //MARK: Loading config
    /// View which contains the loading text and the spinner
    let loadingView = UIView()
    
    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    
    /// Text shown during load the TableView
    let loadingLabel = UILabel()
    
    // refresh control
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard PostID > 0 else {
            print("PostID error");
            // show error message
            
            // pop to frontpage
            self.navigationController?.popViewController(animated: true);
            return;
        }
        
        // format date
        dateFormat.dateFormat = "dd/MM/yyyy HH:mm";
        
        // settings
        txtComment.layer.borderWidth = 1.0;
        txtComment.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor;
        txtComment.layer.cornerRadius = 5.0;

        // set delegate
        tbComment.dataSource = self
        tbComment.delegate = self
        
        // refresh control init
        // refresh init
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Vuốt lên để refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tbComment.addSubview(refreshControl)
        
        // load data
        setLoadingScreen()
        dataInit()
        
        // keyboard fixing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
    // kéo lên để refresh
    func refresh(sender:AnyObject) {
        print("Đã kéo lên")
        // set lai title
        refreshControl.attributedTitle = NSAttributedString(string: "Đang refresh lại...");
        
        // clear and get again
        Comments.removeAll();
        dataInit();
    }
    
    //MARK: Edit name
    @IBAction func btnEditClick(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Chỉnh sửa tên", message: "Hãy nhập tên để có thể bình luận", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Lưu lại", style: .default, handler: {
            alert -> Void in
            let nameField = alertController.textFields![0] as UITextField
            
            if nameField.text?.isEmpty == false {
                // sua ten
                self.Name = nameField.text!;
                
                // bat comment
                self.txtComment.isEditable = true;
                self.txtComment.isSelectable = true;
                self.btnSubmit.isEnabled = true;
                self.txtComment.text = "";
            } else {
                let errorAlert = UIAlertController(title: "Lỗi", message: "Xin hãy nhập họ tên của bạn", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                    alert -> Void in
                    self.present(alertController, animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Quay lại", style: .destructive, handler: nil));
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Họ và tên của bạn"
            textField.textAlignment = NSTextAlignment.left;
        })
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Submit comment
    @IBAction func btnCommentClick(_ sender: UIButton) {
        txtComment.resignFirstResponder();
        
        // kiem tra dieu kien
        if (Name.isEmpty == true)
        {
            self.present(Common.Notification(title: "Lỗi", mess: "Xin hãy nhập tên trước khi comment!", okBtn: "Quay lại"), animated: true, completion: nil)
            return;
        }
        
        if (txtComment.text.isEmpty == true)
        {
            self.present(Common.Notification(title: "Lỗi", mess: "Xin hãy nhập bình luận", okBtn: "Quay lại"), animated: true, completion: nil)
            return;
        }
        
        // set false de tranh user click many time...
        btnSubmit.isEnabled = false;
        
        // bat loading
        startLoadingScreen();
        
        // start to comment
        let cmt = Comment(ID: 0, PostID: PostID, Name: Name, Message: txtComment.text, CreatedDate: Date());
        
        // get URL
        Common.SetController(controller: .Comment);
        let URL = Common.GetActionURL(Action: "AddComment");
        
        // send request
        Alamofire.request(URL, method: .post, parameters: cmt.dictionaryParams, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    let result = JSON(response.result.value);
                    
                    print("Result CmtID: \(result) - \(result.intValue)")
                    
                    if result.intValue > 0 {
                        // success
                        self.txtComment.text = "";
                        self.Comments.append(cmt);
                        self.tbComment.reloadData();
                    }
                    else {
                        // failed
                        self.present(Common.Notification(title: "Thất bại", mess: "Đăng bình luận không thành công! Xin hãy thử lại!", okBtn: "Ok"), animated: true, completion: nil);
                    }
                }
                break
                
            case .failure(_):
                print(response.result.error)
                self.present(Common.Notification(title: "Thất bại", mess: "Không thể đăng bình luận, xin hãy thử lại sau!", okBtn: "Ok"), animated: true, completion: nil);
                break
                
            }
            
            // open again
            self.btnSubmit.isEnabled = true;
            self.removeLoadingScreen();
        }
    }
    
    //MARK: TableView solving
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell else {
            fatalError("Error from Comment Table View Cell");
        }
        
        // row item
        let row = Comments[indexPath.row];
        
        // set data
        cell.lblComment.text = row.Message;
        cell.lblName.text = row.Name;
        cell.lblDate.text = dateFormat.string(from: row.CreatedDate);
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        txtComment.resignFirstResponder();
    }
    
    //MARK: Data init
    private func dataInit()
    {
        // get URL
        Common.SetController(controller: .Comment);
        let URL = Common.GetActionURL(Action: "GetAllCommentByPostID") + "?PostID=\(PostID)";
        
        // API calling
        
        Alamofire.request(URL).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    // parse json
                    let JsonData = JSON(response.result.value!);
                    
                    // fetch all posts in this
                    for (_, dict) in JsonData
                    {
                        // add to array
                        self.Comments.append(Comment.parseJsonToObject(jsonData: dict));
                    }
                    
                    print("Get comment is done, total: \(self.Comments.count)");
                    self.tbComment.reloadData();
                }
                break
                
            case .failure(_):
                print(response.result.error)
                self.present(Common.Notification(title: "Lỗi", mess: "Lấy comment thất bại, xin hãy thử lại sau!", okBtn: "Quay lại"), animated: true, completion: nil)
                
                break
                
            }
            
            // tat refresh khi xong
            self.refreshControl.endRefreshing()
            
            // set lai title
            self.refreshControl.attributedTitle = NSAttributedString(string: "Vuốt lên để refresh");
            
            // tat loading
            self.removeLoadingScreen();
        }
    }
    
    //MARK: Loading indicators
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (self.view.frame.width / 2) - (width / 2)
        let y = (self.view.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets loading text
        loadingLabel.textColor = .black
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Đang tải..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        // Sets spinner
        spinner.color = .black;
        spinner.activityIndicatorViewStyle = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        
        self.tbComment.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        
        // set
        tbComment.alpha = 1;
    }
    
    private func startLoadingScreen()
    {
        spinner.startAnimating();
        spinner.isHidden = false;
        loadingLabel.isHidden = false;
        
        // set
        tbComment.alpha = 0.3
        loadingView.alpha = 1;
        spinner.alpha = 1;
        loadingLabel.alpha = 1;
    }
    
    //MARK: Toggle keyboard function
    func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardFrame : CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.view.frame.origin.y = -(keyboardFrame.size.height + 10)
        })
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
}
