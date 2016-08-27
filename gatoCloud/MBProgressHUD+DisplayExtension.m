//
//  MBProgressHUD+DisplayExtension.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/10.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "MBProgressHUD+DisplayExtension.h"

@implementation MBProgressHUD (DisplayExtension)

+ (void)showText:(NSString *)text inView:(UIView *)view;
{
    if([MBProgressHUD HUDForView:view]){
        [MBProgressHUD hideHUDForView:view animated:YES];
    }
    
    [self showText:text inView:view withTime:1.5];
}

+ (void)showText:(NSString *)text inView:(UIView *)view withTime:(NSTimeInterval)time;
{
    if([MBProgressHUD HUDForView:view]){
        [MBProgressHUD hideHUDForView:view animated:YES];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:16];
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    [hud hide:YES afterDelay:time];
}

@end
