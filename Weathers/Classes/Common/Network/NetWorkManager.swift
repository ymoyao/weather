//
//  NetWorkManager.swift
//  Weathers
//
//  Created by SR on 16/2/15.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit
import Alamofire



struct NetWorkManager {


    static func requestWeather(key:String, city:String, province:String, success:([String : AnyObject]?) -> Void ,fail:(String?) -> Void) -> Void{
        let req = Alamofire.request(.GET, URL.weatherUrl(),parameters: ["key":key,"city":city,"province":province])
        
        req.responseJSON { (response) -> Void in

            if (response.result.error != nil) {
                fail(response.result.error?.description)
            }
            else{
                success(response.result.value as? [String : AnyObject])

            }
        }
    }
}
