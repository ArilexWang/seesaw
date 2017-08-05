//
//  StudentNewWorkViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/8/3.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import SwiftHTTP
import SwiftyJSON

class StudentNewWorkViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var plusImgBtn: UIButton!
    @IBOutlet weak var contentText: UITextView!
    var sectionID: Int?
    var image: UIImage?
    var strContent: String?
    var filePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentText.placeholder = "作业内容"
        
        
        if image == nil{
            imageView.isHidden = true
        } else{
            imageView.isHidden = false
            imageView.image = image
            plusImgBtn.isHidden = true
            contentText.text = strContent
        }
        
        setButton()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func plusImgBtnClick(_ sender: Any) {
        
        performSegue(withIdentifier: "HomeworkToCamera", sender: self)
        
    }
    
    func backBtnClick(){
        performSegue(withIdentifier: "C_newWorkToDefault", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let originView:String = "Homework"
        print(contentText.text)
        if segue.identifier == "HomeworkToCamera" {
            if let cameraViewController = segue.destination as? CameraViewController{
                cameraViewController.originView = originView
                cameraViewController.originViewContent = contentText.text
                cameraViewController.originViewSectionID = sectionID
            }
        }
    }
    
    func okBtnClick(){
        
        let queue = DispatchQueue(label: "myseesaw")
        
        queue.sync {
            do{
                let serverController = serverAdd + "/uploadHomework/"
                let opt = try HTTP.GET(serverController,parameters: ["email": Global_userEmail,"content":contentText.text,"imgpath": self.filePath,"sectionid": sectionID])
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
        
        performSegue(withIdentifier: "newWorkToDefault", sender: self)
        
    }
    
    
  
}
