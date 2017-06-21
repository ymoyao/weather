//
//  Utils.swift
//  Weathers
//
//  Created by SR on 16/3/7.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit
import Foundation

public struct Utils {
    
    /**
     屏幕宽
     
     - returns: CGFloat
     */
    static func screenWidth()-> CGFloat{
        return UIScreen.main.bounds.width
    }
    
    
    /**
     屏幕高
     
     - returns: CGFloat
     */
    static func screenHeight()-> CGFloat{
        return UIScreen.main.bounds.height
    }
    
    
    /**
     计算宽度
     
     - parameter label: label
     
     - returns: 宽度
     */
    static func calWidthWithLabel(_ label:UILabel) -> CGFloat{
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineBreakMode = label.lineBreakMode;
        paragraphStyle.alignment = label.textAlignment;
        let str:NSString =  label.text! as NSString
        
        return str.boundingRect(with: CGSize(width: 2000, height: label.frame.size.height), options: [NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading], attributes: [NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paragraphStyle], context: nil).size.width
    }

    
    /**
     date转字符串
     
     - parameter date: date对象
     - parameter dateFormat: 时间格式字符串
     
     - returns: 时间字符串
     */
    static func dateStr(_ date:Date, dateFormat:String?) ->String {
        let dateFormate = DateFormatter.init()
        if dateFormat != nil {
            dateFormate.dateFormat = dateFormat
        }
        return dateFormate.string(from: date)
    }
    
}
