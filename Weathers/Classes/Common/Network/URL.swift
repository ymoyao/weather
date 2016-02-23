//
//  URL.swift
//  Weathers
//
//  Created by SR on 16/2/15.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit


struct URL {
    
    //主地址
    private static var baseUrl = "http://apicloud.mob.com/"
    
    /**
     天气查询
     
     - returns: 天气接口
     */
    static func weatherUrl() -> String {
        return baseUrl + "v1/weather/query"
//        + "?key=\(key)&city=\(city)&province=\(province)"
//        key:String, city:String, province:String
    }
    

    
}
