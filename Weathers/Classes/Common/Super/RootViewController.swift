//
//  RootViewController.swift
//  Weather
//
//  Created by SR on 16/2/1.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

class RootViewController: UIViewController {

    var leftBtn:UIButton?               //左边按钮
    var rightBtn:UIButton?              //右边按钮
    var titleLabel:UILabel?             //标题View
    var navView:UIImageView?            //定制的导航栏背景

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNavView()
        loadNavleft()
        loadNavRight()
        loadNavTitleLabel()
    
        //        leftBtn = UIBarButtonItem.init(image: UIImage.init(named: "btn_close"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnClick"))
        //        self.navigationItem.leftBarButtonItem = leftBtn
        
    
        // Do any additional setup after loading the view.
    }
    
    func loadNavView() {
        
        navView = UIImageView.init(frame: CGRectMake(0, 0, Utils.screenWidth(), 64))
        navView?.userInteractionEnabled = true
        navView?.backgroundColor = UIColor.init(colorLiteralRed: 60/255.0, green: 58/255.0, blue: 77/255.0, alpha: 1.0)
        self.view.addSubview(navView!)
    }
    
    func loadNavleft() {
    
        leftBtn = UIButton.init(type: UIButtonType.Custom)
        leftBtn?.frame = CGRectMake(10, 32, 20, 20);
        leftBtn?.titleLabel?.font = UIFont.systemFontOfSize(15)
        leftBtn?.setImage(UIImage.init(named: "nav_back"), forState: UIControlState.Normal)
        leftBtn?.addTarget(self, action: Selector("leftBtnClick"), forControlEvents: UIControlEvents.TouchUpInside)
        navView?.addSubview(leftBtn!)
    }
    
    func loadNavRight() {
        
        rightBtn = UIButton.init(type: UIButtonType.Custom)
        rightBtn?.frame = CGRectMake(Utils.screenWidth() - 30, 32, 20, 20)
        rightBtn?.titleLabel?.font = UIFont.systemFontOfSize(15)
        rightBtn?.setImage(UIImage.init(named: "nav_add"), forState: UIControlState.Normal)
        rightBtn?.addTarget(self, action: Selector("rightBtnClick"), forControlEvents: UIControlEvents.TouchUpInside)
        rightBtn?.hidden = true
        navView?.addSubview(rightBtn!)
    }
    
    func loadNavTitleLabel() {
        titleLabel = UILabel.init(frame: CGRectMake(0, 0, Utils.screenWidth() - 60, 30))
        titleLabel?.frame = CGRectMake(60, 32, Utils.screenWidth() - 120, 20)
        titleLabel?.textAlignment = NSTextAlignment.Center
        titleLabel?.textColor = UIColor.whiteColor()
        titleLabel?.font = UIFont.systemFontOfSize(17)
        navView?.addSubview(titleLabel!)
    }
    
    
    //MARK: - 左边按钮点击事件
    func leftBtnClick() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: - 右边按钮点击事件
    func rightBtnClick() {
        print("点击导航栏右边按钮")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
