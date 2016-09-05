//
//  GTWebViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/9/5.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTWebViewController.h"

@interface GTWebViewController ()

@end

@implementation GTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithUrl:(NSString *)url
{
    if(self = [super init]) {
        UIWebView * view = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        [view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [self.view addSubview:view];
    }
    return self;
}

@end
