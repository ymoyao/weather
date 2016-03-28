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
     计算宽度
     
     - parameter label: label
     
     - returns: 宽度
     */
    static func calWidthWithLabel(label:UILabel) -> CGFloat{
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineBreakMode = label.lineBreakMode;
        paragraphStyle.alignment = label.textAlignment;
        let str:NSString =  label.text!
        
        return str.boundingRectWithSize(CGSizeMake(2000, label.frame.size.height), options: [NSStringDrawingOptions.UsesLineFragmentOrigin,NSStringDrawingOptions.UsesFontLeading], attributes: [NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paragraphStyle], context: nil).size.width
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
    
    /**
     截屏
     
     - parameter view: 对应的view
     - parameter rect: frame
     
     - returns: 截取的图片
     */
    static func screenShot(view:UIView, rect:CGRect ) -> UIImage{
        UIGraphicsBeginImageContext(view.frame.size)
        let  context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        UIRectClip(rect)
        view.layer.renderInContext(context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
