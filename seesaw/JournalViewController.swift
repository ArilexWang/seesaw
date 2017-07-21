//
//  JournalViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/17.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func photoBtnClick(_ sender: Any) {
        performSegue(withIdentifier: "segueToCamera", sender: self)
    }
    
    
    @IBAction func videoBtnClick(_ sender: Any) {
        performSegue(withIdentifier: "segueToRecording", sender: self)
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
