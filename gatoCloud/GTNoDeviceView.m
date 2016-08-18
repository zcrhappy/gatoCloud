//
//  GTNoDeviceView.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/18.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTNoDeviceView.h"

@implementation GTNoDeviceView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.backgroundColor = [UIColor colorWithString:@"f5f5f5"];
    
    UIImageView *imageView = macroCreateImage(CGRectZero, [UIColor colorWithString:@"f5f5f5"]);
    imageView.image = [UIImage imageNamed:@"NoDeviceIcon"];
    [self addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@233);
        make.height.equalTo(@179);
        make.center.equalTo(self);
    }];
}

@end
