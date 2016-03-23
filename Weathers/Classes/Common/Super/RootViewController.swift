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
import SwiftyJSON

class RootViewController: UIViewController,IFlyRecognizerViewDelegate {

    var leftBtn:UIButton?               //左边按钮
    var rightBtn:UIButton?              //右边按钮
    var rightBtnT:UIButton?             //右边第二个按钮
    var titleLabel:UILabel?             //标题View
    var menuBtn:UIButton?               //菜单按钮
    var navView:UIImageView?            //定制的导航栏背景

    var menuView:UIImageView?           //菜单视图
    var menuHeight:CGFloat = 300        //菜单视图高度
    var menuArray = ["机器人","号码归属地","关于"]
    let menuOneLineNum:CGFloat = 3
    
    
    lazy var recognizerView:IFlyRecognizerView? = {
        let recognizerViewTemp = IFlyRecognizerView.init(center: self.view.center)
        recognizerViewTemp.delegate = self
        
        //应用领域
        recognizerViewTemp.setParameter("iat", forKey: IFlySpeechConstant.IFLY_DOMAIN())
        
        //保存地址
        recognizerViewTemp.setParameter("asrview.pcm", forKey: IFlySpeechConstant.ASR_AUDIO_PATH())
        
        //无标点符号
        recognizerViewTemp?.setParameter("0", forKey: IFlySpeechConstant.ASR_PTT())
        
        
        //        recognizerViewTemp.setParameter("json", forKey: IFlySpeechConstant.RESULT_TYPE())
        return recognizerViewTemp
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNavView()
        loadNavTitleLabel()
        loadNavleft()
        loadNavRightT()
        loadNavRight()
        
        
        loadMenuView()
        // Do any additional setup after loading the view.
    }
    
    
    
