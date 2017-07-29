//
//  JoinCodeViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/29.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit
import SwiftHTTP


class JoinCodeViewController: UIViewController {

    @IBOutlet weak var joinCodeLbl: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        joinCodeLbl.frame.size.height = 60
        joinCodeLbl.frame.size.width = 220
        
        setButton()
        // Do any additional setup after loading the view.
    }

    
    func setButton(){
        let closeButton = UIButton.init(type: .custom)
        
        closeButton.setImage(UIImage(named: "back2.png"), for: UIControlState.normal)
        
        closeButton.addTarget(self, action: #selector(JoinCodeViewController.backBtnClick), for: UIControlEvents.touchUpInside)
        
        closeButton.frame = CGRect(x: 0, y: 0, width: 12, height: 20)
        
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        
        self.navigationItem.leftBarButtonItem = closeBarButton
        
        let okButton = UIButton.init(type: .custom)
        
        okButton.setImage(UIImage(named: "okImg.png"), for: UIControlState.normal)
        
        okButton.addTarget(self, action: #selector(JoinCodeViewController.okBtnClick), for: UIControlEvents.touchUpInside)
        
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
        let strCode = joinCodeLbl.text
        let code = Int(strCode!)
        print(code)
        
        
        let serverController = serverAdd + "/checkCourseCode/"
        
        do{
            let opt = try HTTP.GET(serverController,parameters: ["code": code])
            opt.start{ response in
                if let err = response.error{
                    print(err.localizedDescription)
                    if(err.localizedDescription == "Could not connect to the server."){
                        let message:String = "连接服务器失败"
                        self.createAlert(titleText: "错误", messageText: message)
                    }
                    else{
                        let message:String = "课程码不存在"
                        self.createAlert(titleText: "错误", messageText: message)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "codeToCreate", sender: self)
                    }
                    
                    currentCourseID = code
                    print("获取到数据：\(response.text)")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
