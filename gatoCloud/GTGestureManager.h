//
//  GTGestureManager.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/1.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTGestureManager : NSObject
+ (instancetype)sharedInstance;
- (void)showSettingGestureView;
- (void)showLoginGestureView;
+ (BOOL)isFirstLoad;
@end
