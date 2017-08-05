//
//  GroupDefaultViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/8/2.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON

class GroupDefaultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var groupNum: Int = 0
    
    var groupIDs = [Int]()
    
    @IBOutlet weak var groupTableView: UITableView!
    
    var segueGroupID:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtonImg()
        
        let notificationName = Notification.Name("choseCourse")
        NotificationCenter.default.addObserver(self, selector: #selector(updateCurrentCourse(noti:)), name: notificationName, object: nil)
        
        
        let notificationName2 = Notification.Name("getCourseNum")
        NotificationCenter.default.addObserver(self, selector: #selector(updateCourseGroup(noti:)), name: notificationName2, object: nil)
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        let notificationName = Notification.Name("choseCourse")
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
        
        let notificationName2 = Notification.Name("getCourseNum")
        NotificationCenter.default.removeObserver(self, name: notificationName2, object: nil)
    }
    
    func updateCurrentCourse(noti:Notification){
        currentCourseID = noti.userInfo?["PASS"] as! Int
        let currentCourseName = noti.userInfo?["NAME"] as! String
        self.navigationItem.title = currentCourseName
        
        do{
            let serverController = serverAdd + "/getCourseGroup/"
            let opt = try HTTP.GET(serverController,parameters: ["courseid": currentCourseID])
            opt.start{ response in
                if let err = response.error{
                    print(err)
                }
                else{
                    do{
                        let myjson = try JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                        
                        let myjson2 = JSON(response.data)
                        
                        DispatchQueue.main.async {
                            var idArray = [Int]()
                            for i in 0..<myjson.count{
                                let item = myjson2[i]["pk"].int
                                idArray.append(item!)
                            }
                            print(idArray)
                            self.groupNum = myjson.count
                            let notificationName = Notification.Name("getCourseNum")
                            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS": idArray])
                        }
                    } catch{
                        print("error")
                    }
                    
                }
                
            }
        }catch let error {
            print("请求失败：\(error)")
        }
        
        
    }
    
    func updateCourseGroup(noti: Notification){
        groupIDs = noti.userInfo?["PASS"] as! [Int]
        
        self.groupTableView.reloadData()
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
        

        
        let settingButton = UIButton.init(type: .custom)
            
        settingButton.setImage(UIImage(named: "settingBtnImg.png"), for: UIControlState.normal)
            
        settingButton.addTarget(self, action: #selector(self.setBtnClick), for: UIControlEvents.touchUpInside)
            
        settingButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            
        let settingBarButton = UIBarButtonItem(customView: settingButton)
            
        self.navigationItem.rightBarButtonItem = settingBarButton
        
        
    }
    func setBtnClick(){
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "G_defaultToMem", sender: self)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("groupnum: \(self.groupNum)")
        return groupNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell") as! GroupTableViewCell
        cell.groupNumLbl.text = String(indexPath.row + 1)
        cell.groupID = groupIDs[indexPath.row]
        
        let ID = groupIDs[indexPath.row]
        
        cell.memberBtn.tag = ID
        
        cell.memberBtn.addTarget(self, action: #selector(memberBtnClick), for: .touchUpInside)
        
        let settingButton = UIButton.init(type: .custom)
        
        settingButton.setImage(UIImage(named: "btn1.png"), for: UIControlState.normal)
        
        settingButton.addTarget(self, action: #selector(self.blankBtnClick), for: UIControlEvents.touchUpInside)
        
        settingButton.frame = CGRect(x: 8, y: 40, width: 24, height: 24)
        
        
        cell.addSubview(settingButton)
        
        return cell
        
    }
    
    func blankBtnClick(){
        performSegue(withIdentifier: "G_defaultToWork", sender: self)
    }
    
    func memberBtnClick(sender: UIButton){
        print(sender.tag)
        segueGroupID = sender.tag
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "G_defaultToMem", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "G_defaultToMem" {
            if let groupMemberController = segue.destination as? GroupMemberViewController{
                groupMemberController.groupID = segueGroupID
            }
        }
    }
    
    
}
