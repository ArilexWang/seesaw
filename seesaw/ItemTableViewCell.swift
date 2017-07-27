//
//  ItemTableViewCell.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/26.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemOwner: UILabel!
    @IBOutlet weak var itemImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
