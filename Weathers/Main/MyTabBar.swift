//
//  MyTabBar.swift
//  Weather
//
//  Created by SR on 16/1/28.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit
import Foundation

class MyTabBar: UIImageView {
    
    var tabBarModel: MyTabBarModel? {
        didSet{
            
        }
    }
    var lastBtn:UIButton? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.userInteractionEnabled = true
        let imageArr = ["btn_nav_home","btn_nav_brand","btn_nav_mine"]
        let imageSelArr = ["btn_nav_home_selected","btn_nav_brand_selected","btn_nav_mine_selected"]
        let btnW:CGFloat = UIScreen.mainScreen().bounds.width / CGFloat(imageArr.count)
        let btnH:CGFloat = 49.0
        var btnX:CGFloat = 0.0
        for var i = 0; i < imageArr.count; i++ {
      
            btnX = CGFloat(i) * btnW
            let btn = UIButton.init(type: UIButtonType.Custom)
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
    }
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
