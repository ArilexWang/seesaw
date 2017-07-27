//
//  TeacherSignInTableViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/23.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit
import SwiftHTTP

class TeacherSignInTableViewController: UITableViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButton()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        performSegue(withIdentifier: "back", sender: self)
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
        let email: String = emailText.text!
        let password: String = passwordText.text!
        do{
            let serverController = serverAdd + "/checkPassWord/"
            let opt = try HTTP.GET(serverController,parameters: ["email": email, "password": password])
            opt.start{ response in
                if let err = response.error{
                    print(err.localizedDescription)
                    if(err.localizedDescription == "Could not connect to the server."){
                        let message:String = "连接服务器失败"
                        self.createAlert(titleText: "错误", messageText: message)
                    }
                    else{
                        let message:String = "输入的用户名密码错误"
                        self.createAlert(titleText: "错误", messageText: message)
                    }
                    

                }
                else{
                    DispatchQueue.main.async {
                        Global_userName = response.text
                        Global_userEmail = self.emailText.text
                        self.performSegue(withIdentifier: "fromSignToDefault", sender: self)
                    }
                    //print("获取到数据：\(response.text)")
                }
            
            }
        }catch let error {
            print("请求失败：\(error)")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    //override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
    //    return 0
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
