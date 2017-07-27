//
//  DefaultViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/21.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit
import SwiftHTTP
import JSONJoy
import SwiftyJSON
import TRON

class DefaultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var imgsURL:Array = [String]()
    var itemImg:Array = [UIImage]()
    
    @IBOutlet weak var itemTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonImg()
        
        let notificationName = Notification.Name("getURLfinish")
        NotificationCenter.default.addObserver(self, selector: #selector(getUpdateURL(noti:)), name: notificationName, object: nil)
        
        let notificationName2 = Notification.Name("choseCourse")
        NotificationCenter.default.addObserver(self, selector: #selector(updateCurrentCourse(noti:)), name: notificationName2, object: nil)
        
        let notificationName3 = Notification.Name("getIMGfinish")
        NotificationCenter.default.addObserver(self, selector: #selector(updateItemImg(noti:)), name: notificationName3, object: nil)
        

        // Do any additional setup after loading the view.
    }

    
    func getUpdateURL(noti:Notification){
        self.imgsURL = noti.userInfo!["PASS"] as! [String]
        print(self.imgsURL)
        
        if self.imgsURL.count != 0 {
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: URL(string: self.imgsURL[0])!, completionHandler: { (data, response, error) in
                if let e = error {
                    print("Error downloading cat picture: \(e)")
                } else {
                    if let res = response as? HTTPURLResponse {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            self.itemImg.append(image!)
                            let notificationName = Notification.Name("getIMGfinish")
                            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS": self.itemImg])
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
            })
            downloadPicTask.resume()
        }
        
    }
    
    
    //选择课程完毕调用
    func updateCurrentCourse(noti: Notification){
        
        currentCourseID = noti.userInfo?["PASS"] as! Int
        let currentCourseName = noti.userInfo?["NAME"] as! String
        self.navigationItem.title = currentCourseName
        
        imgsURL = []
        itemImg = []
        
        getItemURL(email: Global_userEmail!,id: currentCourseID!)
    }
    
    
    func updateItemImg(noti: Notification){
        self.itemImg = noti.userInfo?["PASS"] as! [UIImage]
        itemTableView.reloadData()
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
    
    
    func getItemURL(email:String, id:Int){
        do{
            let serverController = serverAdd + "/getImg/"
            let opt = try HTTP.GET(serverController,parameters: ["email": email,"courseid":id])
            opt.start{ response in
                
                if let err = response.error{
                    print(err)
                }
                    
                else{
                    do{
                        let myjson = try JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        //获取图片的URL地址
                        DispatchQueue.main.async {
                            for i in 0..<myjson.count{
                                let item = myjson[i]
                                var strItem = item as! String
                                strItem = serverAdd + strItem
                                //print(strItem)
                                self.imgsURL.append(strItem)
                            }
                            let notificationName = Notification.Name("getURLfinish")
                            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS": self.imgsURL])
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
    
    func setBtnClick(){
        
    }
    
    
    func defaultHeadBtnClick(){
        print("click")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if currentCourseID == nil{
            return 0
        } else{
            return itemImg.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell") as! ItemTableViewCell
        
        if itemImg.count != 0 {
            cell.itemImg.image = itemImg[indexPath.row]
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
