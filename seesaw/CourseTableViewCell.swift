//
//  CourseTableViewCell.swift
//  seesaw
//
//  Created by Ricardo on 2017/8/3.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    @IBOutlet weak var homeworkDayLbl: UILabel!
    @IBOutlet weak var homeworkMonthLbl: UILabel!
    @IBOutlet weak var homeworkYearLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var sectionNumLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var contentText: UITextView!
    
    var sectionID:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
