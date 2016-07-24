//
//  GTDeviceCellGestureManager.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/21.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTDeviceCellGestureManager.h"
#import "TLSwipeForOptionsCell.h"
@implementation GTDeviceCellGestureManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static GTDeviceCellGestureManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[GTDeviceCellGestureManager alloc] init];
    });
    return instance;
}

- (void)dismissMenu;
{
    [self.activatedCell enclosingTableViewDidScroll];
    self.activatedCell = nil;
    self.isMenuShown = NO;
}

@end
