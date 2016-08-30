//
//  UIViewController+GTExtionsion.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/27.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "UIViewController+GTExtionsion.h"

@implementation UIViewController (GTExtionsion)

- (void)gt_presentViewControllerWithStoryBoardIdentifier:(NSString *)identifier
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *target = [storyBoard instantiateViewControllerWithIdentifier:identifier];
    [self presentViewController:target animated:YES completion:nil];
}

- (void)gt_pushViewControllerWithStoryBoardIdentifier:(NSString *)identifier;
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *target = [storyBoard instantiateViewControllerWithIdentifier:identifier];
    [self.navigationController pushViewController:target animated:YES];
}

+ (void)gt_backToRootViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    [rootViewController dismissViewControllerAnimated:YES completion:nil];
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)gt_topViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

+ (BOOL)isViewControllerPresent
{
    UIViewController *topVC = [GTUserUtils appTopViewController];
    NSArray *viewcontrollers = topVC.navigationController.viewControllers;
    
    if (viewcontrollers.count > 1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式
            return NO;
        }
    }
    
    //present方式
    return YES;
}
@end
