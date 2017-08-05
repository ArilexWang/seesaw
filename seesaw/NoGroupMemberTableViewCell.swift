//
//  NoGroupMemberTableViewCell.swift
//  seesaw
//
//  Created by Ricardo on 2017/8/2.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit

class NoGroupMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var memberEmailLbl: UILabel!
    @IBOutlet weak var memberNameLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
