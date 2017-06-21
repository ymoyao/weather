//
//  PhoneAffiliationViewController.swift
//  Weathers
//
//  Created by SR on 16/3/18.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class PhoneAffiliationViewController: RootViewController,UITextFieldDelegate {

    var textFeild:UITextField?
    var showLabel:UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()

        loadNavSubViews()
        loadSubViews()
        frameSubViews()
        // Do any additional setup after loading the view.
    }
    

    func loadNavSubViews() {
        self.view.backgroundColor = UIColor.white
        
        self.titleLabel?.text = self.navigationItem.title
    }
    
    func loadSubViews() {
        textFeild = Factory.customTextFeild(CGRect(x: Utils.screenWidth() / 2 - 200 / 2 , y: 100, width: 200, height: 30))
        textFeild?.delegate = self
        textFeild?.placeholder = "请输入手机号码"
        self.view.addSubview(textFeild!)
        
        showLabel = Factory.customLabel(CGRect(x: Utils.screenWidth() / 2 - 200 / 2, y: 150, width: 200, height: 100))
        showLabel?.textAlignment = NSTextAlignment.left
        self.view.addSubview(showLabel!)
    }
    
    func frameSubViews() {
        textFeild?.snp_makeConstraints({ (make) -> Void in
            make.left.equalTo(self.view).offset(50)
            make.right.equalTo(self.view).offset(-50)
            make.top.equalTo(self.view).offset(100)
            make.height.equalTo(30)
        })
        
        showLabel?.snp_makeConstraints({ (make) -> Void in
            make.left.right.equalTo(textFeild!)
            make.top.equalTo(textFeild!.snp_bottomMargin).offset(10)
            make.height.equalTo(200)
        })
    }
    
    

   /*
    {
    "city" : "上海",
    "zipCode" : "200000",
    "cityCode" : "021",
    "operator" : "联通如意通卡",
    "province" : "上海",
    "mobileNumber" : "1302213"
    }
    */
    //API 请求归属地
    func requestData() {
        SVProgressHUD.show(withStatus: "正在加载...")
        MobAPI.send(MOBAPhoneRequest.addressRequest(byPhone: textFeild!.text)) { (response) -> Void in
            if (response?.error != nil) {
                SVProgressHUD.showError(withStatus: "请输入正确电话号码")
                print("\(response?.error)")
            }
            else{
                
                //用MOBFJson 将response.responder 转为data
                let data =  MOBFJson.jsonData(from: response?.responder)
                //swiftJson 用data转json对象
                let json = JSON(data: data!)
                
                
        
                //取出对应的值
                var str = ""
                if let userName = json["city"].string {
                    str = "城市: " + userName + "\n"
                }
                
                if let userName = json["zipCode"].string {
                   str +=  "邮编: " + userName + "\n"
                }
                
                if let userName = json["operator"].string {
                    str +=  "卡类型: " + userName + "\n"
                }
                
                if let userName = json["province"].string {
                    str +=  "省份: " + userName + "\n"
                }
                
                self.showLabel?.text = str
                
                SVProgressHUD.dismiss()
                
                print("\(json)")
                
                print("\(response?.responder)")
            }
        }
    }
    
    
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFeild?.resignFirstResponder()
        requestData()
        return true
    }
    
//    override func leftBtnClick() {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
    
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
