//
//  MOBAEnvironmentRequest.h
//  MobAPI
//
//  Created by liyc on 15/12/29.
//  Copyright © 2015年 mob. All rights reserved.
//

#import <MobAPI/MobAPI.h>

@interface MOBAEnvironmentRequest : MOBARequest

/**
 *  空气质量查询请求
 *
 *  @param city     城市名称
 *  @param province 省份名称
 *
 *  @return 请求对象
 */
+ (MOBAEnvironmentRequest *) environmentRequestByCity:(NSString *)city province:(NSString *)province;

@end
