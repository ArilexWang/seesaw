//
//  GroupMemberViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/8/2.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON

class GroupMemberViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var groupmemTableView: UITableView!
    var groupID:Int?
    
    var groupName = [String]()
    var groupEmail = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(groupID)
        
        getMemberFromServer()
        
        setButton()
        
        let notificationName = Notification.Name("getGroupName")
        NotificationCenter.default.addObserver(self, selector: #selector(updateGroupName(noti:)), name: notificationName, object: nil)

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        let notificationName = Notification.Name("getGroupName")
       
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
        
    }
    
    func updateGroupName(noti: Notification){
        groupName = noti.userInfo?["NAME"] as! [String]
        groupEmail = noti.userInfo?["EMAIL"] as! [String]
        
        groupmemTableView.reloadData()
        
    }
    
    func updateGroupEmail(noti:Notification){
        groupEmail = noti.userInfo?["PASS"] as! [String]
        
        groupmemTableView.reloadData()
    }
    
    func getMemberFromServer(){
        do{
            let serverController = serverAdd + "/getGroupMemberName/"
            let opt = try HTTP.GET(serverController,parameters: ["groupid": groupID])
            opt.start{ response in
                
                if let err = response.error{
                    print(err)
                }
                else{
                    do{
                        let myjson2 = JSON(response.data)
                        print(myjson2)
                        
                        DispatchQueue.main.async {
                            var nameArray = [String]()
                            var emailArray = [String]()
                            for i in 0..<myjson2.count{
                                let name = myjson2[i]["fields"]["name"].string
                                let email = myjson2[i]["pk"].string
                                
                                nameArray.append(name!)
                                emailArray.append(email!)
                                
                            }
                            
                            let notificationName = Notification.Name("getGroupName")
                            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["NAME": nameArray,"EMAIL": emailArray])
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
    
    
    func setButton(){
        let closeButton = UIButton.init(type: .custom)
        
        closeButton.setImage(UIImage(named: "backImg.png"), for: UIControlState.normal)
        
        closeButton.addTarget(self, action: #selector(self.backBtnClick), for: UIControlEvents.touchUpInside)
        
        closeButton.frame = CGRect(x: 0, y: 0, width: 12, height: 20)
        
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        
        self.navigationItem.leftBarButtonItem = closeBarButton
        
        
        let settingButton = UIButton.init(type: .custom)
        
        settingButton.setImage(UIImage(named: "plusBtnImg.png"), for: UIControlState.normal)
        
        settingButton.addTarget(self, action: #selector(self.plusBtnClick), for: UIControlEvents.touchUpInside)
        
        settingButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let settingBarButton = UIBarButtonItem(customView: settingButton)
        
        self.navigationItem.rightBarButtonItem = settingBarButton
    }
    
    func plusBtnClick(){
        performSegue(withIdentifier: "G_memToNoGroup", sender: self)
    }
    
    func backBtnClick(){
        performSegue(withIdentifier: "G_memToDefault", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "G_memToNoGroup" {
            if let noGroupMemberController = segue.destination as? NoGroupMemberViewController{
                noGroupMemberController.groupID = self.groupID
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupMemberTableViewCell") as! GroupMemberTableViewCell
        
        cell.memberNameLbl.text = groupName[indexPath.row]
        
        cell.memberEmailLbl.text = groupEmail[indexPath.row]
        
        return cell
    }
    


}
