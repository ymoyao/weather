//
//  MainVCCellModel.swift
//  Weathers
//
//  Created by SR on 16/2/15.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit

/**
 cell 背景颜色
 
 - red:    赤色
 - orange: 橙色
 - yellow: 黄色
 - green:  绿色
 - cyan:   青色
 - blue:   蓝色
 - purple: 紫色
 */
enum CellBgColor : Int{
    case Red = 0,Orange,Yellow,Green,Cyan,Blue,Purple
}

/**
 天气对应的图片
 
 - Sunshine: 晴
 - Rain:     雨
 - Cloudy:   多云
 */
enum WeatherImage : String {
    case Sunshine = "sunshine"
    case Rain = "rain"
    case Cloudy = "cloudy"
}



class MainVCCellModel: NSObject {
    var date = ""               //时间
    var dayTime = ""            //白天天气
    var night = ""              //晚间天气
    var temperature = ""        //温度
    var week = ""               //星期
    var wind = ""               //风
    
    
    //自己添加的标志
    var cellBgColor = 0                            //cell背景颜色--七彩
    var weatherImage = ""                      //天气对应的图片
    
}
