//
//  Utils.h
//  Weathers
//
//  Created by SR on 16/2/4.
//  Copyright © 2016年 游辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject



/**
 *  获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
 *
 *  @param aString 汉字
 *
 *  @return 大写首字符
 */
+ (NSString *)firstCharactor:(NSString *)aString;

@end
