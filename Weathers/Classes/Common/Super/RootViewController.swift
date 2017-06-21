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
    public func onResult(_ resultArray: [Any]!, isLast: Bool) {
        
    }


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
        recognizerViewTemp?.delegate = self
        
        //应用领域
        recognizerViewTemp?.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN())
        
        //保存地址
        recognizerViewTemp?.setParameter("asrview.pcm", forKey: IFlySpeechConstant.asr_AUDIO_PATH())
        
        //无标点符号
        recognizerViewTemp?.setParameter("0", forKey: IFlySpeechConstant.asr_PTT())
        
        
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
        
        navView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: Utils.screenWidth(), height: 64))
        navView?.isUserInteractionEnabled = true
        navView?.backgroundColor = UIColor.init(colorLiteralRed: 60/255.0, green: 58/255.0, blue: 77/255.0, alpha: 1.0)
        self.view.addSubview(navView!)
    }
    
    
    func loadMenuBtn() {
        menuBtn = UIButton.init(type: UIButtonType.custom)
        menuBtn?.frame = CGRect(x: Utils.screenWidth() / 2 - 50/2, y: 64, width: 50, height: 50)
        menuBtn?.addTarget(self, action: Selector("btnClick"), for: UIControlEvents.touchUpInside)
        self.view.addSubview(menuBtn!)
    }
    
    func loadNavleft() {
    
        leftBtn = UIButton.init(type: UIButtonType.custom)
        leftBtn?.frame = CGRect(x: 10, y: 32, width: 20, height: 20);
        leftBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        leftBtn?.setImage(UIImage.init(named: "nav_back"), for: UIControlState())
        leftBtn?.addTarget(self, action: #selector(RootViewController.leftBtnClick), for: UIControlEvents.touchUpInside)
        navView?.addSubview(leftBtn!)
    }
    
    func loadNavRight() {
        
        rightBtn = UIButton.init(type: UIButtonType.custom)
        rightBtn?.frame = CGRect(x: Utils.screenWidth() - 30, y: 32, width: 20, height: 20)
        rightBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightBtn?.setImage(UIImage.init(named: "nav_add"), for: UIControlState())
        rightBtn?.addTarget(self, action: #selector(RootViewController.rightBtnClick), for: UIControlEvents.touchUpInside)
        rightBtn?.isHidden = true
        navView?.addSubview(rightBtn!)
    }
    
    func loadNavRightT() {
        
        rightBtnT = UIButton.init(type: UIButtonType.custom)
        rightBtnT?.frame = CGRect(x: Utils.screenWidth() - 55, y: 32, width: 20, height: 20)
        rightBtnT?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightBtnT?.setImage(UIImage.init(named: "grayStar"), for: UIControlState())
        rightBtnT?.setImage(UIImage.init(named: "redStarSel"), for: UIControlState.selected)
        rightBtnT?.addTarget(self, action: #selector(RootViewController.rightBtnTClick), for: UIControlEvents.touchUpInside)
        rightBtnT?.isHidden = true
        navView?.addSubview(rightBtnT!)
    }
    
    func loadNavTitleLabel() {
        titleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: Utils.screenWidth() - 60, height: 30))
        titleLabel?.frame = CGRect(x: 60, y: 32, width: Utils.screenWidth() - 120, height: 20)
        titleLabel?.textAlignment = NSTextAlignment.center
        titleLabel?.textColor = UIColor.white
        titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        titleLabel?.isUserInteractionEnabled = true
        let tapges = UITapGestureRecognizer.init(target: self, action: #selector(RootViewController.titleTapGes))
        titleLabel?.addGestureRecognizer(tapges)
        navView?.addSubview(titleLabel!)
    }
    
    func loadMenuView() {
        menuView = UIImageView.init(frame: CGRect(x: 0, y: -1 * self.menuHeight, width: Utils.screenWidth(), height: self.menuHeight))
        menuView?.backgroundColor = UIColor.black
        menuView?.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(RootViewController.bgTapGes))
        menuView?.addGestureRecognizer(tap)
//        menuView?.alpha = 0.7
        
        let width:CGFloat = 80
        let heigth:CGFloat = 35
        let spaceX = (Utils.screenWidth() - width * menuOneLineNum ) / (menuOneLineNum + 1)
        let spaceOriginY:CGFloat = 40
        let spaceY:CGFloat = 10
        for i in 0 ..< self.menuArray.count {
            let originX = spaceX + (CGFloat(i).truncatingRemainder(dividingBy: menuOneLineNum)) * (width + spaceX)
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
            let btn = UIButton.init(type: UIButtonType.custom)
            btn.frame = CGRect(x: originX, y: originY, width: width, height: heigth)
            btn.layer.cornerRadius = 9
            btn.layer.borderColor = UIColor.white.cgColor
            btn.layer.borderWidth = 1
            btn.tag = 10000 + i
            btn.setTitle(self.menuArray[i], for: UIControlState())
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.addTarget(self, action: #selector(RootViewController.menuBtnClick(_:)), for: UIControlEvents.touchUpInside)
            menuView?.addSubview(btn)
        }
        UIApplication.shared.keyWindow?.addSubview(menuView!)
    }
    
    
    //MARK: - 左边按钮点击事件
    func leftBtnClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - 右边按钮点击事件
    func rightBtnClick() {
        print("点击导航栏右边按钮")
    }
    
    func rightBtnTClick() {
        print("点击导航栏右边按钮")
    }
    
    //MARK: - 跳转到对应的页面
    func menuBtnClick(_ btn:UIButton) {
        switch btn.tag - 10000 {
        case 0:
            
            if self.tabBarController != nil {
                self.tabBarController!.tabBar.isHidden = false
            }
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frame = self.view.frame
                frame.origin.y = 0
                self.view.frame = frame
                
                var frameM = self.menuView!.frame
                frameM.origin.y = -1 * self.menuHeight
                self.menuView!.frame = frameM
                
                self.recognizerView?.start()
            }) 
        case 1:
            let vc = PhoneAffiliationViewController()
           
            backNormal(vc, tag: btn.tag - 10000)
        case 2:
            let vc = FeedbackViewController()
            backNormal(vc, tag: btn.tag - 10000)

        default:break
        }
    }
    
    func backNormal(_ vc:UIViewController, tag:NSInteger) {
        
        self.tabBarController!.tabBar.isHidden = false
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
            self.tabBarController!.tabBar.isHidden = false
        }
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            var frame = self.view.frame
            frame.origin.y = 0
            self.view.frame = frame
            
            var frameM = self.menuView!.frame
            frameM.origin.y = -1 * self.menuHeight
            self.menuView!.frame = frameM
        }) 
    }
    
    //MARK: - 单击标题事件
    func titleTapGes() {
  
        guard self.navigationController?.viewControllers.count == 1 else {
            return
        }
        
        if self.view.frame.origin.y == 0 {
            
            if self.tabBarController != nil {
                self.tabBarController!.tabBar.isHidden = true
            }
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frame = self.view.frame
                frame.origin.y = self.menuHeight
                self.view.frame = frame
                
                var frameM = self.menuView!.frame
                frameM.origin.y = 0
                self.menuView!.frame = frameM
            }) 
        }
        else{
            
            if self.tabBarController != nil {
                self.tabBarController!.tabBar.isHidden = false
            }
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frame = self.view.frame
                frame.origin.y = 0
                self.view.frame = frame
                
                var frameM = self.menuView!.frame
                frameM.origin.y = -1 * self.menuHeight
                self.menuView!.frame = frameM
            }) 
        }
    }
    
    
    
    //MARK: - API 机器人问答
    func requestReporter(_ info:String, userid:String) {
        NetWorkManager.requestReporter(info, userid: userid, success: { (response) -> Void in
            
            let showStr = response?["text"] as? String //showtext
            
            guard showStr != nil else {
//                SVProgressHUD.showErrorWithStatus("你在说啥?")
                return
            }
            //文本转语音
            self.textToVoice(showStr!)
            
            }) { (errorString) -> Void in
                SVProgressHUD.showError(withStatus: errorString)
        }
    }
    
    //MARK: - 文字转语音
    func textToVoice(_ text:String) {
        let synthesizer = AVSpeechSynthesizer.init()
        let utterance = AVSpeechUtterance.init(string: text)
        synthesizer.speak(utterance)
    }
    
    //MARK: - IFlyRecognizerViewDelegate
    func onResults(_ resultArray: [AnyObject]!, isLast: Bool) {
        guard resultArray != nil && resultArray.count > 0 else {
            return
        }
        
        let dict = resultArray[0] as! NSDictionary
        for keyStr in dict.keyEnumerator() {
             let data = (keyStr as! String).data
            let dataStr = data(String.Encoding.utf8, true)
//            let data = (keyStr as AnyObject).data(using: String.Encoding.utf8)
            let jsons = JSON.init(data: dataStr!)
            let dataArr = jsons["ws"]
            var resultStr = ""
            for (_,subJson):(String,JSON) in dataArr {
                let str = subJson["cw"][0]["w"].stringValue
                resultStr.append(str)
                print("w == \(str)")
            }
            requestReporter(resultStr, userid: "eb2edb736")
            print("resultStr == \(resultStr)")
            print("jsons\(jsons)")
        }
    }
    
    func onError(_ error: IFlySpeechError!) {
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
