//
//  MOBABaseResponse.h
//  MOBApiCloud
//
//  Created by fenghj on 15/10/9.
//  Copyright © 2015年 mob. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  基础回复类型
 *
 *  @author vimfung
 */
@interface MOBAResponse : NSObject

/**
 *  错误信息
 */
@property (nonatomic, strong) NSError *error;

/**
 *  响应数据
 */
@property (nonatomic, strong) id responder;

@end
