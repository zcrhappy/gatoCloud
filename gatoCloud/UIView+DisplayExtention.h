//
//  UIView+DisplayExtention.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/14.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DisplayExtention)

+ (UIView *)gt_keyWindow;


@property (nonatomic) CGFloat left;

@property (nonatomic) CGFloat top;

@property (nonatomic) CGFloat right;

@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat width;

@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;

@property (nonatomic) CGFloat centerY;

- (UIView *(^)(CGFloat top))_top;

@end
