//
//  ViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/16.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var buttonView: UIView!
    
    @IBOutlet weak var calendarBtn: UIButton!
    @IBOutlet weak var JournalBtn: UIButton!
    
    let selectedMonthColor = UIColor.white
    let monthColor = UIColor(colorWithHexValue: 0xa6a6a6)
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init calendarView
        setupCalendarView();
        
        setButtonImg()
        //setupButtonView()
        
    }
    
//    @IBAction func listBtnClick(_ sender: Any) {
//        listBtn.setImage(#imageLiteral(resourceName: "listViewSeleted"), for: .normal)
//        calendarBtn.setImage(#imageLiteral(resourceName: "calendarImg"), for: .normal)
//        
//    }
//
//    @IBAction func calendarBtnClick(_ sender: Any) {
//        listBtn.setImage(#imageLiteral(resourceName: "listImg"), for: .normal)
//        calendarBtn.setImage(#imageLiteral(resourceName: "calendarSeleted"), for: .normal)
//        
//    }
    
    func plubBtnClick() {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let postToStudent = UIAlertAction(title: "发送到学生日记", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.performSegue(withIdentifier: "calendarToJour", sender: self)
            
        })
        
        let sendAnnouncement = UIAlertAction(title: "发送通知", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("send announcement")
        })
        
        let cancelAction = UIAlertAction(title: "放弃", style: .cancel, handler:  {
            (alert: UIAlertAction!) -> Void in
            print("cancel")
        })
        
        optionMenu.addAction(postToStudent)
        optionMenu.addAction(sendAnnouncement)
        optionMenu.addAction(cancelAction)
        
       
        present(optionMenu, animated: true, completion: nil)
    
    
    }
    
    
//    func setupButtonView(){
//        settingBtn.setImage(#imageLiteral(resourceName: "settingBtnSelected"), for: .highlighted)
//        JournalBtn.setImage(#imageLiteral(resourceName: "JournalSeleted"), for: .normal)
//        
//    }
    
    func setBtnClick(){
        performSegue(withIdentifier: "calendarToSet", sender: self)
    }
    
    
    func setButtonImg(){
        
        let button = UIButton.init(type: .custom)
        //set image for button
        button.setImage(UIImage(named: "defaultHead.png"), for: UIControlState.normal)
        //add function for button
        button.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let barButton = UIBarButtonItem(customView: button)
        
        
        self.navigationItem.leftBarButtonItem = barButton
        
        
        
        if currentStatu == TEACHER{
            let plusButton = UIButton.init(type: .custom)
            
            plusButton.setImage(UIImage(named: "plusBtnImg.png"), for: UIControlState.normal)
            
            plusButton.addTarget(self, action: #selector(ViewController.plubBtnClick), for: UIControlEvents.touchUpInside)
            
            plusButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            
            let plusBarButton = UIBarButtonItem(customView: plusButton)
            
            let settingButton = UIButton.init(type: .custom)
            
            settingButton.setImage(UIImage(named: "settingBtnImg.png"), for: UIControlState.normal)
            
            settingButton.addTarget(self, action: #selector(ViewController.setBtnClick), for: UIControlEvents.touchUpInside)
            
            settingButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            
            let settingBarButton = UIBarButtonItem(customView: settingButton)
            
            let gap = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            gap.width = 20
            
            self.navigationItem.rightBarButtonItems = [plusBarButton, gap ,settingBarButton]
        }
            
            //学生端
        else {
            let plusButton = UIButton.init(type: .custom)
            
            plusButton.setImage(UIImage(named: "plusBtnImg.png"), for: UIControlState.normal)
            
            plusButton.addTarget(self, action: #selector(DefaultViewController.stPlusBtnClick), for: UIControlEvents.touchUpInside)
            
            plusButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            
            let plusBarButton = UIBarButtonItem(customView: plusButton)
            
            self.navigationItem.rightBarButtonItem = plusBarButton
        }
        
        
    }
    
    
    func setupCalendarView(){
        //setup calendar spacing
        calendarView.minimumLineSpacing = 0.3;
        calendarView.minimumInteritemSpacing = 0.3;
        
        //setup labels
        calendarView.visibleDates { visibleDates in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        
        
        //selete button
        buttonView.addBottomBorderWithColor(color: UIColor.gray, width: 0.3)
    }
    
    func handleCurrentDay(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CustomCell else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        
        let currentDateString = dateFormatter.string(from: Date())
        let cellStateDateString = dateFormatter.string(from: cellState.date)
        
        //set today color
        if currentDateString == cellStateDateString {
            validCell.dateLabel.textColor = UIColor.white
            validCell.todayView.isHidden = false
        }else{
            validCell.todayView.isHidden = true
        }
    }
    
    
    
    
    func handleCelltextColor(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CustomCell else { return }
        if cellState.isSelected{
            validCell.dateLabel.textColor = selectedMonthColor
        } else{
            if cellState.dateBelongsTo == .thisMonth{
                validCell.dateLabel.textColor = monthColor
                
            } else{
                validCell.dateLabel.textColor = UIColor.white
            }
        }
    }

    
    func handleCellSeleted(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CustomCell else {
            return
        }
        if validCell.isSelected{
            validCell.selectedView.isHidden = false
        } else{
            validCell.selectedView.isHidden = true
        }
    }
    
    
    func setupViewsOfCalendar(from visbleDates: DateSegmentInfo){
        let date = visbleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "M"
        self.month.text = self.formatter.string(from: date)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}





extension ViewController: JTAppleCalendarViewDataSource {
    func numberOfRows(forDate date: Date) -> Int {
        let weekday = date.getDayOfWeek()
        let monthDays =  date.monthDay()
        
        
        if weekday == 1 && monthDays == 28 {
            return 4
        } else if weekday < 6 || (weekday == 6 && monthDays < 31) || (weekday == 7 && monthDays < 30) {
            return 5
        } else {
            return 6
        }
    }
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        
        
        let startDate = Date().startOfMonth()
        let endDate = Date().endOfMonth()
        
        let rowNum = numberOfRows(forDate: startDate)
    
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: rowNum)
        return parameters
    }
    
    
}


extension ViewController: JTAppleCalendarViewDelegate {
    //Display the cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        cell.dateLabel.text = cellState.text
        
        handleCellSeleted(view: cell, cellState: cellState)
        handleCelltextColor(view: cell, cellState: cellState)
        handleCurrentDay(view: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSeleted(view: cell, cellState: cellState)
        handleCelltextColor(view: cell, cellState: cellState)
        handleCurrentDay(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSeleted(view: cell, cellState: cellState)
        handleCelltextColor(view: cell, cellState: cellState)
        handleCurrentDay(view: cell, cellState: cellState)
    }
    
}




