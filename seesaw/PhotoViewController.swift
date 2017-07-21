//
//  PhotoViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/18.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    var photoImage:UIImage?
    
    @IBOutlet weak var photoImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoImgView.image = photoImage
        
        // Do any additional setup after loading the view.
    }
    @IBAction func cancelBtnClick(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: "确定重新拍照吗？", preferredStyle: .actionSheet)
        
        let postToStudent = UIAlertAction(title: "删除并重新拍照", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "backToCamera", sender: self)
            
        })
        
//        let sendAnnouncement = UIAlertAction(title: "发送通知", style: .default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            print("send announcement")
//        })
//        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
