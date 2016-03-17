//
//  PersonViewController.swift
//  Weather
//
//  Created by SR on 16/1/28.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import AVFoundation
import SwiftyJSON


class ReporterViewController: UIViewController,UITextFieldDelegate,IFlyRecognizerViewDelegate {

    
    //语音识别
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
    
    //输入框
    lazy var textfeild:UITextField? = {
    let textfeildTemp = UITextField.init()
        textfeildTemp.delegate = self
        textfeildTemp.borderStyle = UITextBorderStyle.RoundedRect
        textfeildTemp.returnKeyType = UIReturnKeyType.Done
        return textfeildTemp
        
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //开始识别
        recognizerView?.start()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.navigationItem.title = "机器人"
        
//        //初始化控件
//        loadSubViews()
//
//        //布局
//        frameSubViews()
        
        // Do any additional setup after loading the view.
    }

    //MARK: - 初始化控件
    func loadSubViews() {
        self.view.addSubview(textfeild!)
    }
    
    //MAKR: - API 请求数据
    func requestReporter(info:String, userid:String) {
        NetWorkManager.requestReporter(info, userid: userid, success: { (response) -> Void in
            
            let showStr = response?["showtext"] as? String
            
            guard showStr != nil else {
                SVProgressHUD.showErrorWithStatus("你在说啥?")
                return
            }
            //文本转语音
            self.textToVoice(showStr!)
            
            }) { (errorString) -> Void in
            SVProgressHUD.showErrorWithStatus(errorString)
        }
    }
    
    //MAKR: - 文字转语音
    func textToVoice(text:String) {
        let synthesizer = AVSpeechSynthesizer.init()
        let utterance = AVSpeechUtterance.init(string: text)
        synthesizer.speakUtterance(utterance)
    }
    
    //MAKR: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        requestReporter(textfeild!.text!, userid: "111")
        textfeild?.resignFirstResponder()
        return true
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
            requestReporter(resultStr, userid: "111")
            print("resultStr == \(resultStr)")
            print("jsons\(jsons)")
        }
    }
    
    func onError(error: IFlySpeechError!) {
        SVProgressHUD.dismiss()
    }
    
    //MARK: - 布局
    func frameSubViews() {
        textfeild?.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(self.view).offset(100)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSizeMake(200, 30))
        })
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
