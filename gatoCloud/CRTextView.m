//
//  CRTextView.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/7.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "CRTextView.h"

@interface CRTextView()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *placeholderTextView;
@property (nonatomic, strong) UITextView *editTextView;
@end

@implementation CRTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    _editTextView = [[UITextView alloc] initWithFrame:self.frame];
    _editTextView.delegate = self;
    [self addSubview:_editTextView];
    _placeholderTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    _placeholderTextView.backgroundColor = [UIColor clearColor];
    [self addSubview:_placeholderTextView];
}

- (void)setFont:(UIFont *)font
{
    _editTextView.font = font;
}

- (void)setTextColor:(UIColor *)textColor
{
    _editTextView.textColor = textColor;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //update placeholderTextView
    UIFont *font = _editTextView.font;
    _placeholderTextView.frame = CGRectMake(0, 0, self.width, font.pointSize + 2);
    _placeholderTextView.text = _placeholder;
    
}


#pragma mark - Delegate
- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length == 0)
        _placeholderTextView.hidden = NO;
    else
        _placeholderTextView.hidden = YES;
}


@end
