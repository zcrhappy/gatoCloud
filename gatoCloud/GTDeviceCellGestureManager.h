//
//  GTDeviceCellGestureManager.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/21.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TLSwipeForOptionsCell;
@interface GTDeviceCellGestureManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, assign) BOOL isMenuShown;

@property (nonatomic, strong) TLSwipeForOptionsCell *activatedCell;//which menu is shown

- (void)dismissMenu;

@end
