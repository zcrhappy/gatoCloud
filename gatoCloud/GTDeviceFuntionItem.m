//
//  GTDeviceFuntionItem.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/27.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTDeviceFuntionItem.h"
@interface GTDeviceFuntionItem()
@property (nonatomic, strong) UIImageView *funcIcon;
@property (nonatomic, strong) UILabel *funcLabel;
@end


@implementation GTDeviceFuntionItem

- (instancetype)init
{
    if(self = [super init]) {
        [self configUI];
    }
    return self;
}


- (void)configUI
{
    self.layer.borderWidth = SINGLE_LINE_WIDTH;
    self.layer.borderColor = [UIColor colorWithString:@"e0e0e0"].CGColor;
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *container = macroCreateView(CGRectZero, [UIColor whiteColor]);
    [self addSubview:container];
    
    
    _funcIcon = macroCreateImage(CGRectZero, [UIColor whiteColor]);
    [container addSubview:_funcIcon];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [_funcIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(container).offset(2);
        make.width.height.equalTo(@26.5);
        make.centerX.equalTo(container);
        make.left.greaterThanOrEqualTo(container);
        make.right.lessThanOrEqualTo(container);
    }];
    
    _funcLabel = macroCreateLabel(CGRectZero, [UIColor whiteColor], 14, [UIColor colorWithString:@"212121"]);
    [container addSubview:_funcLabel];
    
    [_funcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_funcIcon.mas_bottom).offset(5);
        make.bottom.equalTo(container);
        make.centerX.equalTo(container);
        make.left.greaterThanOrEqualTo(container);
        make.right.lessThanOrEqualTo(container);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self addGestureRecognizer:tap];
}

- (void)setupFuncionItemWithName:(NSString *)name iconName:(NSString *)icon
{
    _funcIcon.image = [UIImage imageNamed:icon];
    _funcLabel.text = name;
}

- (void)tapView:(UIGestureRecognizer *)gesture
{
    if(_delegate && [_delegate respondsToSelector:@selector(clickFunctionItemAtIndex:)]) {
        [_delegate performSelector:@selector(clickFunctionItemAtIndex:) withObject:[NSNumber numberWithInteger:self.tag]];
    }
    
}



@end
