//
//  Extension.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/16.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha:alpha
        )
    }
}

func isEamilValidation(string: String) -> Bool{
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    
    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    
    let result = emailTest.evaluate(with: string)
    
    return result
}



extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
}


extension Date{
    func startOfMonth() -> Date{
        let components: DateComponents = Calendar.current.dateComponents([.year, .month], from: Date())
        
        let startOfMonth = Calendar.current.date(from: components)
        
        return startOfMonth!
    }
    
    func getDayOfWeek() -> Int{
        let components: DateComponents = Calendar.current.dateComponents([.weekday] , from: self)
        let weekDay = components.weekday
        
        return weekDay!
    }
    
    func endOfMonth() -> Date {    
        var comps2 = DateComponents()
        comps2.month = 1
        comps2.day = -1
        let endOfMonth = Calendar.current.date(byAdding: comps2, to: startOfMonth())
        
        return endOfMonth!
        
    }
    
    func iStartOfMonth() -> Int{
        let components: DateComponents = Calendar.current.dateComponents([.year, .month], from: self)
        
        let StartOfMonth = Calendar.current.date(from: components)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        
        let strStartDay: String! = dateFormatter.string(from: StartOfMonth!)
        
        let iStartDay:Int = Int(strStartDay)!
        
        
        return iStartDay
    }
    
    
    func monthDay() -> Int{
        
        
        
        let startDay = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))
        let endDay = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        
        let strStartDay: String! = dateFormatter.string(from: startDay!)
        let strEndDay: String! = dateFormatter.string(from: endDay)
        
        let iStartDay:Int = Int(strStartDay)!
        let iEndDay = Int(strEndDay)!
        
        let monthDay = iEndDay - iStartDay + 1
        
        return monthDay
        
        
    }
    
    
    
    
}
