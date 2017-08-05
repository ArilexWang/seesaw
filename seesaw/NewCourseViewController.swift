//
//  NewCourseViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/8/3.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON
import SwiftDate
import UITextView_Placeholder

class NewCourseViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var contentTextview: UITextView!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var sectionNumLbl: UILabel!
    
    var sectionNum: Int = 0
    
    var timeArray = [String]()
    
    var nextdate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextview.placeholder = "课程内容"
        
        setButton()
        
        DispatchQueue.global().async {
            self.getSectionNumFromServer()
            self.getWeekTimeFromServer()
            
            DispatchQueue.main.async {
                self.sectionNum += 1
                self.calculateNextSectionDay(timeArray: self.timeArray)
                self.sectionNumLbl.text = String(self.sectionNum)
                
                if self.nextdate != nil{
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy"
                    dateFormatter.locale = Locale.current
                    self.yearLbl.text = dateFormatter.string(from: self.nextdate!)
                    
                    dateFormatter.dateFormat = "M"
                    self.monthLbl.text = dateFormatter.string(from: self.nextdate!)
                    
                    dateFormatter.dateFormat = "d"
                    self.dayLbl.text = dateFormatter.string(from: self.nextdate!)
                }
                
                
            }
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSectionNumFromServer(){
        do{
            let serverController = serverAdd + "/getSectionNum/"
            let opt = try HTTP.GET(serverController,parameters: ["courseid": currentCourseID])
            opt.start{ response in
                
                if let err = response.error{
                    print(err)
                }
                else{
                    do{
                        let strnum = response.text
                        self.sectionNum = Int(strnum!)!
                    } catch{
                        print("error")
                    }
                    
                }
                
            }
        }catch let error {
            print("请求失败：\(error)")
        }
    }
    
    func getWeekTimeFromServer(){
        do{
            let serverController = serverAdd + "/getCourseMsg/"
            let opt = try HTTP.GET(serverController,parameters: ["courseid": currentCourseID])
            opt.start{ response in
                
                if let err = response.error{
                    print(err)
                }
                else{
                    do{
                        
                        print(response.text)
                        
                        self.timeArray = (response.text?.components(separatedBy: ","))! 
                        
                    } catch{
                        print("error")
                    }
                    
                }
                
            }
        }catch let error {
            print("请求失败：\(error)")
        }

    }
    
    
    func calculateNextSectionDay(timeArray: [String]){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm"
        
        dateFormatter.locale = Locale.current
        
        let strdate:String = timeArray[0]
        
        let date = dateFormatter.date(from: strdate)

        
        let getWeekday = WEEK_DIC[(timeArray[1])]
        
        
        let dif = getWeekday!-(date?.weekday)!
        
        if dif < 0{
            let nextdate = date! + (sectionNum * 7).day + dif.day
            
            self.nextdate = nextdate
        } else  {
            let nextdate = date! + ((sectionNum-1) * 7).day + dif.day
            
            self.nextdate = nextdate
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
        performSegue(withIdentifier: "C_newToDefault", sender: self)
    }
    
    func okBtnClick(){
        //print(contentTextview.text)
        //print(datePicker.date)

        let queue = DispatchQueue(label: "myseesaw")
        
        queue.sync {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale.current
            
            let strDate = dateFormatter.string(from: datePicker.date)
            
            let startDate = dateFormatter.string(from: self.nextdate!)
            
            do{
                let serverController = serverAdd + "/uploadSection/"
                let opt = try HTTP.GET(serverController,parameters: ["courseid": currentCourseID,"content":contentTextview.text,"enddate": strDate, "startDate": startDate])
                opt.start{ response in
                    
                    if let err = response.error{
                        print(err)
                    }
                    else{
                        do{
                            let myjson = JSON(response.data)
                            print(myjson)
                        } catch{
                            print("error")
                        }
                        
                    }
                    
                }
            }catch let error {
                print("请求失败：\(error)")
            }
        }
        
        performSegue(withIdentifier: "C_newToDefault", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "C_newToDefault" {
            if let teacherCourseViewController = segue.destination as? TeacherCourseViewController{
                
            }
        }
    }
    
    
}
