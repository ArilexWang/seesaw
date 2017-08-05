//
//  NoGroupMemberViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/8/2.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit
import SwiftHTTP

class NoGroupMemberViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var unGroupTableview: UITableView!
    
    var groupID:Int?
    
    var ungroupName = [String]()
    
    var ungroupEmail = [String]()
    
    var selectEmail = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButton()
        // Do any additional setup after loading the view.
        
        let notificationName = Notification.Name("getUnGroupName")
        NotificationCenter.default.addObserver(self, selector: #selector(updateUnGroupName(noti:)), name: notificationName, object: nil)
        
        let notificationName2 = Notification.Name("getUnGroupEmail")
        NotificationCenter.default.addObserver(self, selector: #selector(updateUnGroupEmail(noti:)), name: notificationName2, object: nil)
        
        getNameFromServer()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let notificationName = Notification.Name("getUnGroupName")
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
        
        let notificationName2 = Notification.Name("getUnGroupEmail")
        NotificationCenter.default.removeObserver(self, name: notificationName2, object: nil)
    }
    
    func updateUnGroupEmail(noti:Notification){
        ungroupEmail = noti.userInfo?["PASS"] as! [String]
        unGroupTableview.reloadData()
    }
    
    func updateUnGroupName(noti: Notification){
        ungroupName = noti.userInfo?["PASS"] as! [String]
        
        do{
            let serverController = serverAdd + "/getUnGroupMemberEmail/"
            let opt = try HTTP.GET(serverController,parameters: ["courseid": currentCourseID])
            opt.start{ response in
                
                if let err = response.error{
                    print(err)
                }
                else{
                    do{
                        let myjson = try JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                        
                        DispatchQueue.main.async {
                            var emailArray = [String]()
                            for i in 0..<myjson.count{
                                let item = myjson[i]
                                let strItem = item as! String
                                emailArray.append(strItem)
                            }
                            
                            let notificationName = Notification.Name("getUnGroupEmail")
                            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS": emailArray])
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
    
    
    func getNameFromServer(){
        do{
            let serverController = serverAdd + "/getUnGroupMemberName/"
            let opt = try HTTP.GET(serverController,parameters: ["courseid": currentCourseID])
            opt.start{ response in
                
                if let err = response.error{
                    print(err)
                }
                else{
                    do{
                        let myjson = try JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                        
                        DispatchQueue.main.async {
                            var nameArray = [String]()
                            for i in 0..<myjson.count{
                                let item = myjson[i]
                                var strItem = item as! String
                                nameArray.append(strItem)
                            }
                            
                            let notificationName = Notification.Name("getUnGroupName")
                            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS": nameArray])
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
        
        settingButton.setImage(UIImage(named: "okImg.png"), for: UIControlState.normal)
        
        settingButton.addTarget(self, action: #selector(self.okBtnClick), for: UIControlEvents.touchUpInside)
        
        settingButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let settingBarButton = UIBarButtonItem(customView: settingButton)
        
        self.navigationItem.rightBarButtonItem = settingBarButton
    }
    
    func backBtnClick(){
        performSegue(withIdentifier: "G_backToDefault", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "G_backToDefault" {
            if let groupMemberController = segue.destination as? GroupMemberViewController{
                groupMemberController.groupID = self.groupID
            }
        }
    }
    
    func okBtnClick(){
        
        let strSelectEmail = selectEmail.joined(separator: ",")
        print(strSelectEmail)
        
        do {
            let serverController = serverAdd + "/uploadSelectedEmail/"
            
            let opt = try HTTP.POST(serverController, parameters: ["emails": strSelectEmail,"groupid": groupID])
            
            opt.start { response in
                if let err = response.error{
                    print(err.localizedDescription)
                }
                else{
                    
                    print(response.text)
                    
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "G_backToDefault", sender: self)
                    }
                    
                    
                }
            }
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ungroupName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoGroupMemberTableViewCell") as! NoGroupMemberTableViewCell
        
        cell.memberNameLbl.text = ungroupName[indexPath.row]
        cell.memberEmailLbl.text = ungroupEmail[indexPath.row]
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            
            let index = selectEmail.index(of: ungroupEmail[indexPath.row])
            self.selectEmail.remove(at: index!)
            
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            
            self.selectEmail.append(ungroupEmail[indexPath.row])
            
        }
    }
    
    

}
