//
//  GTAddDeviceNoCell.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/21.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTAddDeviceNoCell.h"

@interface GTAddDeviceNoCell()

@property (weak, nonatomic) IBOutlet UIImageView *QRCode;
@property (weak, nonatomic) IBOutlet UITextField *deviceNoTextField;

@end

@implementation GTAddDeviceNoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(goQRScan)];
    [_QRCode addGestureRecognizer:tapImage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setUpCellWithContent:(NSString *)content
                 placeholder:(NSString *)placeholder

{
    
    _deviceNoTextField.placeholder = placeholder;
    
    if(![content isEmptyString])
        _deviceNoTextField.text = content;
}

- (void)goQRScan
{
    if(self.clickQRImage)
        self.clickQRImage();
}

- (IBAction)textChanged:(NSNotification *)sender {
    if(self.textChangedBlock) {
        self.textChangedBlock(_deviceNoTextField.text);
    }
}

- (void)becomeActive
{
    [_deviceNoTextField becomeFirstResponder];
}


@end
