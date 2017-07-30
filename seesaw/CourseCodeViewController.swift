//
//  CourseCodeViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/29.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit

class CourseCodeViewController: UIViewController {

    @IBOutlet weak var codeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        codeLabel.layer.masksToBounds = true
        codeLabel.layer.cornerRadius = 10
        codeLabel.layer.borderColor = UIColor.init(colorWithHexValue: 0x5a99de).cgColor
        
        //let strCode = String(describing: currentCourseID)
        
        codeLabel.text = setCode(ID: currentCourseID!)

        // Do any additional setup after loading the view.
    }
    
    func setCode(ID: Int) -> String {
        let strID = String(ID)
        
        return strID
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

}
