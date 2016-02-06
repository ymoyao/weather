//
//  MOBAPostcodeRequest.h
//  MOBApiCloud
//
//  Created by fenghj on 15/10/9.
//  Copyright © 2015年 mob. All rights reserved.
//

#import "MOBARequest.h"

/**
 *  邮编相关请求
 *
 *  @author vimfung
 */
@interface MOBAPostcodeRequest : MOBARequest

/**
 *  查询邮编所属地址
 *
 *  @param postcode 邮政编码，必填项，不允许为nil
 *
 *  @return 请求对象
 */
+ (MOBAPostcodeRequest *) addressRequestByPostcode:(NSString *)postcode DEPRECATED_MSG_ATTRIBUTE("use -[addressRequestByCode:] method instead.");

/**
 *  查询邮编所属地址
 *
 *  @param code 邮政编码，必填项，不允许为nil
 *
 *  @return 请求对象
 */
+ (MOBAPostcodeRequest *) addressRequestByCode:(NSString *)code;

/**
 *  获取省市区域列表
 *
 *  @return 请求对象
 */
+ (MOBAPostcodeRequest *) pcdRequest DEPRECATED_MSG_ATTRIBUTE("use -[pcdListRequest] method instead.");

/**
 *  获取省市区域列表
 *
 *  @return 请求对象
 */
+ (MOBAPostcodeRequest *) pcdListRequest;

/**
 *  查询邮政编码
 *
 *  @param pid 省ID，必填项，不允许为nil
 *  @param cid 市ID，必填项，不允许为nil
 *  @param q   地名，可以为nil
 *
 *  @return 请求对象
 */
+ (MOBAPostcodeRequest *) searchRequestByPid:(NSString *)pid
                                         cid:(NSString *)cid
                                           q:(NSString *)q DEPRECATED_MSG_ATTRIBUTE("use -[searchRequestByPid:cid:did:word:] method instead.");


/**
 *  搜索地址名查询邮编
 *
 *  @param pid  身份id
 *  @param cid  城市id
 *  @param did  区域id
 *  @param word 关键字
 *
 *  @return 请求对象
 */
+ (MOBAPostcodeRequest *) searchRequestByPid:(NSString *)pid
                                         cid:(NSString *)cid
                                         did:(NSString *)did
                                        word:(NSString *)word;
@end
