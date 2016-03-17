//
//  CommonNavImageView.swift
//  Weathers
//
//  Created by SR on 16/3/17.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit

class CommonNavImageView: UIImageView {

    var leftBtn:UIButton?               //左边按钮
    var rightBtn:UIButton?              //右边按钮
    var titleLabel:UILabel?             //标题View
    var navView:UIImageView?            //定制的导航栏背景
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNavView()
        loadNavTitleLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func loadNavView() {
        
        navView = UIImageView.init(frame: CGRectMake(0, 0, Utils.screenWidth(), 64))
        navView?.userInteractionEnabled = true
        navView?.backgroundColor = UIColor.init(colorLiteralRed: 60/255.0, green: 58/255.0, blue: 77/255.0, alpha: 1.0)
        self.addSubview(navView!)
    }
    
    func loadNavTitleLabel() {
        titleLabel = UILabel.init(frame: CGRectMake(0, 0, Utils.screenWidth() - 60, 30))
        titleLabel?.frame = CGRectMake(30, 32, Utils.screenWidth() - 60, 20)
        titleLabel?.textAlignment = NSTextAlignment.Center
        titleLabel?.textColor = UIColor.whiteColor()
        titleLabel?.font = UIFont.systemFontOfSize(17)
        navView?.addSubview(titleLabel!)
    }
    
    func loadNavleft() {
        
        leftBtn = UIButton.init(type: UIButtonType.Custom)
        leftBtn?.frame = CGRectMake(10, 32, 20, 20);
        leftBtn?.setImage(UIImage.init(named: "nav_back"), forState: UIControlState.Normal)
        leftBtn?.addTarget(self, action: Selector("leftBtnClick"), forControlEvents: UIControlEvents.TouchUpInside)
        navView?.addSubview(leftBtn!)
    }
    
    func loadNavleft(closure: (btn:UIButton) -> Void) {
        
        leftBtn = UIButton.init(type: UIButtonType.Custom)
        leftBtn?.frame = CGRectMake(10, 32, 20, 20);
        leftBtn?.setImage(UIImage.init(named: "nav_back"), forState: UIControlState.Normal)
        leftBtn?.addTarget(self, action: Selector("leftBtnClick"), forControlEvents: UIControlEvents.TouchUpInside)
        closure(btn: leftBtn!)
        navView?.addSubview(leftBtn!)
    }
    
    func loadNavRight(closure: (btn:UIButton) -> Void) {
        
        rightBtn = UIButton.init(type: UIButtonType.Custom)
        rightBtn?.frame = CGRectMake(Utils.screenWidth() - 30, 32, 20, 20)
        rightBtn?.setImage(UIImage.init(named: "nav_add"), forState: UIControlState.Normal)
        rightBtn?.addTarget(self, action: Selector("rightBtnClick"), forControlEvents: UIControlEvents.TouchUpInside)
        rightBtn?.hidden = true
        closure(btn: rightBtn!)
        navView?.addSubview(rightBtn!)
    }
    


    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
