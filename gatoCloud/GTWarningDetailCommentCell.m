//
//  GTWarningDetailCommentCell.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/24.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTWarningDetailCommentCell.h"

@interface GTWarningDetailCommentCell()<UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UITextView *placeholderTextView;
@end

@implementation GTWarningDetailCommentCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _placeholderTextView.hidden = NO;
    _textView.layer.borderColor = [UIColor colorWithString:@"e0e0e0"].CGColor;
    _textView.delegate = self;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if([textView.text isEmptyString]) {
        _placeholderTextView.hidden = NO;
    }
    else {
        _placeholderTextView.hidden = YES;
    }
}

@end
