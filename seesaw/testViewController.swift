//
//  testViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/23.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit
import SwiftHTTP

class testViewController: UIViewController {

    @IBAction func getBtnClick(_ sender: Any) {
        guard let url = URL(string: "http://115.159.187.59:8000/index/") else {return}
        
        let session = URLSession.shared
        session.dataTask(with: url){ (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                print(data)
                
            }
        }.resume()
    }
    
    @IBAction func postBtnClick(_ sender: Any) {
        guard let url = URL(string: "http://115.159.187.59:8000/index/") else {return}
        let parameters = ["username": "alex","email": "123@qq.com","password": "123456"]
        
        do{
            let opt = try HTTP.POST("http://115.159.187.59:8000/index/",parameters: parameters)
            opt.start{ response in
                
            }
        }catch let error{
            print("error")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
