//
//  UIImage+DisplayExtension.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/23.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "UIImage+DisplayExtension.h"

@implementation UIImage (DisplayExtension)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
