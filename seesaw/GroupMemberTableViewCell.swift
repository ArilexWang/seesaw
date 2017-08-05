//
//  GroupMemberTableViewCell.swift
//  seesaw
//
//  Created by Ricardo on 2017/8/2.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit

class GroupMemberTableViewCell: UITableViewCell {
    @IBOutlet weak var memberNameLbl: UILabel!
    @IBOutlet weak var memberEmailLbl: UILabel!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
