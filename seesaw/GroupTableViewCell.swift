//
//  GroupTableViewCell.swift
//  seesaw
//
//  Created by Ricardo on 2017/8/2.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var memberBtn: UIButton!
    @IBOutlet weak var groupNumLbl: UILabel!
    
    var groupID:Int?
    
//    @IBAction func groupMemBtnClick(_ sender: Any) {
//        print(groupID)
//        
//        
//        
//    }
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
