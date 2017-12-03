//
//  PostTableViewController.swift
//  BDSNhom6
//
//  Created by Phat Tran on 12/3/17.
//  Copyright © 2017 Nhom 6 Estate. All rights reserved.
//

import UIKit

class PostTableViewController: UITableViewController {
    var Posts : [Post] = [Post]();
    let dateFormatter = DateFormatter();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set format that we want to export
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
        dataInit();
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Posts.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell else
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Preparing Data
    private func dataInit()
    {
        guard let defaultIMG = UIImage.init(named: "defaultPost") else {
            fatalError("Image error");
        }
        var imgs = [UIImage]();
        imgs.append(defaultIMG);
        
        guard let post1 = Post.init(id: 1, title: "Bán nhà tại thủ đức", content: "Bán nhà tại quận thủ đức...", createdDate: Date(), createdBy: "Trần Khánh", activate: true, images: imgs) else {
            fatalError("Post1 Error");
        }
        
        guard let post2 = Post.init(id: 1, title: "Căn hộ Riverrun Side", content: "Mua ngay căn hộ đẹp nhất...", createdDate: Date(), createdBy: "Trần Khánh", activate: true, images: imgs) else {
            fatalError("Post1 Error");
        }
        
        guard let post3 = Post.init(id: 1, title: "Đất nền quận 9 giá tốt", content: "Liên hệ 090 xxx xxxx để biết thêm thông tin chi tiết,...", createdDate: Date(), createdBy: "Trần Khánh", activate: true, images: imgs) else {
            fatalError("Post1 Error");
        }
        
        Posts += [post1, post2, post3];
    }

}
