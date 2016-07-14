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

@end

@implementation GTAddDeviceCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configUI];
}

- (void)configUI {
    
    _title.numberOfLines = 0;
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(self.contentView);
    }];
    

    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.width.equalTo(@15);
        make.width.equalTo(@23);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_QRImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-15));
        make.width.height.equalTo(@36);
        make.centerY.equalTo(self.contentView);
    }];
    
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(goQRScan)];
    [_QRImage addGestureRecognizer:tapImage];
}

- (void)setUpCellWithTitle:(NSString *)title
               placeholder:(NSString *)placeholder
                      icon:(UIImage *)icon
                 cellStyle:(GTAddDeviceCellStyle)style;

{
    
    _textField.placeholder = placeholder;
    _title.text = title;
    _icon.image = icon;
    
    switch (style) {
        case GTAddDeviceCellStyleIcon_textTield:
        {
            _QRImage.hidden = YES;
            _title.hidden = YES;
            _icon.hidden = NO;
            
            [_textField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_icon.mas_right).offset(10);
                make.right.equalTo(self.contentView).offset(-10);
                make.height.equalTo(self.contentView);
            }];
            break;
        }
        case GTAddDeviceCellStyleTitle_textField:
        {
            _QRImage.hidden = YES;
            _title.hidden = NO;
            _icon.hidden = YES;
            
            [_textField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_title.mas_right).offset(10);
                make.right.equalTo(self.contentView).offset(-10);
                make.height.equalTo(self.contentView);
            }];
            break;
        }
        case GTAddDeviceCellStyleTitle_textField_QRImage:
        {
            _QRImage.hidden = NO;
            _title.hidden = NO;
            _icon.hidden = YES;
            
            [_textField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_title.mas_right).offset(10);
                make.right.equalTo(_QRImage).offset(-10);
                make.height.equalTo(self.contentView);
            }];
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
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
