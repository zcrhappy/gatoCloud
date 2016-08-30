//
//  UIViewController+GTExtionsion.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/27.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (GTExtionsion)

- (void)gt_presentViewControllerWithStoryBoardIdentifier:(NSString *)identifier;
- (void)gt_pushViewControllerWithStoryBoardIdentifier:(NSString *)identifier;

+ (UIViewController *)gt_topViewController;
+ (void)gt_backToRootViewController;
@end
