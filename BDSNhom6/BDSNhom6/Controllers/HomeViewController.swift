//
//  HomeViewController.swift
//  BDSNhom6
//
//  Created by Phat Tran on 12/7/17.
//  Copyright © 2017 Nhom 6 Estate. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SideMenu
import Dropdowns
import Kingfisher

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    //MARK: Properties
    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var tbPost: UITableView!
    
    //MARK: Configuration
    var Posts : [Post] = [Post]();
    var Categories : [Category] = [Category]();
    let dateFormatter = DateFormatter();
    var perPage = 10;
    var nowPage = 1;
    var skip = 0;
    var totalItem = 0;
    var keyword : String = "";
    var nowCategory : Int? = nil;
    var isCategorying : Bool = true;
    private let segueAddID : String = "NewPostViewController";
    private let seguePostID : String = "PostInformationViewController";
    private let appTitle : String = "Nhóm 6 Estate";
    
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

        // set date type
        setLoadingScreen();
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        // init data
        dataInit(keyword: keyword, categoryID: nowCategory);
        getCategories();
        
        // set delegate
        tbPost.delegate = self;
        tbPost.dataSource = self;
        txtSearch.delegate = self;
        
        // refresh init
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Vuốt lên để refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tbPost.addSubview(refreshControl)
        
        // add trang chu
        self.Categories.append(Category(ID: 0, Name: "Trang chủ"));
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
    
    //MARK: TableView Solving...
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Posts.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbPost.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell else
        {
            fatalError("TableView got an error at row: \(indexPath.row)");
        }
        
        // get row data
        let row = Posts[indexPath.row];
        
        // set data
        cell.lblTitle.text = row.Title;
        cell.lblName.text = row.CreatedBy;
        cell.lblContent.text = row.Content;
        //cell.imgFeature.image = Common.Base64ToIMG(str: row.Images[0].Path);
        //cell.imgFeature.image(fromUrl: row.Images[0].Path)
        cell.imgFeature.kf.setImage(with: URL(string: row.Images[0].Path));
        cell.lblDate.text = dateFormatter.string(from: row.CreatedDate);
        cell.lblCategory.text = "Loại: " + row.Category!.Name;
        
        // okay
        return cell
    }
    
    // Chuyển qua trang bài viết khi dc click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        txtSearch.resignFirstResponder()
        
        // check if get fail
        guard let viewController : PostInformationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: seguePostID) as? PostInformationViewController else {
            return;
        }
        
        // set data
        viewController.post = Posts[indexPath.row];
        
        // send to navigation
        self.navigationController?.pushViewController(viewController, animated: true);
    }
    
    // Load more khi tận cùng
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let last = Posts.count - 1;
        
        if last == indexPath.row && Posts.count < totalItem && spinner.isHidden == true
        {
            //get more here
            skip = skip + perPage;
            
            // get and no clear anything because get more =.=
            dataInit(keyword: keyword, categoryID: nowCategory);
        }
    }
    
    // kéo lên để refresh
    func refresh(sender:AnyObject) {
        print("Đã kéo lên")
        // set lai title
        refreshControl.attributedTitle = NSAttributedString(string: "Đang refresh lại...");
        
        // re config data
        skip = 0;
        
        // clear and get again
        Posts.removeAll();
        dataInit(keyword: keyword, categoryID: nowCategory);
        
        // tat refresh khi xong
        refreshControl.endRefreshing()
        
        // set lai title
        refreshControl.attributedTitle = NSAttributedString(string: "Vuốt lên để refresh");
    }
    
    
    @IBAction func menuClick(_ sender: UIBarButtonItem) {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuInfoViewController")
        {
            let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: controller);
            SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController;

            present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtSearch.resignFirstResponder()
    }
    
    //MARK: Search bar action
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // hide keyboard
        txtSearch.resignFirstResponder();
        
        if (txtSearch!.text?.isEmpty == true)
        {
            let alert = UIAlertController(title: "Lỗi", message: "Xin hãy nhập từ khóa trước khi tìm", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Tôi biết rồi", style: UIAlertActionStyle.default, handler: nil));
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        // set keyword
        keyword = txtSearch.text!;
        
        // start to search
        Posts.removeAll(); // remove all post before search
        dataInit(keyword: keyword, categoryID: nowCategory);
        
        
    }
    
    //MARK: Preparing Data

    private func dataInit(keyword : String, categoryID : Int?)
    {
        // set loading
        startLoadingScreen();
        tbPost.alpha = 0.4;
        
        // preparing API
        Common.SetController(controller: .Post);
        var URL : String = "";
        
        if (categoryID != nil)
        {
            URL = Common.GetActionURL(Action: "GetByPaginate") + "?keyword=\(keyword)&categoryID=\(categoryID!)&activate=true&take=\(perPage)&skip=\(skip)";
        }
        else {
            URL = Common.GetActionURL(Action: "GetByPaginate") + "?keyword=\(keyword)&categoryID=&activate=true&take=\(perPage)&skip=\(skip)";
        }
        
        // GET Post
        Alamofire.request(URL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    // parse json
                    var JsonData = JSON(response.result.value!);
                    
                    // set total
                    self.totalItem = JsonData["Total"].intValue;
                    
                    if (self.totalItem > 0) {
                        // fetch all posts in this
                        for (index, dict) in JsonData["Data"]
                        {
                            var thisPost = Post(ID: dict["ID"].intValue,
                                                CategoryID: dict["CategoryID"].intValue,
                                                Title: dict["Title"].stringValue,
                                                Content: dict["Content"].stringValue,
                                                Phone: dict["Phone"].stringValue,
                                                Address: dict["Address"].stringValue,
                                                Latt: dict["Latt"].doubleValue,
                                                Long: dict["Long"].doubleValue,
                                                CreatedDate: Common.getDate(dateString: dict["CreatedDate"].stringValue),
                                                CreatedBy: dict["CreatedBy"].stringValue,
                                                Activate: dict["Activate"].boolValue,
                                                Category: Category(ID: dict["Category"]["ID"].intValue, Name: dict["Category"]["Name"].stringValue),
                                                Comments: nil,
                                                Images: [Image]());
                            
                            // Lay ra 1 tam hinh duy nhat
                            for (i2, d2) in dict["Images"] {
                                thisPost.Images.append(Image(ID: d2["ID"].intValue, PostID: d2["PostID"].intValue, Path: d2["Path"].stringValue))
                            }
                            
                            // add to array
                            self.Posts.append(thisPost);
                        }
                    }
                    
                    // need to reload before see it
                    self.tbPost.reloadData();
                    self.tbPost.alpha = 1;
                }
                break
                
            case .failure(_):
                let alert = UIAlertController(title: "Lỗi", message: "Lấy dữ liệu bài viết từ máy chủ thất bại, lỗi: \(response.result.error) !", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Tôi biết rồi", style: UIAlertActionStyle.default, handler: { (hander) in
                    //fatalError("Không lấy được dữ liệu");
                }));
                self.present(alert, animated: true, completion: nil)
                break
                
            }
            
            self.removeLoadingScreen();
            
        }
        
    }
    
    // Lay tat ca danh muc len
    func getCategories()
    {
        // preparing API
        Common.SetController(controller: .Category);
        let URL : String = Common.GetActionURL(Action: "GetAll");
        
        Alamofire.request(URL).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    // parse json
                    var JsonData = JSON(response.result.value!);
                    
                    // fetch all posts in this
                    for (index, dict) in JsonData
                    {
                        let thisCate = Category(ID: dict["ID"].intValue, Name: dict["Name"].stringValue);
                        
                        // add to array
                        self.Categories.append(thisCate);
                    }
                    
                    print("Get categories is done, total: \(self.Categories.count)");
                    
                    // afterward action
                    self.isCategorying = false;
                    self.initNavigation();
                }
                break
                
            case .failure(_):
                print(response.result.error)
                break
                
            }
            
            self.isCategorying = false;
        }
    }
    
    //MARK: Init the navigation controller
    private func initNavigation()
    {
        var items = [String]();
        
        for item in Categories {
            items.append(item.Name);
        }
        
        //config background color rgba(46, 204, 113,1.0)
        Config.List.backgroundColor = UIColor(hexString: "#3498db");
        Config.List.DefaultCell.Text.color = UIColor.white;
        Config.ArrowButton.Text.color = UIColor.white;

        // set title view
        let titleView = TitleView(navigationController: navigationController!, title: appTitle, items: items);
        
        // action when choose category
        titleView?.action = { [weak self] index in
            let cate = self?.Categories[index];
            
            if (cate?.ID == 0)
            {
                self?.nowCategory = nil
            }
            else {
                // set category and reload data
                self?.nowCategory = cate?.ID;
            }
            
            // get data
            self?.Posts.removeAll(); // remove all post before search
            self?.dataInit(keyword: "", categoryID: self?.nowCategory);
        }
        
        navigationItem.titleView = titleView
    }
    
    
    @IBAction func menuAddClick(_ sender: UIBarButtonItem) {
        if (isCategorying == true)
        {
            self.present(Common.Notification(title: "Lỗi", mess: "Đang lấy dữ liệu, xin vui lòng đợi...", okBtn: "Quay lại"), animated: true, completion: nil);
            return;
        }
        
        guard let viewController : NewPostViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: segueAddID) as? NewPostViewController else {
            return;
        }
        
        // set data
        viewController.Categories = self.Categories;

        // send to navigation
        self.navigationController?.pushViewController(viewController, animated: true);
        
        //performSegue(withIdentifier: segueAddID, sender: sender)

    }
    
    //MARK: Loading indicators
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (self.tbPost.frame.width / 2) - (width / 2)
        let y = (self.tbPost.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
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
        
        self.tbPost.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        
    }
    
    private func startLoadingScreen()
    {
        spinner.startAnimating();
        spinner.isHidden = false;
        loadingLabel.isHidden = false;
    }
    
}
