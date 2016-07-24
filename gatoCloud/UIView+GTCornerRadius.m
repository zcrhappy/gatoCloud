//
//  UIView+GTCornerRadius.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/13.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "UIView+GTCornerRadius.h"

@implementation UIView (GTCornerRadius)
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (CGColorRef)borderColor
{
    return self.layer.borderColor;
}

- (void)setBorderColor:(CGColorRef)borderColor
{
    self.layer.borderColor = borderColor;
}

@end
