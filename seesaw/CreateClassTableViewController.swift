//
//  CreateClassTableViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/25.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON



class CreateClassTableViewController: UITableViewController,UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var gradeText: UITextField!
    
    
    @IBOutlet weak var timePicker: UIPickerView!
    
    let groupNum = ["1","2","3","4","5","6","7","8","9"]
    
    let gradeArray = ["学前班","一年级","二年级","三年级","四年级","五年级","六年级","其他"]
    
    let timeArray = ["周一","周二","周三","周四","周五","周六","周日"]
    
    let weekTimeArrar = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    
    @IBOutlet weak var tableCell: UITableViewCell!
    
    @IBOutlet weak var groupNumPicker: UIPickerView!
    
    @IBOutlet weak var className: UITextField!
    
    var grade: String?
    var weekTime: String?
    var group: Int?
    
    let MOVE_SIZE:CGFloat = 250
    
    let gradePickerView = UIPickerView()
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == groupNumPicker{
            return groupNum[row]
        }
        else if pickerView == gradePickerView{
            return gradeArray[row]
        }
        else{
            return timeArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == groupNumPicker{
            return groupNum.count
        }
        else if pickerView == gradePickerView{
            return gradeArray.count
        }
        else{
            return timeArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //组数选择器
        if pickerView == groupNumPicker{
            group = Int(groupNum[row])
        }
        //年级选择器
        else if pickerView == gradePickerView{
            gradeText.text = gradeArray[row]
        }
        //上课时间选择器
        else{
           weekTime = timeArray[row]
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setButtonImg()
    
        gradePickerView.delegate = self
        gradePickerView.dataSource = self
        
        gradePickerView.backgroundColor = UIColor.white
        
        gradeText.inputView = gradePickerView
        
        // 增加一個觸控事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateClassTableViewController.hideKeyboard(tapG:)))
        
        tap.cancelsTouchesInView = false
        
        // 加在最基底的 self.view 上
        self.view.addGestureRecognizer(tap)
        
        
    }
    
    func hideKeyboard(tapG:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    
    func textfileEditEnd(){
        print("edit end")
        
        
    }
    
    func setButtonImg(){
        let cancelButton = UIButton.init(type: .custom)
        
        cancelButton.setImage(UIImage(named: "cancelImg.png"), for: UIControlState.normal)
        
        cancelButton.addTarget(self, action: #selector(CreateClassTableViewController.cancelBtnClick), for: UIControlEvents.touchUpInside)
        
        cancelButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        let setCameraBarButton = UIBarButtonItem(customView: cancelButton)
        
        self.navigationItem.leftBarButtonItem = setCameraBarButton
        
        
        
        let okButton = UIButton.init(type: .custom)
        
        okButton.setImage(UIImage(named: "okImg.png"), for: UIControlState.normal)
        
        okButton.addTarget(self, action: #selector(CreateClassTableViewController.okBtnClick), for: UIControlEvents.touchUpInside)
        
        okButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let okBarButton = UIBarButtonItem(customView: okButton)
        
        self.navigationItem.rightBarButtonItem = okBarButton
        
    }
    
    
    
    func cancelBtnClick(){
        performSegue(withIdentifier: "segueCreateCancel", sender: self)
    }
    
    func createAlert(titleText: String, messageText: String){
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action) in alert.dismiss(animated: true, completion: nil)
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func okBtnClick(){
        let strClassName = className.text! as String
        let strGrade = gradeText.text as! String
        
        
        let index = timeArray.index(of: weekTime!)
        
        let strWeek = weekTimeArrar[index!]
        
        
        let iGroup = group
        
        
        if strClassName == ""{
            createAlert(titleText: "错误", messageText: "请输入课程名字")
        }
        else if strGrade == "请选择"{
            createAlert(titleText: "错误", messageText: "请选择年级")
        }
        //输入正确，向服务器发送请求
        else{
            let parameters = ["email": Global_userEmail,"courseName": strClassName,"grade":strGrade,"time": strWeek,"group_num": iGroup ?? 1] as [String : Any]
            //print(parameters)
            do{
                let serverController = serverAdd + "/createCourse/"
                let opt = try HTTP.POST(serverController,parameters: parameters)
                opt.start{ response in
                    if let err = response.error{
                        print(err.localizedDescription)
                    }
                        
                    else{
                        let myjson = JSON(response.data)
                        print(myjson["create_time"])
                        //print(response.data)
                        DispatchQueue.main.async {
                            let notificationName = Notification.Name("CreateCourse")
                            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS":"create new course"])
                            self.performSegue(withIdentifier: "segueCreateDone", sender: self)
                        }
                        
                    }
                }
            }catch let error{
                print("error")
            }
        }
        
        
        //print(Global_userEmail)
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func updateGradeText(gradeText: String) {
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - Table view data source

    //override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
      //  return 0
    //}

    //override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      //  return 0
    //}

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
