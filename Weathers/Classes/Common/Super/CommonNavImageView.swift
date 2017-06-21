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
        
        navView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: Utils.screenWidth(), height: 64))
        navView?.isUserInteractionEnabled = true
        navView?.backgroundColor = UIColor.init(colorLiteralRed: 60/255.0, green: 58/255.0, blue: 77/255.0, alpha: 1.0)
        self.addSubview(navView!)
    }
    
    func loadNavTitleLabel() {
        titleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: Utils.screenWidth() - 60, height: 30))
        titleLabel?.frame = CGRect(x: 30, y: 32, width: Utils.screenWidth() - 60, height: 20)
        titleLabel?.textAlignment = NSTextAlignment.center
        titleLabel?.textColor = UIColor.white
        titleLabel?.font = UIFont.systemFont(ofSize: 17)
        navView?.addSubview(titleLabel!)
    }
    
    func loadNavleft() {
        
        leftBtn = UIButton.init(type: UIButtonType.custom)
        leftBtn?.frame = CGRect(x: 10, y: 32, width: 20, height: 20);
        leftBtn?.setImage(UIImage.init(named: "nav_back"), for: UIControlState())
        leftBtn?.addTarget(self, action: Selector("leftBtnClick"), for: UIControlEvents.touchUpInside)
        navView?.addSubview(leftBtn!)
    }
    
    func loadNavleft(_ closure: (_ btn:UIButton) -> Void) {
        
        leftBtn = UIButton.init(type: UIButtonType.custom)
        leftBtn?.frame = CGRect(x: 10, y: 32, width: 20, height: 20);
        leftBtn?.setImage(UIImage.init(named: "nav_back"), for: UIControlState())
        leftBtn?.addTarget(self, action: Selector("leftBtnClick"), for: UIControlEvents.touchUpInside)
        closure(leftBtn!)
        navView?.addSubview(leftBtn!)
    }
    
    func loadNavRight(_ closure: (_ btn:UIButton) -> Void) {
        
        rightBtn = UIButton.init(type: UIButtonType.custom)
        rightBtn?.frame = CGRect(x: Utils.screenWidth() - 30, y: 32, width: 20, height: 20)
        rightBtn?.setImage(UIImage.init(named: "nav_add"), for: UIControlState())
        rightBtn?.addTarget(self, action: Selector("rightBtnClick"), for: UIControlEvents.touchUpInside)
        rightBtn?.isHidden = true
        closure(rightBtn!)
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
