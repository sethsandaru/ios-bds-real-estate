//
//  HomeViewController.swift
//  BDSNhom6
//
//  Created by Phat Tran on 12/7/17.
//  Copyright © 2017 Nhom 6 Estate. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Properties
    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var tbPost: UITableView!
    
    //MARK: Configuration
    var Posts : [Post] = [Post]();
    let dateFormatter = DateFormatter();

    override func viewDidLoad() {
        super.viewDidLoad()

        // set date type
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
        dataInit();
        
        // set delegate
        tbPost.delegate = self;
        tbPost.dataSource = self;
        
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
        cell.lblTitle.text = row.title;
        cell.lblName.text = row.createdBy;
        cell.lblContent.text = row.content;
        cell.imgFeature.image = row.images[0];
        cell.lblDate.text = dateFormatter.string(from: row.createdDate);
        
        // okay
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Thông báo", message: "Đã chọn item tại row thứ: \(indexPath.row)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Preparing Data
    private func dataInit()
    {
        guard let defaultIMG = UIImage.init(named: "defaultPost") else {
            fatalError("Image error");
        }
        var imgs = [UIImage]();
        imgs.append(defaultIMG);
        
        guard let post1 = Post.init(id: 1, title: "Bán nhà tại thủ đức", content: "Bán nhà tại quận thủ đức...", createdDate: Date(), createdBy: "Administrator", activate: true, images: imgs) else {
            fatalError("Post1 Error");
        }
        
        guard let post2 = Post.init(id: 1, title: "Căn hộ Riverrun Side", content: "Mua ngay căn hộ đẹp nhất...", createdDate: Date(), createdBy: "Moderator", activate: true, images: imgs) else {
            fatalError("Post1 Error");
        }
        
        guard let post3 = Post.init(id: 1, title: "Đất nền quận 9 giá tốt", content: "Liên hệ 090 xxx xxxx để biết thêm thông tin chi tiết,...", createdDate: Date(), createdBy: "Staff", activate: true, images: imgs) else {
            fatalError("Post1 Error");
        }
        
        Posts += [post1, post2, post3];
    }
}
