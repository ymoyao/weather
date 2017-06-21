//
//  MOBAIdRequest.h
//  MobAPI
//
//  Created by liyc on 15/12/29.
//  Copyright © 2015年 mob. All rights reserved.
//

#import <MobAPI/MobAPI.h>

@interface MOBAIdRequest : MOBARequest

/**
 *  身份证信息查询请求
 *
 *  @param cardno 身份证号码
 *
 *  @return 请求对象
 */
+ (MOBAIdRequest *) idcardRequestByCardno:(NSString *)cardno;

@end
