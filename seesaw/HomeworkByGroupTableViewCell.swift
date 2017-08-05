//
//  HomeworkByGroupTableViewCell.swift
//  seesaw
//
//  Created by Ricardo on 2017/8/3.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit

class HomeworkByGroupTableViewCell: UITableViewCell {

    var getStar: Bool?
    @IBAction func starBtnClick(_ sender: Any) {
        
        if getStar == false {
            starBtn.setImage(UIImage(named: "star.png"), for: .normal)
            getStar = true
        } else{
            starBtn.setImage(UIImage(named: "emptystarImg.png"), for: .normal)
            getStar = false
        }
    }
    @IBOutlet weak var starBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        getStar = false
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
