//
//  Utils.h
//  Weathers
//
//  Created by SR on 16/2/4.
//  Copyright © 2016年 游辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject



/**
 *  获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
 *
 *  @param aString 汉字
 *
 *  @return 大写首字符
 */
+ (NSString *)firstCharactor:(NSString *)aString;


/**
 *  data转base64
 *
 *  @param theData data
 *
 *  @return 字符串
 */
+ (NSString*)base64forData:(NSData*)theData;


/**
 *  计算label高度
 *
 *  @param label label
 *
 *  @return 高度
 */
+ (CGFloat)calHeightWithLabel:(UILabel *)label;

/**
 *  计算label宽度
 *
 *  @param label label
 *
 *  @return 宽度
 */
+ (CGFloat)calWidthWithLabel:(UILabel *)label;

/**
 *  获得某个范围内的屏幕图像
 *
 *  @param theView 对应的视图
 *  @param rect    frame
 *
 *  @return image
 */
+ (UIImage *)imageFromView:(UIView *)theView atFrame:(CGRect)rect;


@end
