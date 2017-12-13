//
//  PostTableViewCell.swift
//  BDSNhom6
//
//  Created by Phat Tran on 12/3/17.
//  Copyright © 2017 Nhom 6 Estate. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    //MARK: Properties
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgFeature: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UITextView!
    @IBOutlet weak var lblCategory: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
