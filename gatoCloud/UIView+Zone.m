//
//  UIView+Zone.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/6.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "UIView+Zone.h"
#import "CRTextView.h"
#import "NSString+Common.h"
@implementation UIView (Zone)

+ (UIView *)rowViewWithTitle:(NSString *)title placeholder:(NSString *)placeholder showSeparatorLine:(BOOL)shouldShowLine type:(kRowType)type
{
    UIView *view = macroCreateView(CGRectZero, [UIColor whiteColor]);
    
    UILabel *titleLabel = macroCreateLabel(CGRectZero, [UIColor whiteColor], 18, [UIColor colorWithString:@"212121"]);
    titleLabel.text = [NSString stringWithFormat:@"%@ :",title];
    [view addSubview:titleLabel];
    
    UITextField *textField = macroCreateTextField(CGRectZero, [UIColor whiteColor]);
    textField.tag = TextFieldWithTag;
    textField.textColor = [UIColor colorWithString:@"c1c1c1"];
    textField.font = [UIFont systemFontOfSize:18];
    textField.placeholder = placeholder;
    textField.hidden = YES;
    [view addSubview:textField];
    
    CRTextView *textView = [[CRTextView alloc] initWithFrame:CGRectZero];
    textView.tag = TextViewWithTag;
    textView.textColor = [UIColor colorWithString:@"c1c1c1"];
    textView.font = [UIFont systemFontOfSize:18];
    textView.placeholder = placeholder;
    textView.hidden = YES;
    [view addSubview:textView];
    
    if(type == oneLineType)
    {
        CGFloat titleWidth = [title caluFitWidthWithHeight:2000 font:titleLabel.font];
        
        titleLabel.frame = CGRectMake(20, 0, titleWidth, 20);
        
        textField.hidden = NO;
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(15);
            make.top.bottom.right.equalTo(view).insets(UIEdgeInsetsMake(0, 0, 0, -10));
        }];
    }
    else
    {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.top.equalTo(@12);
        }];
        
        textView.hidden = NO;
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(10);
            make.top.bottom.right.equalTo(view).insets(UIEdgeInsetsMake(0, 0, 0, -10));
        }];
    }
    
    UIView *line = macroCreateView(CGRectZero, [UIColor colorWithString:@"c1c1c1"]);
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(SINGLE_LINE_WIDTH));
        make.left.bottom.right.equalTo(view).insets(UIEdgeInsetsMake(0, 20, 0, 0));
    }];
    line.hidden = !shouldShowLine;
    
    return view;
}

@end
