//
//  MOBACookRequest.h
//  MOBApiCloud
//
//  Created by fenghj on 15/10/9.
//  Copyright © 2015年 mob. All rights reserved.
//

#import "MOBARequest.h"

/**
 *  菜谱相关请求
 */
@interface MOBACookRequest : MOBARequest

/**
 *  查询菜谱分类
 *
 *  @param cid 菜谱分类ID，默认为nil，表示获取全部
 *
 *  @return 请求对象
 */
+ (MOBACookRequest *) categoryRequestById:(NSString *)cid DEPRECATED_MSG_ATTRIBUTE("use -[categoryRequest] method instead.");

/**
 *  查询菜谱分类
 *
 *  @return 请求对象
 */
+ (MOBACookRequest *) categoryRequest;

/**
 *  查询菜谱信息
 *
 *  @param cid  分类ID, 允许为nil
 *  @param name 菜谱名称, 允许为nil
 *  @param page 起始页, 允许为nil
 *  @param size 页尺寸, 允许为nil
 *
 *  @return 请求对象
 */
+ (MOBACookRequest *) searchRequestByCid:(NSString *)cid
                                    name:(NSString *)name
                                    page:(NSInteger)page
                                    size:(NSInteger)size DEPRECATED_MSG_ATTRIBUTE("use -[searchMenuRequestByCid:name:page:size:] method instead.");

/**
 *  查询菜谱信息
 *
 *  @param cid  分类ID, 允许为nil
 *  @param name 菜谱名称, 允许为nil
 *  @param page 起始页, 允许为nil
 *  @param size 页尺寸, 允许为nil
 *
 *  @return 请求对象
 */
+ (MOBACookRequest *) searchMenuRequestByCid:(NSString *)cid
                                        name:(NSString *)name
                                        page:(NSInteger)page
                                        size:(NSInteger)size;

/**
 *  获取菜谱详情信息
 *
 *  @param mid 菜谱ID, 必填项，不允许为nil
 *
 *  @return 请求对象
 */
+ (MOBACookRequest *) infoRequestById:(NSString *)mid DEPRECATED_MSG_ATTRIBUTE("use -[infoDetailRequestById:] method instead.");

/**
 *  获取菜谱详情信息
 *
 *  @param mid 菜谱ID, 必填项，不允许为nil
 *
 *  @return 请求对象
 */
+ (MOBACookRequest *) infoDetailRequestById:(NSString *)mid;

@end
