//
//  MBProgressHUD+DisplayExtension.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/10.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (DisplayExtension)

+ (void)showText:(NSString *)text inView:(UIView *)view;
+ (void)showText:(NSString *)text inView:(UIView *)view withTime:(NSTimeInterval)time;

@end


