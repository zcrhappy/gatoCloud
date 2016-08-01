//
//  GTGestureManager.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/1.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTGestureManager.h"
#import "GestureViewController.h"
#import "PCCircleViewConst.h"
@implementation GTGestureManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static GTGestureManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[GTGestureManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if(self = [super init]) {
        
        
        
    }
    
    return self;
}

- (void)showSettingGestureView
{
    GestureViewController *gestureUnlockViewController = [[GestureViewController alloc] init];
    gestureUnlockViewController.type = GestureViewControllerTypeSetting;
    [[GTUserUtils appTopViewController] presentViewController:gestureUnlockViewController animated:YES completion:nil];
}

- (void)showLoginGestureView
{
    GestureViewController *gestureUnlockViewController = [[GestureViewController alloc] init];
    gestureUnlockViewController.type = GestureViewControllerTypeLogin;
    [[GTUserUtils appTopViewController] presentViewController:gestureUnlockViewController animated:YES completion:nil];
}

+ (BOOL)isFirstLoad
{
    NSString *finalGesture = [PCCircleViewConst getGestureWithKey:gestureFinalSaveKey];
    
    // 看是否存在第一个密码
    if ([finalGesture length]) {
        return NO;
    } else {
        return YES;
    }
}
@end