    func loadNavView() {
        
        navView = UIImageView.init(frame: CGRectMake(0, 0, Utils.screenWidth(), 64))
        navView?.userInteractionEnabled = true
        navView?.backgroundColor = UIColor.init(colorLiteralRed: 60/255.0, green: 58/255.0, blue: 77/255.0, alpha: 1.0)
        self.view.addSubview(navView!)
    }
    
    
    func loadMenuBtn() {
        menuBtn = UIButton.init(type: UIButtonType.Custom)
        menuBtn?.frame = CGRectMake(Utils.screenWidth() / 2 - 50/2, 64, 50, 50)
        menuBtn?.addTarget(self, action: Selector("btnClick"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(menuBtn!)
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
    
    func loadNavRightT() {
        
        rightBtnT = UIButton.init(type: UIButtonType.Custom)
        rightBtnT?.frame = CGRectMake(Utils.screenWidth() - 55, 32, 20, 20)
        rightBtnT?.titleLabel?.font = UIFont.systemFontOfSize(15)
        rightBtnT?.setImage(UIImage.init(named: "grayStar"), forState: UIControlState.Normal)
        rightBtnT?.setImage(UIImage.init(named: "redStarSel"), forState: UIControlState.Selected)
        rightBtnT?.addTarget(self, action: Selector("rightBtnTClick"), forControlEvents: UIControlEvents.TouchUpInside)
        rightBtnT?.hidden = true
        navView?.addSubview(rightBtnT!)
    }
    
    func loadNavTitleLabel() {
        titleLabel = UILabel.init(frame: CGRectMake(0, 0, Utils.screenWidth() - 60, 30))
        titleLabel?.frame = CGRectMake(60, 32, Utils.screenWidth() - 120, 20)
        titleLabel?.textAlignment = NSTextAlignment.Center
        titleLabel?.textColor = UIColor.whiteColor()
        titleLabel?.font = UIFont.systemFontOfSize(17)
        
        titleLabel?.userInteractionEnabled = true
        let tapges = UITapGestureRecognizer.init(target: self, action: Selector("titleTapGes"))
        titleLabel?.addGestureRecognizer(tapges)
        navView?.addSubview(titleLabel!)
    }
    
    func loadMenuView() {
        menuView = UIImageView.init(frame: CGRectMake(0, -1 * self.menuHeight, Utils.screenWidth(), self.menuHeight))
        menuView?.backgroundColor = UIColor.blackColor()
        menuView?.userInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: Selector("bgTapGes"))
        menuView?.addGestureRecognizer(tap)
//        menuView?.alpha = 0.7
        
        let width:CGFloat = 80
        let heigth:CGFloat = 35
        let spaceX = (Utils.screenWidth() - width * menuOneLineNum ) / (menuOneLineNum + 1)
        let spaceOriginY:CGFloat = 40
        let spaceY:CGFloat = 10
        for var i = 0; i < self.menuArray.count ; i++ {
            let originX = spaceX + (CGFloat(i) % menuOneLineNum) * (width + spaceX)
            let originY = spaceOriginY + CGFloat(i / Int(menuOneLineNum)) * (heigth + spaceY)
//            let label = UILabel.init(frame: CGRectMake(originX, originY, width, heigth))
//            label.text = self.menuArray[i]
//            label.numberOfLines = 0
//            label.layer.cornerRadius = 9
//            label.layer.borderColor = UIColor.whiteColor().CGColor
//            label.layer.borderWidth = 1
//            label.font = UIFont.systemFontOfSize(14)
//            label.textAlignment = NSTextAlignment.Center
//            label.textColor = UIColor.whiteColor()
//            label.backgroundColor = UIColor.redColor()
            let btn = UIButton.init(type: UIButtonType.Custom)
            btn.frame = CGRectMake(originX, originY, width, heigth)
            btn.layer.cornerRadius = 9
            btn.layer.borderColor = UIColor.whiteColor().CGColor
            btn.layer.borderWidth = 1
            btn.tag = 10000 + i
            btn.setTitle(self.menuArray[i], forState: UIControlState.Normal)
            btn.titleLabel?.font = UIFont.systemFontOfSize(14)
            btn.addTarget(self, action: Selector("menuBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
            menuView?.addSubview(btn)
        }
        UIApplication.sharedApplication().keyWindow?.addSubview(menuView!)
    }
    
    
    //MARK: - 左边按钮点击事件
    func leftBtnClick() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: - 右边按钮点击事件
    func rightBtnClick() {
        print("点击导航栏右边按钮")
    }
    
    func rightBtnTClick() {
        print("点击导航栏右边按钮")
    }
    
    //MARK: - 跳转到对应的页面
    func menuBtnClick(btn:UIButton) {
        switch btn.tag - 10000 {
        case 0:
            
            if self.tabBarController != nil {
                self.tabBarController!.tabBar.hidden = false
            }
            UIView.animateWithDuration(0.3) { () -> Void in
                var frame = self.view.frame
                frame.origin.y = 0
                self.view.frame = frame
                
                var frameM = self.menuView!.frame
                frameM.origin.y = -1 * self.menuHeight
                self.menuView!.frame = frameM
                
                self.recognizerView?.start()
            }
        case 1:
            let vc = PhoneAffiliationViewController()
           
            backNormal(vc, tag: btn.tag - 10000)
        case 2:
            let vc = FeedbackViewController()
            backNormal(vc, tag: btn.tag - 10000)

        default:break
        }
    }
    
    func backNormal(vc:UIViewController, tag:NSInteger) {
        
        self.tabBarController!.tabBar.hidden = false
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.title = self.menuArray[tag]
        var frameM = self.menuView!.frame
        frameM.origin.y = -1 * self.menuHeight
        self.menuView!.frame = frameM
        
        var frame = self.view.frame
        frame.origin.y = 0
        self.view.frame = frame
        
        self.navigationController?.pushViewController(vc, animated: true)
//        self.presentViewController(vc, animated: true, completion: { () -> Void in
//            
//        })
    }
    
    //MARK: - 点击背景
    func bgTapGes() {
        if self.tabBarController != nil {
            self.tabBarController!.tabBar.hidden = false
        }
        UIView.animateWithDuration(0.3) { () -> Void in
            var frame = self.view.frame
            frame.origin.y = 0
            self.view.frame = frame
            
            var frameM = self.menuView!.frame
            frameM.origin.y = -1 * self.menuHeight
            self.menuView!.frame = frameM
        }
    }
    
    //MARK: - 单击标题事件
    func titleTapGes() {
  
        guard self.navigationController?.viewControllers.count == 1 else {
            return
        }
        
        if self.view.frame.origin.y == 0 {
            
            if self.tabBarController != nil {
                self.tabBarController!.tabBar.hidden = true
            }
            UIView.animateWithDuration(0.3) { () -> Void in
                var frame = self.view.frame
                frame.origin.y = self.menuHeight
                self.view.frame = frame
                
                var frameM = self.menuView!.frame
                frameM.origin.y = 0
                self.menuView!.frame = frameM
            }
        }
        else{
            
            if self.tabBarController != nil {
                self.tabBarController!.tabBar.hidden = false
            }
            UIView.animateWithDuration(0.3) { () -> Void in
                var frame = self.view.frame
                frame.origin.y = 0
                self.view.frame = frame
                
                var frameM = self.menuView!.frame
                frameM.origin.y = -1 * self.menuHeight
                self.menuView!.frame = frameM
            }
        }
    }
    
    
    
    //MARK: - API 机器人问答
    func requestReporter(info:String, userid:String) {
        NetWorkManager.requestReporter(info, userid: userid, success: { (response) -> Void in
            
            let showStr = response?["text"] as? String //showtext
            
            guard showStr != nil else {
//                SVProgressHUD.showErrorWithStatus("你在说啥?")
                return
            }
            //文本转语音
            self.textToVoice(showStr!)
            
            }) { (errorString) -> Void in
                SVProgressHUD.showErrorWithStatus(errorString)
        }
    }
    
    //MARK: - 文字转语音
    func textToVoice(text:String) {
        let synthesizer = AVSpeechSynthesizer.init()
        let utterance = AVSpeechUtterance.init(string: text)
        synthesizer.speakUtterance(utterance)
    }
    
    //MARK: - IFlyRecognizerViewDelegate
    func onResult(resultArray: [AnyObject]!, isLast: Bool) {
        guard resultArray != nil && resultArray.count > 0 else {
            return
        }
        
        let dict = resultArray[0] as! NSDictionary
        for keyStr in dict.keyEnumerator() {
            
            let data = keyStr.dataUsingEncoding(NSUTF8StringEncoding)
            let jsons = JSON.init(data: data!)
            let dataArr = jsons["ws"]
            var resultStr = ""
            for (_,subJson):(String,JSON) in dataArr {
                let str = subJson["cw"][0]["w"].stringValue
                resultStr.appendContentsOf(str)
                print("w == \(str)")
            }
            requestReporter(resultStr, userid: "eb2edb736")
            print("resultStr == \(resultStr)")
            print("jsons\(jsons)")
        }
    }
    
    func onError(error: IFlySpeechError!) {
        SVProgressHUD.dismiss()
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
