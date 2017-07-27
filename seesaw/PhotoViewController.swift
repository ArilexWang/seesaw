//
//  PhotoViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/18.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit
import SwiftHTTP

class PhotoViewController: UIViewController {
    var photoImage:UIImage?
    
    @IBOutlet weak var photoImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setButtonImg()
        
        photoImgView.image = photoImage
        
        // Do any additional setup after loading the view.
    }
    
    
    func setButtonImg(){
        let cancelButton = UIButton.init(type: .custom)
        
        cancelButton.setImage(UIImage(named: "cancelImg.png"), for: UIControlState.normal)
        
        cancelButton.addTarget(self, action: #selector(PhotoViewController.cancelBtnClick(_:)), for: UIControlEvents.touchUpInside)
        
        cancelButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        let setCameraBarButton = UIBarButtonItem(customView: cancelButton)
        
        self.navigationItem.leftBarButtonItem = setCameraBarButton
        
        
        
        let okButton = UIButton.init(type: .custom)
        
        okButton.setImage(UIImage(named: "okImg.png"), for: UIControlState.normal)
        
        okButton.addTarget(self, action: #selector(PhotoViewController.okBtnClick), for: UIControlEvents.touchUpInside)
        
        okButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let okBarButton = UIBarButtonItem(customView: okButton)
        
        self.navigationItem.rightBarButtonItem = okBarButton
        

        
    }
    
    func saveImageToDocumentDirectory(_ chosenImage: UIImage) -> String {
        let directoryPath =  NSHomeDirectory().appending("/Documents/")
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddhhmmss"
        
        let currentDateString = dateFormatter.string(from: Date())
        
        let filename = currentDateString.appending(".jpg")
    
        let filepath = directoryPath.appending(filename)
        let url = NSURL.fileURL(withPath: filepath)
        do {
            print(filepath)
            try UIImageJPEGRepresentation(chosenImage, 1.0)?.write(to: url, options: .atomic)
            return String.init(filepath)
            
        } catch {
            print(error)
            print("file cant not be save at path \(filepath), with error : \(error)");
            return filepath
        }
    }
    
    func okBtnClick(){
        print(saveImageToDocumentDirectory(photoImage!))
        let path = saveImageToDocumentDirectory(photoImage!)
        print("imapath:\(path)")
        let fileUrl = URL(fileURLWithPath: path)
        do {
            let serverController = serverAdd + "/uploadImg/"
            print("currentid:\(currentCourseID)")
            let opt = try HTTP.POST(serverController, parameters: ["email": Global_userEmail,"courseid": currentCourseID,"img": Upload(fileUrl: fileUrl)])
            opt.start { response in
                
                if let err = response.error{
                    print(err.localizedDescription)
                   
                }
                    
                else{
                    print("data:\(response.data)")
                    DispatchQueue.main.async {
                        let image = UIImage(data: response.data)
                        
                    }
                }
            }
            
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func cancelBtnClick(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: "确定重新拍照吗？", preferredStyle: .actionSheet)
        
        let postToStudent = UIAlertAction(title: "删除并重新拍照", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "backToCamera", sender: self)
            
        })
        
     
        let cancelAction = UIAlertAction(title: "放弃", style: .cancel, handler:  {
            (alert: UIAlertAction!) -> Void in
    })
        
        
        
        
        optionMenu.addAction(postToStudent)
        //optionMenu.addAction(sendAnnouncement)
        optionMenu.addAction(cancelAction)
        
        present(optionMenu, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
