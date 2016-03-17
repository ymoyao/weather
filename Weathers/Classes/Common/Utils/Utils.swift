//
//  Utils.swift
//  Weathers
//
//  Created by SR on 16/3/7.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit

public struct Utils {
    
    /**
     屏幕宽
     
     - returns: CGFloat
     */
    static func screenWidth()-> CGFloat{
        return UIScreen.mainScreen().bounds.width
    }
    
    
    /**
     屏幕高
     
     - returns: CGFloat
     */
    static func screenHeight()-> CGFloat{
        return UIScreen.mainScreen().bounds.height
    }
    
    /**
     date转字符串
     
     - parameter date: date对象
     - parameter dateFormat: 时间格式字符串
     
     - returns: 时间字符串
     */
    static func dateStr(date:NSDate, dateFormat:String?) ->String {
        let dateFormate = NSDateFormatter.init()
        if dateFormat != nil {
            dateFormate.dateFormat = dateFormat
        }
        return dateFormate.stringFromDate(date)
    }
    
}
