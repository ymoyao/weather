//
//  Utils.m
//  Weathers
//
//  Created by SR on 16/2/4.
//  Copyright © 2016年 游辉. All rights reserved.
//

#import "Utils.h"

@implementation Utils

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)firstCharactor:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    if (pinYin.length > 1) {
        return [pinYin substringToIndex:1];
    }
    return @"";
    
}

//data转base64
+ (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}


#pragma mark - 计算label高度
+ (CGFloat)calHeightWithLabel:(UILabel *)label{
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    return [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, 2000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paragraphStyle} context:nil].size.height;
}

#pragma mark - 计算label宽度
+ (CGFloat)calWidthWithLabel:(UILabel *)label{
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    return [label.text boundingRectWithSize:CGSizeMake(2000, label.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paragraphStyle} context:nil].size.width;
}


@end
