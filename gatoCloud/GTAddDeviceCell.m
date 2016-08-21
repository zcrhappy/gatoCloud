//
//  GTAddDeviceCell.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/9.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTAddDeviceCell.h"

@interface GTAddDeviceCell()
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIImageView *icon;


@end

@implementation GTAddDeviceCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpCellWithContent:(NSString *)content
                 placeholder:(NSString *)placeholder
                        icon:(UIImage *)icon;

{
    
    _textField.placeholder = placeholder;
    _icon.image = icon;
    
    if(![content isEmptyString])
        _textField.text = content;
    
    
    _title.hidden = YES;
    _icon.hidden = NO;

}

- (IBAction)textChanged:(UITextField *)sender {
    
    if(self.textChangedBlock) {
        self.textChangedBlock(_textField.text);
    }
}

- (void)becomeActive
{
    [_textField becomeFirstResponder];
}

@end
