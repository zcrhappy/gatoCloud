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
    
    _funcIcon = macroCreateImage(CGRectZero, [UIColor whiteColor]);
    [self addSubview:_funcIcon];
    
    [_funcIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@16);
        make.centerX.equalTo(self);
    }];
    
    _funcLabel = macroCreateLabel(CGRectZero, [UIColor whiteColor], 14, [UIColor colorWithString:@"212121"]);
    [self addSubview:_funcLabel];
    
    [_funcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-12);
        make.centerX.equalTo(self);
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
