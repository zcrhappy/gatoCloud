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

@end
