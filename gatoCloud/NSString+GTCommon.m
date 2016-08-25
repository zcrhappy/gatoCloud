//
//  NSString+GTCommon.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/13.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "NSString+GTCommon.h"

@implementation NSString (GTCommon)

- (CGFloat)getWidthWithFont:(UIFont *)font
{
    CGFloat stringWidth = 0;
    CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
    if (self.length > 0) {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        stringWidth =[self
                      boundingRectWithSize:size
                      options:NSStringDrawingUsesLineFragmentOrigin
                      attributes:@{NSFontAttributeName:font}
                      context:nil].size.width;
#else
        
        stringWidth = [self sizeWithFont:font
                       constrainedToSize:size
                           lineBreakMode:NSLineBreakByCharWrapping].width;
#endif
    }
    return stringWidth;
}

- (CGFloat)getHeightWithFont:(UIFont *)font
{
    CGFloat stringHeight = 0;
    CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
    if (self.length > 0) {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        stringHeight =[self
                      boundingRectWithSize:size
                      options:NSStringDrawingUsesLineFragmentOrigin
                      attributes:@{NSFontAttributeName:font}
                      context:nil].size.height;
#else
        
        stringHeight = [self sizeWithFont:font
                       constrainedToSize:size
                           lineBreakMode:NSLineBreakByCharWrapping].height;
#endif
    }
    return stringHeight;
}

@end
