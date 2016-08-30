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

+ (UIViewController *)gt_rootViewController
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

+ (void)gt_backToRootViewControllerWithCompletion:(void (^ __nullable)(void))completion
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if(rootViewController == [UIViewController gt_topViewController]) {
        completion();
    }
    else {
        [rootViewController dismissViewControllerAnimated:YES completion:completion];
    }
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
    UIViewController *topVC = [UIViewController gt_topViewController];
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
