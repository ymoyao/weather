//
//  MyTabBar.swift
//  Weather
//
//  Created by SR on 16/1/28.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit
import Foundation
typealias TabClosure = (tag:Int) -> Void

class MyTabBar: UIImageView {
    
    var tabClosure:TabClosure?
    var tabBarModel: MyTabBarModel? {
        didSet{
            
        }
    }
    var lastBtn:UIButton? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.backgroundColor = UIColor.init(colorLiteralRed: 60/255.0, green: 58/255.0, blue: 77/255.0, alpha: 1.0)
        
        self.backgroundColor = UIColor.whiteColor()
        self.userInteractionEnabled = true
        let imageArr = ["weather_normal","health_normal","diary_normal"]
        let imageSelArr = ["weather_select","health_select","diary_select"]
        let btnW:CGFloat = UIScreen.mainScreen().bounds.width / CGFloat(imageArr.count)
        let btnH:CGFloat = 49.0
        var btnX:CGFloat = 0.0
        for var i = 0; i < imageArr.count; i++ {
      
            btnX = CGFloat(i) * btnW
            let btn = UIButton.init(type: UIButtonType.Custom)
            btn.tag = 100 + i
            btn.frame = CGRectMake(btnX, 0, btnW, btnH)
            btn.addTarget(self, action: Selector("btnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
            btn.setImage(UIImage.init(named: imageArr[i]), forState: UIControlState.Normal)
            btn.setImage(UIImage.init(named: imageSelArr[i]), forState: UIControlState.Selected)
           
            
            if i == 0 {
                lastBtn = btn
                lastBtn?.selected = true
            }
            
            self.addSubview(btn)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func btnClick(btn:UIButton) {
        lastBtn?.selected = false
        btn.selected = !btn.selected
        lastBtn = btn
        tabClosure!(tag: btn.tag - 100)
    }
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
