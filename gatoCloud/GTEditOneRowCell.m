//
//  GTEditOneRowCell.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/8.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTEditOneRowCell.h"

@interface GTEditOneRowCell()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@end


@implementation GTEditOneRowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textFieldTextDidChange)
     name:UITextFieldTextDidChangeNotification
     object:nil];
}

- (id)setupWithTitle:(NSString *)title placeholder:(NSString *)placeholder content:(NSString *)content showLine:(BOOL)shouldShowLine shouldEditTextField:(BOOL)shouldEdit
{
    [self setupWithTitle:title placeholder:placeholder content:content showLine:shouldShowLine];
    [self shouldEditTextField:shouldEdit];
    return self;
}

- (id)setupWithTitle:(NSString *)title placeholder:(NSString *)placeholder content:(NSString *)content showLine:(BOOL)shouldShowLine
{
    _titleLabel.text = title;
    _textField.placeholder = placeholder;
    _textField.text = content;
    
    if(shouldShowLine)
        self.separatorInset = UIEdgeInsetsMake(self.height - SINGLE_LINE_WIDTH, 20, 0, 0);
    else
        self.separatorInset = UIEdgeInsetsMake(self.height , self.width, 0, 0);
    
    return self;
}

- (NSString *)contentString
{
    return _textField.text;
}

- (void)textFieldTextDidChange
{
    if(_textDidChangeBlk)
        _textDidChangeBlk([self contentString]);
}

- (void)updateContent:(NSString *)string
{
    _textField.text = string;
}

- (void)shouldEditTextField:(BOOL)shouldEdit
{
    _textField.enabled = shouldEdit;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:UITextFieldTextDidChangeNotification];
}
@end
