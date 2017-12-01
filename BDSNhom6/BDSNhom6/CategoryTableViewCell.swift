//
//  CategoryTableViewCell.swift
//  BDSNhom6
//
//  Created by Phat Tran on 12/2/17.
//  Copyright © 2017 Nhom 6 Estate. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var lblName: UILabel!
    
    //MARK: Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
