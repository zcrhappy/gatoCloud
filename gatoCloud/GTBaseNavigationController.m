//
//  GTBaseNavigationController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/1.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTBaseNavigationController.h"

@interface GTBaseNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation GTBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.interactivePopGestureRecognizer.delegate = self;
        self.delegate = self;
        self.navigationBar.translucent = NO;
        self.navigationBar.barTintColor = [UIColor colorWithString:@"40a2e4"];
        self.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
    }
    return self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    id target = self;
    SEL sel = @selector(doExit);
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20.5, 17)];
    [backBtn setImage:[UIImage imageNamed:@"GTBackBtn"] forState:UIControlStateNormal];
    [backBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width =-10;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:nil
                                                                 style:UIBarButtonItemStylePlain
                                                                target:target
                                                                action:sel];
    
    [backItem setCustomView:backBtn];
    [viewController.navigationItem setLeftBarButtonItems:@[backItem]];
    
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
}

- (void)doExit
{
    if (self.viewControllers.count == 1)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self popViewControllerAnimated:YES];
    }

}

@end
