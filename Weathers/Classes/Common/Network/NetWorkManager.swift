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
    static func requestWeather(_ key:String, city:String, province:String, success:@escaping ([String : AnyObject]?) -> Void ,fail:@escaping (String?) -> Void) -> Void{
        
        let req = Alamofire.request(URL.weatherUrl(), method: .get, parameters: ["key":key,"city":city,"province":province],encoding: URLEncoding.default, headers: nil)

        req.responseJSON { (response) -> Void in

            if (response.result.error != nil) {
                fail(response.result.error.debugDescription)
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
    static func requestReporter(_ info:String, userid:String, success:@escaping ([String : AnyObject]?) -> Void, fail:@escaping (String?) -> Void) ->Void {
//        879a6cb3afb84dbf4fc84a1df2ab7319
        
        let req = Alamofire.request(URL.reporterUrl(),method: .get, parameters: ["key":"20db0ca5dbbbeb84239459c7ef24ff20","info":info,"userid":userid], encoding: URLEncoding.default, headers: ["apikey":URL.baidukeyStr()])
        req.responseJSON { (response) -> Void in
            if (response.result.error != nil) {
                fail(response.result.error.debugDescription)
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
    static func requestHeweather(_ city:String, success:@escaping ((AnyObject)?) -> Void, fail:@escaping ((String?)?) -> Void) -> Void {
        let req = Alamofire.request(URL.heweather(),method: .get,  parameters: ["city":city], encoding: URLEncoding.default, headers: ["apikey":URL.baidukeyStr()])
        
        req.responseJSON { (response) -> Void in
            switch response.result {
            case .success:
                success(response.result.value as (AnyObject)?)
            case .failure:
                fail(response.result.error.debugDescription)
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
    static func requestHeWeatherSupportCitys(_ search:String, key:String, success:@escaping (AnyObject?)-> Void,fail:@escaping (String?)->Void) -> Void {
        let req = Alamofire.request(URL.heweatherSupurtCity(), method: .get, parameters: ["search":"allworld" ,"key":URL.heWeatherStr()], encoding: URLEncoding.default)
        req.responseJSON { (response) -> Void in
            switch response.result {
            case .success:
                success(response.result.value as AnyObject?)
            case .failure:
                fail(response.result.error.debugDescription)
            }
        }
    }
    

}
