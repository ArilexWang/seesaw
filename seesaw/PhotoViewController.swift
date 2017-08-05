//
//  PhotoViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/18.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit
import SwiftHTTP
import Qiniu
import JSONKit_NoWarning


let kQiniuBucket = "seesaw-image"
let kQiniuAccessKey = "93L43E91oA1cbC9k40ZK2eSeOCqxxjJz1SsL4NGv"
let kQiniuSecretKey = "2nALux7vEJkrcuH0ZOWUhW2bI6vIvvtqpysS71aH"


class PhotoViewController: UIViewController {
    var photoImage:UIImage?
    
    var originView:String?
    var originViewContent: String?
    var originViewSectionID: Int?
    
    var filePath: String?
    
    @IBOutlet weak var photoImgView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setButtonImg()
        
        photoImgView.image = photoImage
        
        let notificationName = Notification.Name("uploadImg")
        
        NotificationCenter.default.addObserver(self, selector: #selector(uploadDone(noti:)), name: notificationName, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        let notificationName = Notification.Name("uploadImg")
        
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
    
    }
    
    func uploadDone(noti: Notification){
        print("upload success")
            
        var filename = noti.userInfo!["filename"] as! String
        
        if currentStatu == TEACHER {
            
            do {
                let serverController = serverAdd + "/uploadImg/"
                
                filename = "http://otvzyldeo.bkt.clouddn.com/" + filename + "?imageView2/2/w/500/h/500/q/30"
                
                let opt = try HTTP.POST(serverController, parameters: ["email": Global_userEmail,"courseid": currentCourseID,"img_path": filename])
                
                opt.start { response in
                    if let err = response.error{
                        print(err.localizedDescription)
                    }
                    else{
                        
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "createItemSuccess", sender: self)
                        }
                    }
                }
                
            } catch let error {
                print("got an error creating the request: \(error)")
            }
        
        }
        
        else {
            self.filePath = "http://otvzyldeo.bkt.clouddn.com/" + filename + "?imageView2/2/w/500/h/500/q/30"
            if self.originView == "Homework"{
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "photoToHomework", sender: self)
                }
                
            } else {
                do {
                    let serverController = serverAdd + "/uploadStImg/"
                    
                    filename = "http://otvzyldeo.bkt.clouddn.com/" + filename + "?imageView2/2/w/500/h/500/q/30"
                    
                    let opt = try HTTP.POST(serverController, parameters: ["email": Global_userEmail,"courseid": currentCourseID,"img_path": filename])
                    
                    opt.start { response in
                        if let err = response.error{
                            print(err.localizedDescription)
                        }
                        else{
                            
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "createItemSuccess", sender: self)
                            }
                        }
                    }
                    
                } catch let error {
                    print("got an error creating the request: \(error)")
                }
            }
            
            

        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "photoToHomework" {
            if let studentNewWorkViewController = segue.destination as? StudentNewWorkViewController{
                studentNewWorkViewController.strContent = self.originViewContent
                studentNewWorkViewController.image = self.photoImage
                studentNewWorkViewController.filePath = self.filePath
                studentNewWorkViewController.sectionID = self.originViewSectionID
            }
        }
    }
    
    func hmacsha1WithString(str: String, secretKey: String) -> NSData {
        
        let cKey  = secretKey.cString(using: String.Encoding.ascii)
        let cData = str.cString(using: String.Encoding.ascii)
        
        var result = [CUnsignedChar](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), cKey!, Int(strlen(cKey!)), cData!, Int(strlen(cData!)), &result)
        let hmacData: NSData = NSData(bytes: result, length: (Int(CC_SHA1_DIGEST_LENGTH)))
        return hmacData
    }
    
    func createQiniuToken(fileName: String) -> String {
        
        let oneHourLater = NSDate().timeIntervalSince1970 + 3600

        let scope = fileName.isEmpty ? kQiniuBucket : kQiniuBucket + ":" + fileName;
        let putPolicy: NSDictionary = ["scope": scope, "deadline": NSNumber(value: UInt64(oneHourLater))]
        let encodedPutPolicy = QNUrlSafeBase64.encode(putPolicy.jsonString())
        let sign = hmacsha1WithString(str: encodedPutPolicy!, secretKey: kQiniuSecretKey)
        let encodedSign = QNUrlSafeBase64.encode(sign as Data!)
        
        return kQiniuAccessKey + ":" + encodedSign! + ":" + encodedPutPolicy!
    }
    
    
    func uploadWithName(fileName: String, content: UIImage) {
        // 如果覆盖已有的文件，则指定文件名。否则如果同名文件已存在，会上传失败
        let token = createQiniuToken(fileName: fileName)
        
        var uploader: QNUploadManager = QNUploadManager()
        
        let preimage = content.fixOrientation()
        
        let data = UIImagePNGRepresentation(preimage!)
        
        uploader.put(data, key: fileName, token: token, complete: { (info, key, resp) -> Void in
            if (info?.isOK)! {
                let notificationName = Notification.Name("uploadImg")
                NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["filename": fileName])
                
            } else {
                NSLog("Error: " + (info?.error.localizedDescription)!)
            }
        }, option: nil)
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
        //print(saveImageToDocumentDirectory(photoImage!))
        let path = saveImageToDocumentDirectory(photoImage!)
        print("imapath:\(path)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddhhmmss"
        
        let currentDateString = dateFormatter.string(from: Date())
        
        var filename = currentDateString.appending(".jpg")
        
        uploadWithName(fileName: filename, content: photoImage!)
        
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
