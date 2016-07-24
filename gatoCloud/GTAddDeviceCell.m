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
@property (strong, nonatomic) IBOutlet UIImageView *QRImage;
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldLeadingToTitleConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldLeadingToIconConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldTrailingToQRImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldTrailingToRight;


@end

@implementation GTAddDeviceCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configUI];
}

- (void)configUI {
 
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(goQRScan)];
    [_QRImage addGestureRecognizer:tapImage];
}

- (void)setUpCellWithTitle:(NSString *)title
                   content:(NSString *)content
               placeholder:(NSString *)placeholder
                      icon:(UIImage *)icon
                 cellStyle:(GTAddDeviceCellStyle)style;

{
    
    _textField.placeholder = placeholder;
    _title.text = title;
    _icon.image = icon;
    
    if(![content isEmptyString])
        _textField.text = content;
    
    switch (style) {
        case GTAddDeviceCellStyleIcon_textTield:
        {
            _QRImage.hidden = YES;
            _title.hidden = YES;
            _icon.hidden = NO;
            
            _textFieldLeadingToTitleConstraint.priority = UILayoutPriorityDefaultHigh;
            _textFieldLeadingToIconConstraint.priority = UILayoutPriorityRequired;
            _textFieldTrailingToQRImage.priority = UILayoutPriorityDefaultHigh;
            _textFieldTrailingToRight.priority = UILayoutPriorityRequired;
            break;
        }
        case GTAddDeviceCellStyleTitle_textField:
        {
            _QRImage.hidden = YES;
            _title.hidden = NO;
            _icon.hidden = YES;
            
            _textFieldLeadingToTitleConstraint.priority = UILayoutPriorityRequired;
            _textFieldLeadingToIconConstraint.priority = UILayoutPriorityDefaultHigh;
            _textFieldTrailingToQRImage.priority = UILayoutPriorityDefaultHigh;
            _textFieldTrailingToRight.priority = UILayoutPriorityRequired;

            break;
        }
        case GTAddDeviceCellStyleTitle_textField_QRImage:
        {
            _QRImage.hidden = NO;
            _title.hidden = NO;
            _icon.hidden = YES;
            
            _textFieldLeadingToTitleConstraint.priority = UILayoutPriorityRequired;
            _textFieldLeadingToIconConstraint.priority = UILayoutPriorityDefaultHigh;
            _textFieldTrailingToQRImage.priority = UILayoutPriorityRequired;
            _textFieldTrailingToRight.priority = UILayoutPriorityDefaultHigh;
        }
    }
}

- (IBAction)textChanged:(UITextField *)sender {
    
    if(self.textChangedBlock) {
        self.textChangedBlock(sender.text);
    }
}

- (void)becomeActive
{
    [_textField becomeFirstResponder];
}

- (void)goQRScan
{
    if(self.clickQRImage)
        self.clickQRImage();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
