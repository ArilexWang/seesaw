//
//  TeacherSignViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/22.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit

class TeacherSignViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setButton()
        // Do any additional setup after loading the view.
    }
    
    func setButton(){
        let closeButton = UIButton.init(type: .custom)
        
        closeButton.setImage(UIImage(named: "closeImg.png"), for: UIControlState.normal)
        
        closeButton.addTarget(self, action: #selector(TeacherSignViewController.closeBtnClick), for: UIControlEvents.touchUpInside)
        
        closeButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        
        self.navigationItem.leftBarButtonItem = closeBarButton
    }
    
    func closeBtnClick(){
        performSegue(withIdentifier: "backToDefault", sender: self)
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
