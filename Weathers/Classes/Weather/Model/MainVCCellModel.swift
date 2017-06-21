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
    case red = 0,orange,yellow,green,cyan,blue,purple
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
    
    var max = ""                //最高温
    var min = ""                //最低温
    var date = ""               // 日期
    
    var code_d = ""             //白天图片
    var code_n = ""             //夜间图标
    var txt_d = ""              //白天描述
    var txt_n = ""              //夜间描述
    

    //自己添加的标志
    var cellBgColor = 0                            //cell背景颜色--七彩
    var weatherImage = ""                      //天气对应的图片
    
   
    
}
