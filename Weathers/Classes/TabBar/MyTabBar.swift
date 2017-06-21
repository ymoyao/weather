//
//  MyTabBar.swift
//  Weather
//
//  Created by SR on 16/1/28.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit
import Foundation
typealias TabClosure = (_ tag:Int) -> Void

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
        
        self.backgroundColor = UIColor.white
        self.isUserInteractionEnabled = true
        let imageArr = ["weather_normal","health_normal","diary_normal"]
        let imageSelArr = ["weather_select","health_select","diary_select"]
        let btnW:CGFloat = UIScreen.main.bounds.width / CGFloat(imageArr.count)
        let btnH:CGFloat = 49.0
        var btnX:CGFloat = 0.0
        for i in 0 ..< imageArr.count {
      
            btnX = CGFloat(i) * btnW
            let btn = UIButton.init(type: UIButtonType.custom)
            btn.tag = 100 + i
            btn.frame = CGRect(x: btnX, y: 0, width: btnW, height: btnH)
            btn.addTarget(self, action: #selector(MyTabBar.btnClick(_:)), for: UIControlEvents.touchUpInside)
            btn.setImage(UIImage.init(named: imageArr[i]), for: UIControlState())
            btn.setImage(UIImage.init(named: imageSelArr[i]), for: UIControlState.selected)
           
            
            if i == 0 {
                lastBtn = btn
                lastBtn?.isSelected = true
            }
            
            self.addSubview(btn)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func btnClick(_ btn:UIButton) {
        lastBtn?.isSelected = false
        btn.isSelected = !btn.isSelected
        lastBtn = btn
        tabClosure!(btn.tag - 100)
    }
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
