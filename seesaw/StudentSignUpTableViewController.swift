//
//  StudentSignUpTableViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/29.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit

class StudentSignUpTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func setButton(){
        let closeButton = UIButton.init(type: .custom)
        
        closeButton.setImage(UIImage(named: "back2.png"), for: UIControlState.normal)
        
        closeButton.addTarget(self, action: #selector(StudentSignUpTableViewController.backBtnClick), for: UIControlEvents.touchUpInside)
        
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
        performSegue(withIdentifier: "backToStSign", sender: self)
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