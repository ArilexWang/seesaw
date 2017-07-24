//
//  GradePickerViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/25.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit

class GradePickerViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var gradePicker: UIPickerView!
    
    var Array = ["学前班","一年级","二年级","三年级","四年级","五年级","六年级","其他"]
    
    var gradeText:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradePicker.delegate = self
        gradePicker.dataSource = self
        // Do any additional setup after loading the view.
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Array.count
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.gradeText = Array[row]
        
        let notificationName = Notification.Name("GetUpdateNoti")
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS":self.gradeText])
        
        
        //print(gradeText)
    }
    
    @IBAction func okBtnClick(_ sender: Any) {
        
        if self.gradeText == nil {
            self.gradeText = Array[0]
        }
        let notificationName = Notification.Name("selectDone")
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS":self.gradeText])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
