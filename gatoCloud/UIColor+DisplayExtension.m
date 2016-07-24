//
//  UIColor+DisplayExtension.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/24.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "UIColor+DisplayExtension.h"

@implementation UIColor (DisplayExtension)

+ (UIColor *)colorWithString:(NSString *)inColorString;
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

+(UIColor *)colorWithString:(NSString *)inColorString alpha:(float)alpha;
{
    UIColor *result = [UIColor clearColor];
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
        redByte = (unsigned char) (colorCode >> 16);
        greenByte = (unsigned char) (colorCode >> 8);
        blueByte = (unsigned char) (colorCode); // masks off high bits
        result = [UIColor
                  colorWithRed: (float)redByte / 0xff
                  green: (float)greenByte/ 0xff
                  blue: (float)blueByte / 0xff
                  alpha:alpha];
    }
    return result;
}

@end
