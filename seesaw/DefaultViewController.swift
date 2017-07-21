//
//  DefaultViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/21.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit

class DefaultViewController: UIViewController {

    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

        
        setButtonImg()
        
        //self.navigationItem.leftBarButtonItem?.target = revealViewController()
        
        //self.navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setButtonImg(){
        
        let button = UIButton.init(type: .custom)
        //set image for button
        button.setImage(UIImage(named: "defaultHead.png"), for: UIControlState.normal)
        //add function for button
        button.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let barButton = UIBarButtonItem(customView: button)
        
        
        self.navigationItem.leftBarButtonItem = barButton
        
        
        
        
        let plusButton = UIButton.init(type: .custom)
        
        plusButton.setImage(UIImage(named: "plusBtnImg.png"), for: UIControlState.normal)
        
        plusButton.addTarget(self, action: #selector(DefaultViewController.plusBtnClick), for: UIControlEvents.touchUpInside)
        
        plusButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let plusBarButton = UIBarButtonItem(customView: plusButton)
        
        
        let settingButton = UIButton.init(type: .custom)
        
        settingButton.setImage(UIImage(named: "settingBtnImg.png"), for: UIControlState.normal)
        
        settingButton.addTarget(self, action: #selector(DefaultViewController.setBtnClick), for: UIControlEvents.touchUpInside)
        
        settingButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let settingBarButton = UIBarButtonItem(customView: settingButton)
        
        let gap = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        gap.width = 20

        
        self.navigationItem.rightBarButtonItems = [plusBarButton, gap ,settingBarButton]
        
    }
    
    func plusBtnClick(){
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let postToStudent = UIAlertAction(title: "发送到学生日记", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.performSegue(withIdentifier: "segueToJournal", sender: self)
            
        })
        
        let sendAnnouncement = UIAlertAction(title: "发送通知", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("send announcement")
        })
        
        let cancelAction = UIAlertAction(title: "放弃", style: .cancel, handler:  {
            (alert: UIAlertAction!) -> Void in
            print("cancel")
        })
        
        optionMenu.addAction(postToStudent)
        optionMenu.addAction(sendAnnouncement)
        optionMenu.addAction(cancelAction)
        
        
        present(optionMenu, animated: true, completion: nil)
    }
    
    func setBtnClick(){
        
    }
    
    
    func defaultHeadBtnClick(){
        print("click")
        
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
