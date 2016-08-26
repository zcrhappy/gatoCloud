//
//  UIViewController+GTAlertController.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/26.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (GTAlertController)
- (void)gt_showTypingControllerWithTitle:(NSString *)title placeholder:(NSString *)placeholder finishBlock:(void (^)(NSString *content))finishBlk;
@end
