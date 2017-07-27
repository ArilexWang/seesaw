//
//  CreateAccountTableViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/22.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit
import SwiftHTTP


class CreateAccountTableViewController: UITableViewController, UITextFieldDelegate {

    
    @IBOutlet weak var firstNameText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButton()

       NotificationCenter.default.addObserver(self, selector: #selector(CreateAccountTableViewController.textDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
    }
    
    func setButton(){
        let closeButton = UIButton.init(type: .custom)
        
        closeButton.setImage(UIImage(named: "back2.png"), for: UIControlState.normal)
        
        closeButton.addTarget(self, action: #selector(CreateAccountTableViewController.backBtnClick), for: UIControlEvents.touchUpInside)
        
        closeButton.frame = CGRect(x: 0, y: 0, width: 12, height: 20)
        
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        
        self.navigationItem.leftBarButtonItem = closeBarButton
        
        let okButton = UIButton.init(type: .custom)
        
        okButton.setImage(UIImage(named: "okImg.png"), for: UIControlState.normal)
        
        okButton.addTarget(self, action: #selector(CreateAccountTableViewController.okBtnClick), for: UIControlEvents.touchUpInside)
        
        okButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let okBarButton = UIBarButtonItem(customView: okButton)
        
        self.navigationItem.rightBarButtonItem = okBarButton
        
    }
    
    func backBtnClick(){
        performSegue(withIdentifier: "backToSign", sender: self)
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
        
        if firstNameText.text == "" {
            let message: String = "请输入您的姓名"
            createAlert(titleText: "错误", messageText: message)
        }
      
        else if emailText.text == ""{
            let message: String = "请输入您的邮箱地址"
            createAlert(titleText: "错误", messageText: message)
        }
        
        else if passwordText.text == ""{
            let message: String = "请输入您的密码"
            createAlert(titleText: "错误", messageText: message)
        }
            
        else if !isEamilValidation(string: emailText.text!){
            let message: String = "请输入合法的邮箱地址"
            createAlert(titleText: "错误", messageText: message)
        }
            
        //right input
        else {
        
            let name: String = firstNameText.text!
            let email: String = emailText.text!
            let password: String = passwordText.text!
            
            let parameters = ["username": name,"email": email,"password": password]
            print(parameters) 
            
            
            do{
                let serverController = serverAdd + "/index/"
                let opt = try HTTP.POST(serverController,parameters: parameters)
                opt.start{ response in
                    if let err = response.error{
                        if(err.localizedDescription == "Could not connect to the server."){
                            let message:String = "连接服务器失败"
                            self.createAlert(titleText: "错误", messageText: message)
                        } else{
                            let message:String = "该邮箱已注册"
                            self.createAlert(titleText: "错误", messageText: message)
                        }
                    }
                    
                    else{
                        DispatchQueue.main.async {
                            Global_userName = name
                            Global_userEmail = email
                            self.performSegue(withIdentifier: "segueToClass", sender: self)
                        }
                    }
                }
            }catch let error{
                print("error")
            }
            
            
            
        }
    }
    
    
    func textDidEndEditing(){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

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
