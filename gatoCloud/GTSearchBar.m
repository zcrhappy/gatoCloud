//
//  GTSearchBar.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/4.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTSearchBar.h"

@interface GTSearchBar()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) NSString *placeholder;

@end

@implementation GTSearchBar

- (instancetype)initWithPlaceholder:(NSString *)placeholder;
{
    if(self = [super init]) {
        _placeholder = placeholder;
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(40, 0, SCREEN_WIDTH - 40, 44);
    
    UIView *btmLine = macroCreateView(CGRectZero, [UIColor colorWithWhite:1 alpha:0.5]);
    [self addSubview:btmLine];
    [btmLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(SINGLE_LINE_WIDTH));
        make.left.bottom.right.equalTo(self).insets(UIEdgeInsetsMake(0, 5, 5, 20));
    }];
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.backgroundColor = [UIColor redColor];
    [self addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.bottom.equalTo(btmLine.mas_top).offset(-5);
        make.width.height.equalTo(@20);
    }];
    
    _textField = macroCreateTextField(CGRectZero, [UIColor clearColor]);
    _textField.textColor = [UIColor whiteColor];
    _textField.placeholder = _placeholder;
    _textField.delegate = self;
    [_textField becomeFirstResponder];
    [self addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(5);
        make.centerY.equalTo(icon);
        make.right.equalTo(self);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    if(self.didEndEditingBlock)
        self.didEndEditingBlock(textField.text);
}

@end
