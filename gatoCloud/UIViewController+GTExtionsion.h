//
//  UIViewController+GTExtionsion.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/27.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (GTExtionsion)

- (void)gt_presentViewControllerWithStoryBoardIdentifier:( NSString * _Nonnull )identifier;
- (void)gt_presentViewControllerWithStoryBoardIdentifier:( NSString * _Nonnull )identifier animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;
- (void)gt_pushViewControllerWithStoryBoardIdentifier:( NSString * _Nonnull )identifier;
- (void)gt_presentViewController:(UIViewController * _Nonnull )controller animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;
+ (UIViewController * _Nonnull )gt_topViewController;
+ (UIViewController * _Nonnull )gt_rootViewController;
+ (void)gt_backToRootViewControllerWithCompletion:(void (^ __nullable)(void))completion;
@end
