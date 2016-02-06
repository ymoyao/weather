//
//  MOBAStationRequest.h
//  MobAPI
//
//  Created by liyc on 15/12/29.
//  Copyright © 2015年 mob. All rights reserved.
//

#import <MobAPI/MobAPI.h>

@interface MOBAStationRequest : MOBARequest

/**
 *  查询手机基站信息
 *
 *  @param lac  位置区码
 *  @param cell 基站小区号
 *  @param mcc  移动设备国家编码（默认中国 = 460）
 *  @param mnc  移动设备网络代码(中国移动 = 0/2/7, 中国联通 = 1/6, 中国电信 = 3/5)
 *
 *  @return 请求对象
 */
+ (MOBAStationRequest *) stationRequestBylac:(NSString *)lac
                                        cell:(NSString *)cell
                                         mcc:(NSString *)mcc
                                         mnc:(NSString *)mnc;

@end
