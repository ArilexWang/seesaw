//
//  CreateClassTableViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/25.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit
import SwiftHTTP



class CreateClassTableViewController: UITableViewController {
    
    @IBOutlet weak var tableCell: UITableViewCell!
   

    @IBOutlet weak var pickerContainer: UIView!
    
    @IBOutlet weak var gradeText: UILabel!
    
    @IBOutlet weak var className: UITextField!
    let MOVE_SIZE:CGFloat = 250
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setButtonImg()
        
        let notificationName = Notification.Name("GetUpdateNoti")
        NotificationCenter.default.addObserver(self, selector: #selector(getUpdateNoti(noti:)), name: notificationName, object: nil)
        
        let notificationName2 = Notification.Name("selectDone")
        NotificationCenter.default.addObserver(self, selector: #selector(selectFinish(noti:)), name: notificationName2, object: nil)
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        let strClassName = className.text!
        let strGrade = gradeText.text!
        
        if strClassName == ""{
            createAlert(titleText: "错误", messageText: "请输入课程名字")
        }
        else if strGrade == "请选择"{
            createAlert(titleText: "错误", messageText: "请选择年级")
        }
        
        //输入正确，向服务器发送请求
        else{
            let parameters = ["email": Global_userEmail,"courseName": strClassName,"grade":strGrade]
            //print(parameters)
            do{
                let serverController = serverAdd + "/createCourse/"
                let opt = try HTTP.POST(serverController,parameters: parameters)
                opt.start{ response in
                    if let err = response.error{
                        print(err.localizedDescription)
                    }
                        
                    else{
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
    
    
    func getUpdateNoti(noti:Notification){
        gradeText.text = noti.userInfo!["PASS"] as! String
        //print(noti.userInfo!["PASS"])
    }
    
    func selectFinish(noti:Notification){
        //print(noti.userInfo!["PASS"])
        gradeText.text = noti.userInfo!["PASS"] as! String
        UIView.animate(withDuration: 0.3, animations: {
            self.pickerContainer.frame.origin.y += self.MOVE_SIZE
        },completion:nil)
        self.tableCell.isUserInteractionEnabled = true
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 535
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func updateGradeText(gradeText: String) {
        self.gradeText.text = gradeText
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        if indexPath.row == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.pickerContainer.frame.origin.y -= self.MOVE_SIZE
            },completion:nil)
        }
        //self.tableView.cellForRow(at: indexPath)?.isUserInteractionEnabled = false
        self.tableCell.isUserInteractionEnabled = false
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
