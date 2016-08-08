//
//  GTEditTwoRowCell.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/8.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTEditTwoRowCell.h"

@interface GTEditTwoRowCell()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextView *placeholderTextView;
@end


@implementation GTEditTwoRowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _textView.text = @"";
    _placeholderTextView.text = @"";
    
    _textView.delegate = self;

}


- (id)setupWithTitle:(NSString *)title placeholder:(NSString *)placeholder content:(NSString *)content showLine:(BOOL)shouldShowLine
{
    _titleLabel.text = title;
    _placeholderTextView.text = placeholder;
    _textView.text = content;
    _placeholderTextView.hidden = (_textView.text.length != 0);
    
    if(shouldShowLine)
        self.separatorInset = UIEdgeInsetsMake(self.height - SINGLE_LINE_WIDTH, 20, 0, 0);
    else
        self.separatorInset = UIEdgeInsetsMake(self.height , self.width, 0, 0);
    
    return self;
}

- (NSString *)contentString
{
    return _textView.text;
}

- (void)textViewDidChange:(UITextView *)textView
{
    _placeholderTextView.hidden = (textView.text.length != 0);
    
    if(_textDidChangeBlk)
        _textDidChangeBlk([self contentString]);
}

@end
