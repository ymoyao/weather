//
//  MOBAPhoneRequest.h
//  MOBApiCloud
//
//  Created by fenghj on 15/10/9.
//  Copyright © 2015年 mob. All rights reserved.
//

#import "MOBARequest.h"

/**
 *  手机号相关请求
 *
 *  @author vimfung
 */
@interface MOBAPhoneRequest : MOBARequest

/**
 *  查询手机号码归属地
 *
 *  @param phone 手机号码
 *
 *  @return 请求对象
 */
+ (MOBAPhoneRequest *) ownershipRequestByPhone:(NSString *)phone DEPRECATED_MSG_ATTRIBUTE("use [addressRequestByPhone:] method instead.");

/**
 *  查询手机号码归属地
 *
 *  @param phone 手机号码
 *
 *  @return 请求对象
 */
+ (MOBAPhoneRequest *) addressRequestByPhone:(NSString *)phone;

@end
