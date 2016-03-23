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

    /**
     请求天气
     
     - parameter key:      key
     - parameter city:     城市
     - parameter province: 省份
     - parameter success:  成功
     - parameter fail:     失败
     */
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
    
    /**
     请求机器人回答
     
     - parameter key:     百度key
     - parameter info:    请求的内容
     - parameter userid:  用户id
     - parameter success: 成功
     - parameter fail:    失败
     */
    static func requestReporter(info:String, userid:String, success:([String : AnyObject]?) -> Void, fail:(String?) -> Void) ->Void {
//        879a6cb3afb84dbf4fc84a1df2ab7319
        
        let req = Alamofire.request(.GET, URL.reporterUrl(), parameters: ["key":"20db0ca5dbbbeb84239459c7ef24ff20","info":info,"userid":userid], encoding: ParameterEncoding.URL, headers: ["apikey":URL.baidukeyStr()])
        req.responseJSON { (response) -> Void in
            if (response.result.error != nil) {
                fail(response.result.error?.description)
            }
            else{
                success(response.result.value as? [String : AnyObject] )
            }
        }
    
    }
    
    /**
     百度-中国和世界天气预报
     
     - parameter city:    城市名称，国内城市支持中英文，国际城市支持英文
     - parameter success: 成功
     - parameter fail:    失败
     */
    static func requestHeweather(city:String, success:(AnyObject)? -> Void, fail:(String?)? -> Void) -> Void {
        let req = Alamofire.request(.GET, URL.heweather(), parameters: ["city":city], encoding: ParameterEncoding.URL, headers: ["apikey":URL.baidukeyStr()])
        
        req.responseJSON { (response) -> Void in
            switch response.result {
            case .Success:
                success(response.result.value)
            case .Failure:
                fail(response.result.error?.description)
            }
        }
    }
    
    
    /**
     获取和天气城市支持列表
     
     - parameter search:  收索类型
     - parameter key:     搜索key
     - parameter success: 成功
     - parameter fail:    失败
     */
    static func requestHeWeatherSupportCitys(search:String, key:String, success:(AnyObject?)-> Void,fail:(String?)->Void) -> Void {
        let req = Alamofire.request(.GET, URL.heweatherSupurtCity(), parameters: ["search":"allworld" ,"key":URL.heWeatherStr()], encoding: ParameterEncoding.URL)
        req.responseJSON { (response) -> Void in
            switch response.result {
            case .Success:
                success(response.result.value)
            case .Failure:
                fail(response.result.error?.description)
            }
        }
    }
    

}
