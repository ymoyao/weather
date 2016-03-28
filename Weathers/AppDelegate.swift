//
//  AppDelegate.swift
//  Weathers
//
//  Created by SR on 16/2/4.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit
import SVProgressHUD
import SQLite
import SwiftyJSON



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //window
        self.window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()
        let tabBar = MyTabBarController()
        self.window?.rootViewController = tabBar
        
        //设置导航栏
//        UINavigationBar.appearance().barTintColor = UIColor.init(colorLiteralRed: 18/255.0, green: 85/255.0, blue: 137/255.0, alpha: 1.0)
//        UINavigationBar.appearance().barTintColor = UIColor.init(colorLiteralRed: 60/255.0, green: 58/255.0, blue: 77/255.0, alpha: 1.0)
//        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
//        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        //设置SVProgressHUD
        SVProgressHUD.setBackgroundColor(UIColor.blackColor())
        SVProgressHUD.setForegroundColor(UIColor.whiteColor())
        SVProgressHUD.setFont(UIFont.systemFontOfSize(16.0))
        SVProgressHUD.setViewForExtension(UIApplication.sharedApplication().delegate?.window!)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Clear)
        
        //听写初始化
        IFlySpeechUtility.createUtility(URL.xunfeiKeyStr())

        //友盟分享注册
        UMSocialData.setAppKey(URL.youMengKeyStr())
        
        //QQ注册
        UMSocialQQHandler.setQQWithAppId(URL.QQ().AppId, appKey: URL.QQ().AppKey, url: URL.QQ().url)
        
        //微信注册
        UMSocialWechatHandler.setWXAppId(URL.WX().AppId, appSecret:URL.WX().appSecret , url: URL.WX().url)
        
        //新浪微博注册
        UMSocialSinaSSOHandler.openNewSinaSSOWithAppKey(URL.Sina().AppId, secret: URL.Sina().secret, redirectURL: URL.Sina().url)
        
        //没安装对应的客户端时会隐藏 如没安装QQ则QQ分享选项不会出现
        UMSocialConfig.hiddenNotInstallPlatforms([UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline])
        
        
        //监听计步(未完成就监控)
        if Health.IsFinishGoal() == false {
            Health.SharedInstance.stepCounter?.startStepCountingUpdatesToQueue(Health.SharedInstance.operation!, updateOn: 10, withHandler: { (step, date, error) -> Void in
                
                print("getLocalStep1\(Health.getLocalStep())")
                print("getGoalStep1\(Health.getGoalStep())")
                print("step1\(step)")
                Health.updateLocalStep(Health.SharedInstance.todayStep + step)
                if Health.getLocalStep() >= Health.getGoalStep() {
                    Health.SharedInstance.stepCounter?.stopStepCountingUpdates()
                    Health.finishGoal()
                    dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            SVProgressHUD.showSuccessWithStatus("恭喜您完成目标")
                        })
                    })
                    
                }
            })
        }
       
       
        
        //注册MOB云 API
        MobAPI.registerApp(URL.MobKeyStr())
        
//        MobAPI.sendRequest(MOBAPhoneRequest.addressRequestByPhone("13022138660")) { (response) -> Void in
//            if (response.error != nil) {
//                print("\(response.error)")
//            }
//            else{
//                
////                用MOBFJson 将response.responder 转为data
//                let data =  MOBFJson.jsonDataFromObject(response.responder)
////                swiftJson 用data转json对象
//                let json = JSON(data: data)
//                //取出对应的值
//                if let userName = json["city"].string {
//                    print("城市:\(userName)")
//                }
//                print("\(json["province"].string)")
//                
//                print("\(response.responder)")
//            }
//        }
        
      //API获取天气城市列表
//        NetWorkManager.requestHeWeatherSupportCitys("", key: "", success: { (response) -> Void in
//            let json = JSON.init(response!)
//            let jsonArray = json["city_info"]
//            
////            print("jsonArray：= \(jsonArray)")
//            
//            for (_,dict):(String,JSON) in jsonArray {
//            
//                let stmt = try! db.prepare("INSERT INTO city (cnty,province,city,aleph) VALUES (?,?,?,?)")
//                
//                var isAlpabet:Bool = false
//                for char in dict["city"].stringValue.utf8 {
//                    if (char > 64 && char < 91) || (char > 96 && char < 123) {
//                       isAlpabet = true
//                        break
//                    }
//                    
//                }
//                
//                if isAlpabet {
//                    let s =  String(dict["city"].stringValue.characters.first)
//                    
//                    let ranges = Range.init(start: s.endIndex.advancedBy(-3), end: s.endIndex.advancedBy(-2))
//                    
//                    try! stmt.run(dict["cnty"].stringValue,dict["prov"].stringValue,dict["city"].stringValue,s.substringWithRange(ranges) )
//                }
//                else {
//                    try! stmt.run(dict["cnty"].stringValue,dict["prov"].stringValue,dict["city"].stringValue, Utils.firstCharactor(dict["city"].stringValue) )
//                }
//        
//            
//            }
//            }) { (errorStr) -> Void in
//                print("asfas=--------das\(errorStr)")
//        }
//
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    //MARK: - app回调
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
       let ret = UMSocialSnsService.handleOpenURL(url)
        if ret == false { //其他sdk
        
            
        }
        return ret       //友盟分享
    }


}

