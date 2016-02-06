//
//  MOBABaseRequest.h
//  MOBApiCloud
//
//  Created by fenghj on 15/10/9.
//  Copyright © 2015年 mob. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  基础请求类型
 *
 *  @author vimfung
 */
@interface MOBARequest : NSObject

/**
 *  请求方式，默认为GET
 */
@property (nonatomic, copy) NSString *method;

/**
 *  请求地址
 */
@property (nonatomic, strong, readonly) NSURL *url;

/**
 *  请求参数集合
 */
@property (nonatomic, strong, readonly) NSDictionary *allParams;

/**
 *  头部信息集合
 */
@property (nonatomic, strong, readonly) NSDictionary *allHeaders;

/**
 *  初始化请求对象
 *
 *  @param URL 请求对象地址
 *
 *  @return 请求对象
 */
- (instancetype) initWithURL:(NSURL *)url;

/**
 *  设置请求参数
 *
 *  @param value 参数值
 *  @param name  参数名称
 */
- (void) setParam:(id)value forName:(NSString *)name;

/**
 *  设置请求头
 *
 *  @param content 内容
 *  @param name  名称
 */
- (void) setHeader:(NSString *)content forName:(NSString *)name;

@end
