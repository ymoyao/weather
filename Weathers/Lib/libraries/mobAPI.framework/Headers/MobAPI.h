//
//  MOBApiCloud.h
//  MOBApiCloud
//
//  Created by fenghj on 15/10/9.
//  Copyright © 2015年 mob. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <mobAPI/QuickInterface/MOBARequest.h>
#import <mobAPI/QuickInterface/MOBAPostcodeRequest.h>
#import <mobAPI/QuickInterface/MOBAPhoneRequest.h>
#import <mobAPI/QuickInterface/MOBACookRequest.h>
#import <mobAPI/QuickInterface/MOBAWeatherRequest.h>
#import <mobAPI/QuickInterface/MOBAIdRequest.h>
#import <mobAPI/QuickInterface/MOBAStationRequest.h>
#import <mobAPI/QuickInterface/MOBAEnvironmentRequest.h>

#import <mobAPI/QuickInterface/MOBAResponse.h>

/**
 *  MOB云Api
 *
 *  @author vimfung
 */
@interface MobAPI : NSObject

/**
 *  注册应用, 只允许调用一次
 *
 *  @param appKey 应用Key
 */
+ (void) registerApp:(NSString *)appKey;

/**
 *  发送请求
 *
 *  @param request       请求信息
 *  @param resultHandler 返回回调事件处理
 */
+ (void) sendRequest:(MOBARequest *)request
            onResult:(void(^)(MOBAResponse *response))resultHandler;

/**
 *  自定义接口发送请求
 *
 *  @author liyc
 *
 *  @param interface     接口名称
 *  @param param         参数
 *  @param resultHandler 返回回调事件处理
 */
+ (void) sendRequestWithInterface:(NSString *)interface
                            param:(NSDictionary *)param
                         onResult:(void (^)(MOBAResponse *response))resultHandler;

/**
 *  api查询请求
 *
 *  @param resultHandler 返回回调事件处理
 */
+ (void) apiQueryWithResult:(void (^)(MOBAResponse *response))resultHandler;

@end
