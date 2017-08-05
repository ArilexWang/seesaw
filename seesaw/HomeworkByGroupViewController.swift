//
//  HomeworkByGroupViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/8/3.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit

class HomeworkByGroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButton()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setButton(){
        let closeButton = UIButton.init(type: .custom)
        
        closeButton.setImage(UIImage(named: "backImg.png"), for: UIControlState.normal)
        
        closeButton.addTarget(self, action: #selector(self.backBtnClick), for: UIControlEvents.touchUpInside)
        
        closeButton.frame = CGRect(x: 0, y: 0, width: 12, height: 20)
        
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        
        self.navigationItem.leftBarButtonItem = closeBarButton
        
    }
    
    func backBtnClick(){
        performSegue(withIdentifier: "G_homewordToGroup", sender: self)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeworkByGroupTableViewCell") as! HomeworkByGroupTableViewCell
        
        if currentStatu == STUDENT{
            cell.starBtn.isHidden = true
        } else{
            cell.starBtn.isHidden = false
        }
        
        return cell
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
