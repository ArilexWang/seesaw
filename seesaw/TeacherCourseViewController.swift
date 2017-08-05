//
//  TeacherCourseViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/8/3.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON

class TeacherCourseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var sectionTableView: UITableView!
    var contents = [String]()
    var createtimes = [String]()
    var homeworkddl = [String]()
    
    var createtimeDate = [Date]()
    var homeworkddlDate = [Date]()
    
    var strCreateYears = [String]()
    var strCreateMonths = [String]()
    var strCreateDays = [String]()
    
    var strHomeworkYears = [String]()
    var strHomeworkMonths = [String]()
    var strHomeworkDays = [String]()
    
    
    var sectionIDs = [Int]()
    
    var selectSectionID:Int?
    
    var groupNum: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setButtonImg()
        
        getSectionsFromServer()
        
        self.navigationItem.title = currentCourseName
        
        let notificationName = Notification.Name("getMsgFinsh")
        NotificationCenter.default.addObserver(self, selector: #selector(getUpdateMsg(noti:)), name: notificationName, object: nil)
        
        let notificationName2 = Notification.Name("getGroupNumFinsh")
        NotificationCenter.default.addObserver(self, selector: #selector(getUpdateGroupNum(noti:)), name: notificationName2, object: nil)
        
        
//        DispatchQueue.global().async {
//            //self.getSectionsFromServer()
//            DispatchQueue.main.async {
//                //self.sectionTableView.reloadData()
//            }
//        }
        
    }
    
    func getUpdateGroupNum(noti: Notification){
        let strGroupNum = noti.userInfo?["PASS"] as! String
        self.groupNum = Int(strGroupNum)
        print(self.groupNum)
        self.sectionTableView.reloadData()
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        let notificationName = Notification.Name("getMsgFinsh")
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
        
        let notificationName2 = Notification.Name("getGroupNumFinsh")
        NotificationCenter.default.removeObserver(self, name: notificationName2, object: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUpdateMsg(noti: Notification){
        self.createtimes = noti.userInfo?["PASS"] as! [String]
        
        for i in 0..<createtimes.count{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale.current
            
            var tempCreate: Date?
            var tempHomeworkddl: Date?
            
            tempCreate = dateFormatter.date(from: createtimes[i])
            tempHomeworkddl = dateFormatter.date(from: homeworkddl[i])
            
            dateFormatter.dateFormat = "yyyy"
            let tempYear = dateFormatter.string(from: tempCreate!)
            let tempYear2 = dateFormatter.string(from: tempHomeworkddl!)
            strCreateYears.append(tempYear)
            strHomeworkYears.append(tempYear2)
            
            dateFormatter.dateFormat = "M"
            let tempMonth = dateFormatter.string(from: tempCreate!)
            let tempMonth2 = dateFormatter.string(from: tempHomeworkddl!)
            strCreateMonths.append(tempMonth)
            strHomeworkMonths.append(tempMonth2)
            
            dateFormatter.dateFormat = "d"
            let tempDay = dateFormatter.string(from: tempCreate!)
            let tempDay2 = dateFormatter.string(from: tempHomeworkddl!)
            strCreateDays.append(tempDay)
            strHomeworkDays.append(tempDay2)
            
        }
        
        getGroupNumFromServer()
        
        
    }
    
    func getSectionsFromServer(){
        do{
            let serverController = serverAdd + "/getSections/"
            let opt = try HTTP.GET(serverController,parameters: ["courseid": currentCourseID])
            opt.start{ response in
                
                if let err = response.error{
                    print(err)
                }
                else{
                    do{
                        let myjson = JSON(response.data)
                        
                        for i in 0..<myjson.count{
                            self.createtimes.append(String(describing: myjson[i]["create_time"]))
                            self.contents.append(String(describing: myjson[i]["content"]))
                            self.homeworkddl.append(String(describing: myjson[i]["homework_ddl"]))
                            self.sectionIDs.append(myjson[i]["id"].int!)
                        }
                        
                        print(self.sectionIDs)
                        
                        let notificationName = Notification.Name("getMsgFinsh")
                        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS": self.createtimes])
                        
                    } catch{
                        print("error")
                    }
                    
                }
                
            }
        }catch let error {
            print("请求失败：\(error)")
        }
    }
    
    
    
    func getGroupNumFromServer(){
        do{
            let serverController = serverAdd + "/getGroupNum/"
            let opt = try HTTP.GET(serverController,parameters: ["courseid": currentCourseID])
            opt.start{ response in
                
                if let err = response.error{
                    print(err)
                }
                else{
                    do{
                        let strGroupNum = response.text
                        
                        let notificationName = Notification.Name("getGroupNumFinsh")
                        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS": strGroupNum])
                        
                    } catch{
                        print("error")
                    }
                    
                }
                
            }
        }catch let error {
            print("请求失败：\(error)")
        }
    }
    
    
    func changeStringToDate(arr1: [String],arr2: [String]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.current
        
        for i in 0..<arr1.count{
            var tempCreateTime: Date?
            var tempddl: Date?
            tempCreateTime = dateFormatter.date(from: arr1[i])
            tempddl = dateFormatter.date(from: arr2[i])
            createtimeDate.append(tempCreateTime!)
            homeworkddlDate.append(tempddl!)
        }
        
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
        
        
        
        if currentStatu == TEACHER{
            let settingButton = UIButton.init(type: .custom)
            
            settingButton.setImage(UIImage(named: "plusBtnImg.png"), for: UIControlState.normal)
            
            settingButton.addTarget(self, action: #selector(self.plusBtnClick), for: UIControlEvents.touchUpInside)
            
            settingButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            
            let settingBarButton = UIBarButtonItem(customView: settingButton)
            
            self.navigationItem.rightBarButtonItem = settingBarButton
        }
        
    }

    func plusBtnClick(){
        performSegue(withIdentifier: "C_defaultToNew", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("rownum:\(createtimes.count)")
        return createtimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseTableViewCell") as! CourseTableViewCell
        
        cell.contentText.text = contents[indexPath.row]
        
        cell.sectionNumLbl.text = String(indexPath.row + 1)
        
        cell.yearLbl.text = strCreateYears[indexPath.row]
        cell.monthLbl.text = strCreateMonths[indexPath.row]
        cell.dayLbl.text = strCreateDays[indexPath.row]
        
        cell.homeworkYearLbl.text = strHomeworkYears[indexPath.row]
        cell.homeworkMonthLbl.text = strHomeworkMonths[indexPath.row]
        cell.homeworkDayLbl.text = strHomeworkDays[indexPath.row]
        
        cell.sectionID = sectionIDs[indexPath.row]
        
        if currentStatu == TEACHER{
            if self.groupNum != nil{
                for i in 0..<self.groupNum!{
                    
                    let settingButton = UIButton.init(type: .custom)
                    
                    settingButton.setImage(UIImage(named: "btn1.png"), for: UIControlState.normal)
                    
                    settingButton.addTarget(self, action: #selector(self.blankBtnClick), for: UIControlEvents.touchUpInside)
                    
                    settingButton.frame = CGRect(x: 16+30*i, y: 300, width: 24, height: 24)
                    
                    
                    cell.addSubview(settingButton)
                }
            }
        } else{
            let watchButton = UIButton.init(type: .custom)
            
            watchButton.setImage(UIImage(named: "eyeImg.png"), for: UIControlState.normal)
            
            watchButton.addTarget(self, action: #selector(self.blankBtnClick), for: UIControlEvents.touchUpInside)
            
            watchButton.frame = CGRect(x: 20, y: 300, width: 40, height: 25)
            
            cell.addSubview(watchButton)
            
            let plusButton = UIButton.init(type: .custom)
            
            plusButton.setImage(UIImage(named: "plusBtnImg.png"), for: .normal)
            
            plusButton.addTarget(self, action: #selector(self.plusHomeworkBtnClick), for: UIControlEvents.touchUpInside)
            
            plusButton.frame = CGRect(x: 330, y: 300, width: 24, height: 24)
            
            plusButton.tag = sectionIDs[indexPath.row]
            
            cell.addSubview(plusButton)

        }
        
        
        return cell
    }

    func blankBtnClick(){
        
    }
    
    func plusHomeworkBtnClick(sender: UIButton){
        selectSectionID = sender.tag
        performSegue(withIdentifier: "segueToNewHomework", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToNewHomework" {
            if let studentNewWorkViewController = segue.destination as? StudentNewWorkViewController{
                studentNewWorkViewController.sectionID = selectSectionID
            }
        }
    }
    
    
}
