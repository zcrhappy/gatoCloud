//
//  UIColor+DisplayExtension.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/24.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (DisplayExtension)

/**
 *  根据字符串生成颜色
 *
 *  @param inColorString 16进制的颜色字符串，如ab2345
 *
 *  @return 颜色
 */
+ (UIColor *)colorWithString:(NSString *)inColorString;

/**
 *  根据字符串生成颜色
 *
 *  @param inColorString 16进制的颜色字符串，如ab2345
 *  @param alpha         透明度0.0-1.0
 *
 *  @return 颜色
 */
+(UIColor *)colorWithString:(NSString *)inColorString alpha:(float)alpha;

@end
