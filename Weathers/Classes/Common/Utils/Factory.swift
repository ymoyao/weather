//
//  Factory.swift
//  Weathers
//
//  Created by SR on 16/3/18.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit

public struct Factory {
    /**
     returnKeyType,borderStyle,font
     
     - parameter frame: frame
     
     - returns: textFeild
     */
    static func customTextFeild(frame:CGRect) -> UITextField {
        let textFeild = UITextField.init(frame:frame)
        textFeild.returnKeyType = UIReturnKeyType.Done
        textFeild.borderStyle = UITextBorderStyle.RoundedRect
        textFeild.font = UIFont.systemFontOfSize(15)
        return textFeild
    }
    
    
    /**
     普通Label
     font,textAlignment,textColor,numberOfLines
     
     - parameter frame: frame
     
     - returns: label
     */
    static func customLabel(frame:CGRect?) -> UILabel {
        var label:UILabel?
        if frame != nil {
          label = UILabel.init(frame: frame!)
        }
        else {
         label = UILabel.init()
        }
        
        label?.font = UIFont.systemFontOfSize(15)
        label?.textColor = UIColor.blackColor()
        label?.numberOfLines = 0
        return label!
    }
    
    
    
    /**
     详细Label
     
     - parameter frame:         frame
     - parameter font:          font
     - parameter textAlignment: textAlignment
     - parameter textColor:     textColor
     - parameter numberOfLines: numberOfLines
     
     - returns: label
     */
    static func detailLabel(frame:CGRect?,font:CGFloat?,textAlignment:NSTextAlignment?,textColor:UIColor?,numberOfLines:Int?) -> UILabel {
        let label:UILabel?
        if frame != nil {
            label = UILabel.init(frame: frame!)
        }
        else{
            label = UILabel.init()
        }
        
        if font != nil {
            label!.font = UIFont.systemFontOfSize(font!)
        }
        
        if textAlignment != nil {
            label!.textAlignment = textAlignment!
        }
        
        if textColor != nil {
            label!.textColor = textColor!
        }
        
        if numberOfLines != nil{
             label!.numberOfLines = 0
        }

        return label!
    }
}
