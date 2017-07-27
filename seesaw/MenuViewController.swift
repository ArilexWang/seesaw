//
//  MenuViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/21.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit
import SwiftHTTP

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var menuNameArr:Array = [String]()
    var iconImage:Array = [UIImage]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.text = Global_userName
        menuNameArr = []
        
        getCourseFromServer()
        
        
        //监听器，监听创建课程事件
        let notificationName = Notification.Name("CreateCourse")
        NotificationCenter.default.addObserver(self, selector: #selector(createCourseDone(noti:)), name: notificationName, object: nil)
        
        //iconImage = [UIImage(named:"defaultClassImg.png")!]
        // Do any additional setup after loading the view.
    }

    
    func getCourseFromServer(){
        //print(Global_userEmail)
        
        do{
            let serverController = serverAdd + "/getCourse/"
            let opt = try HTTP.GET(serverController,parameters: ["email": Global_userEmail])
            opt.start{ response in
                if let err = response.error{
                    
                }
                else{
                    //print(response.text)
                    let courseNames = response.text
                    //print(courseNames)
                    //courseNames?.components(separatedBy: " ")
                    let names:Array = (courseNames?.components(separatedBy: " "))!
                    
                    
                    DispatchQueue.main.async {
                        self.menuNameArr = names
                        //print(self.menuNameArr)
                        self.tableView.reloadData()
                    }
                    //print("获取到数据：\(response.text)")
                }
                
            }
        }catch let error {
            print("请求失败：\(error)")
        }
        
        do{
            let serverController = serverAdd + "/getCourseID/"
            let opt = try HTTP.GET(serverController,parameters: ["email": Global_userEmail])
            opt.start{ response in
                if let err = response.error{
                    
                }
                else{
                    //print(response.text)
                    let courseID = response.text
                    print(courseID)
                    //courseNames?.components(separatedBy: " ")
                    let ids:Array = (courseID?.components(separatedBy: " "))!
                    
                    
                    DispatchQueue.main.async {
                        menuCourseID = ids
                        //print(self.menuNameArr)
                        self.tableView.reloadData()
                    }
                    //print("获取到数据：\(response.text)")
                }
                
            }
        }catch let error {
            print("请求失败：\(error)")
        }
        
        
        
        
        
    }
    
    func createCourseDone(noti: Notification){
        //print(noti.userInfo!["PASS"] as! String)
        self.tableView.reloadData()
    }
    
    @IBAction func createBtnClick(_ sender: Any) {
        performSegue(withIdentifier: "segueToCreate", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        
        //print(menuNameArr)
        //cell.imgIcon.image = iconImage[indexPath.row]
        cell.lblMenuName.text = menuNameArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(menuCourseID[indexPath.row])
        currentCourseID = Int(menuCourseID[indexPath.row])
        revealViewController().revealToggle(animated: true)
        
        
        //发送通知，选择课程完成
        let notificationName = Notification.Name("choseCourse")
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS": currentCourseID,"NAME": self.menuNameArr[indexPath.row]])
        
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
