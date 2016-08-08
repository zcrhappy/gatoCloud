//
//  NSString+QYPPCommon.h
//  paopao_ios
//
//  Created by z on 15/9/27.
//  Copyright © 2015年 ___multiMedia___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)
/*
 * width 显示的宽度 
 * font  显示的字体
 */
- (CGFloat)caluFitHeightWithWidth:(CGFloat)width font:(UIFont *)font;

- (CGFloat)caluFitWidthWithHeight:(CGFloat)height font:(UIFont *)font;

- (NSString *)trimText;

+(NSString *)signWithParameters:(NSDictionary *)dictParameters;

- (NSString *)largeAvatarWithURL;

+(NSString *)md5:(NSString *)str;

+ (NSString*)UUID;

- (BOOL)hasString;

- (BOOL)isEmptyString;


- (NSString *)stringByAppendingNumber:(NSNumber *)number;

+ (NSString *)stringWithTwoNumbers:(NSNumber *)number1 andNumber:(NSNumber *)number2;

@end
