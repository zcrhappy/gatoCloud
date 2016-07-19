//
//  GTPhoneLoginViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/15.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTPhoneLoginViewController.h"

@interface GTPhoneLoginViewController()

@property (nonatomic, strong) IBOutlet UITextField *phoneTextField;
@property (nonatomic, strong) IBOutlet UITextField *veriryCode;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *fetchCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;


@end

@implementation GTPhoneLoginViewController

- (IBAction)clickFetchVerifyCode:(UIButton *)sender {
    
    [[GTHttpManager shareManager] GTPhoneFetchVerifyCodeWithMobileNo:_phoneTextField.text type:GTPhoneLoginTypeRegister finishBlock:^(id response, NSError *error) {
       
    }];
}

- (IBAction)clickRegister:(UIButton *)sender {
    
    [[GTHttpManager shareManager] GTPhoneRegisterWithMobileNo:_phoneTextField.text password:_password.text verifyCode:_veriryCode.text finishBlock:^(id response, NSError *error) {
        if(error == nil) {
            [MBProgressHUD showText:@"注册成功" inView:[UIView gt_keyWindow]];
        }
    }];
}

- (IBAction)clickBack:(id)sender
{
    [self performSegueWithIdentifier:@"backToLoginSegue" sender:self];
}

@end
