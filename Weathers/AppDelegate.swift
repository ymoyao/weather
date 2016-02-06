//
//  AppDelegate.swift
//  Weathers
//
//  Created by SR on 16/2/4.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
        self.window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()
        //        let vc = MainViewController()
        let tabBar = MyTabBarController()
        self.window?.rootViewController = tabBar
        
        //设置导航栏
        UINavigationBar.appearance().barTintColor = UIColor.init(colorLiteralRed: 18/255.0, green: 85/255.0, blue: 137/255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        //注册
        MobAPI.registerApp("f30df66d4e10")
        
        MobAPI.sendRequest(MOBAPhoneRequest.addressRequestByPhone("13022138660")) { (response) -> Void in
            if (response.error != nil) {
                print("\(response.error)")
            }
            else{
                
                //用MOBFJson 将response.responder 转为data
                //                let data =  MOBFJson.jsonDataFromObject(response.responder)
                //swiftJson 用data转json对象
                //                let json = JSON(data: data)
                //                //取出对应的值
                //                if let userName = json["city"].string {
                //                    print("城市:\(userName)")
                //                }
                //                print("\(json["province"].string)")
                //                
                //                print("\(response.responder)")
            }
        }

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


}

