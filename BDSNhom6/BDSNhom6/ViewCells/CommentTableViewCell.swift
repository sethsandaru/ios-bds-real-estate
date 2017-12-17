//
//  CommentTableViewCell.swift
//  BDSNhom6
//
//  Created by TIEN on 12/16/17.
//  Copyright © 2017 Nhom 6 Estate. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblComment: UITextView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
