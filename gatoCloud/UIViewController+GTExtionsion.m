//
//  UIViewController+GTExtionsion.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/27.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "UIViewController+GTExtionsion.h"
#import "GTBaseNavigationController.h"
@implementation UIViewController (GTExtionsion)

- (void)gt_presentViewController:(UIViewController *)controller animated:(BOOL)animated completion:(void (^ __nullable)(void))completion
{
    GTBaseNavigationController *navigationController = [[GTBaseNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:animated completion:completion];
}

- (void)gt_presentViewControllerWithStoryBoardIdentifier:(NSString *)identifier animated:(BOOL)animated completion:(void (^ __nullable)(void))completion
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *target = [storyBoard instantiateViewControllerWithIdentifier:identifier];
    [self presentViewController:target animated:animated completion:completion];
}

- (void)gt_presentViewControllerWithStoryBoardIdentifier:(NSString *)identifier
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *target = [storyBoard instantiateViewControllerWithIdentifier:identifier];
    [self presentViewController:target animated:YES completion:nil];
}

- (void)gt_pushViewControllerWithStoryBoardIdentifier:(NSString *)identifier viewControllerParamBlock:(void (^)(UIViewController *))controllerBlock
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *target = [storyBoard instantiateViewControllerWithIdentifier:identifier];
    if(controllerBlock)
        controllerBlock(target);
    [self.navigationController pushViewController:target animated:YES];
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
