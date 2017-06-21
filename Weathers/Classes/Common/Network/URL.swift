//
//  URL.swift
//  Weathers
//
//  Created by SR on 16/2/15.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit


public struct URL {
    
    //主地址
    fileprivate static var baseUrl = "http://apicloud.mob.com/"
    fileprivate static var baseBaiduUrl = "http://apis.baidu.com/"
    fileprivate static var baseGoogleUrl = "http://www.google.com/"
    
    //MARK: - 天气查询
    /**
     天气查询
     
     - returns: 接口字符串
     */
    static func weatherUrl() -> String {
        return baseUrl + "v1/weather/query"
        //        + "?key=\(key)&city=\(city)&province=\(province)"
        //        key:String, city:String, province:String
    }
    
    //MARK: - 机器人请求接口
    /**
     机器人请求接口
     
     - returns: 接口字符串
     */
    static func reporterUrl() -> String {
        return baseBaiduUrl + "turing/turing/turing"
    }
    
    //MARK: - 声音转文本
    /**
     声音转文本
     
     - returns: 接口字符串
     */
    static func voiceToText() -> String {
        return baseGoogleUrl + "speech-api/v1/recognize"
    }
    
    //MARK: - 百度-中国和世界天气预报
    /**
     百度-中国和世界天气预报
     
     - returns: 接口字符串
     */
    static func heweather() -> String {
        return baseBaiduUrl + "heweather/weather/free"
    }
    
    
    /**
     和天气支持城市列表接口
     
     - returns: 接口字符串
     */
    static func heweatherSupurtCity() ->String {
        return "https://api.heweather.com/x3/citylist"
    }
    
    /**
     *  城市收索类型
     */
    public struct cityType {
        var CHINA = "allchina"      //中国
        var WORLD = "allworld"      //全世界
        var HOTWORLD = "hotworld"   //世界热门城市
    }
    
    
    
    
    
    
    //MARK: - KEY
    /**
    获取百度通用key
    
    - returns: key字符串
    */
    static func baidukeyStr() ->String {
        //百度api的统一key
        return "307d52d1c76cf7bc57f7ccfe0f86bdca"
    }
    
    /**
     讯飞通用appid
     
     - returns: appid字符串
     */
    static func xunfeiKeyStr() ->String {
        return "appid=56d3a864"
    }
    
    //https://api.heweather.com/x3/citylist?search=allchina&key
    /**
     获取和天气支持城市列表专用key
     
     - returns: 字符串
     */
    static func heWeatherStr() ->String {
        return "85ee3403ed5d4d96a53e3dd226edd8ae"
    }
    

}
