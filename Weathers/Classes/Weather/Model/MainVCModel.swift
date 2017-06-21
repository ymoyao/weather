//
//  MainVCModel.swift
//  Weathers
//
//  Created by SR on 16/2/14.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit

class MainVCModel: NSObject {
    
    var code = ""       //天气图标码
    var txt = ""        //天气描述
    
    var dir = ""        //风向
    var sc = ""         //风力
    
    var tmp = ""        //温度
    var vis = ""        //可见度
    
    
    var qlty = ""       //空气质量
    var pm25 = ""       //PM2.5
    

    var sportTxt = ""    //运动描述

    
    var city = ""       //城市
    var cnty = ""       //国家
    
    var loc = ""        //本地时间

    
    override func value(forUndefinedKey key: String) -> Any? {
        print(key)
        return nil
    }
}
