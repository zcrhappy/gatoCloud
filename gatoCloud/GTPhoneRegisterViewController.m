//
//  GTPhoneLoginViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/15.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTPhoneRegisterViewController.h"
#import "GTGestureManager.h"
@interface GTPhoneRegisterViewController()

@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UITextField *pinTextField;//验证码
@property (nonatomic, weak) IBOutlet UITextField *pwdTextField;

@property (weak, nonatomic) IBOutlet UIButton *fetchPinButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation GTPhoneRegisterViewController

- (IBAction)clickFetchVerifyCode:(UIButton *)sender {
    
    [[GTHttpManager shareManager] GTPhoneFetchVerifyCodeWithMobileNo:_phoneTextField.text type:GTPhoneLoginTypeRegister finishBlock:^(id response, NSError *error) {
       
    }];
}

- (IBAction)clickRegister:(UIButton *)sender {
    
    [[GTHttpManager shareManager] GTPhoneRegisterWithMobileNo:_phoneTextField.text password:_pwdTextField.text verifyCode:_pinTextField.text finishBlock:^(id response, NSError *error) {
        if(error == nil) {
            [MBProgressHUD showText:@"注册成功" inView:[UIView gt_keyWindow]];
    
            [GTUserUtils saveUserInfoViaRegister:response];
            
            [self performSegueWithIdentifier:@"EnterMainViewSegue" sender:self];
            
            if([GTGestureManager isFirstLoad])
                [[GTGestureManager sharedInstance] showSettingGestureView];
            else
                [[GTGestureManager sharedInstance] showLoginGestureView];
        }
    }];
}

- (IBAction)clickBack:(id)sender
{
    [self performSegueWithIdentifier:@"backToLoginSegue" sender:self];
}


@end
