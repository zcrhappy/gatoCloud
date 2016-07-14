//
//  GTWindow.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/10.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTWindow.h"
#import "FLEXManager.h"

@implementation GTWindow

#if DEBUG
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if(UIEventSubtypeMotionShake == motion) {
        [[FLEXManager sharedManager] showExplorer];
    }
}
# endif

@end
