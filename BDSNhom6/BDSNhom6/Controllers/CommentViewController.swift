//
//  CommentViewController.swift
//  BDSNhom6
//
//  Created by TIEN on 12/16/17.
//  Copyright © 2017 Nhom 6 Estate. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Properties
    @IBOutlet weak var tbComment: UITableView!
    
    //MARK: Configurations
    var Comments : [Comment] = [Comment]();
    var PostID : Int = 0;
    var Name : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard PostID > 0 else {
            print("PostID error");
            // show error message
            
            // pop to frontpage
            self.navigationController?.popViewController(animated: true);
            return;
        }

        // set delegate
        tbComment.dataSource = self
        tbComment.delegate = self
        
        // load data
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
    
    //MARK: Edit name
    @IBAction func btnEditClick(_ sender: UIBarButtonItem) {
        
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
        
        return cell
    }
    
    

}
