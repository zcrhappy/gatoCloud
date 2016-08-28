//
//  GTPhoneLoginViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/15.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTPhoneRegisterViewController.h"
#import "GTGestureManager.h"
#import "NSString+CheckingExtension.h"
@interface GTPhoneRegisterViewController()

@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UITextField *pinTextField;//验证码
@property (nonatomic, weak) IBOutlet UITextField *pwdTextField;

@property (weak, nonatomic) IBOutlet UIButton *fetchPinButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger counts;

@end

@implementation GTPhoneRegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _pwdTextField.secureTextEntry = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_phoneTextField resignFirstResponder];
    [_pinTextField resignFirstResponder];
    [_pwdTextField resignFirstResponder];
    
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

- (IBAction)clickFetchVerifyCode:(UIButton *)sender {
    
    if(![NSString valiMobile:_phoneTextField.text]) {
        [MBProgressHUD showText:@"请输入合法的手机号码" inView:self.view];
        return;
    }
    
    [_phoneTextField resignFirstResponder];
    [_pwdTextField resignFirstResponder];
    
    GTPhoneLoginType loginType = _enterType == kTypeRegister ? GTPhoneLoginTypeRegister : GTPhoneLoginTypeForgetPwd;

    [[GTHttpManager shareManager] GTPhoneFetchVerifyCodeWithMobileNo:_phoneTextField.text type:loginType finishBlock:^(id response, NSError *error) {
        if(error == nil) {
            [MBProgressHUD showText:@"发送验证码成功" inView:self.view];
            [self fireTimer];
        }
    }];
}

- (IBAction)clickRegister:(UIButton *)sender {
    
    if(_enterType == kTypeRegister) {
        [[GTHttpManager shareManager] GTPhoneRegisterWithMobileNo:_phoneTextField.text password:_pwdTextField.text verifyCode:_pinTextField.text finishBlock:^(id response, NSError *error) {
            if(error == nil) {
                [MBProgressHUD showText:@"注册成功" inView:[UIView gt_keyWindow]];
                [self didSuccessRegisterWithDic:response];
            }
        }];
    }
    else if(_enterType == kTypeForgetPwd){
        [[GTHttpManager shareManager] GTLoginForgetPwdWithMobileNo:_phoneTextField.text password:_pwdTextField.text verifyCode:_pinTextField.text finishBlock:^(id response, NSError *error) {
            if(error == nil) {
                [MBProgressHUD showText:@"登录成功" inView:[UIView gt_keyWindow]];
                [self didSuccessRegisterWithDic:response];
            }
        }];
    }
}

- (void)didSuccessRegisterWithDic:(id)response
{
    [GTUserUtils saveUserInfoViaRegister:response];
    
    [self performSegueWithIdentifier:@"EnterMainViewSegue" sender:self];
    
    if([GTGestureManager isFirstLoad])
        [[GTGestureManager sharedInstance] showSettingGestureView];
    else
        [[GTGestureManager sharedInstance] showLoginGestureView];
}

- (IBAction)clickBack:(id)sender
{
    [self performSegueWithIdentifier:@"backToLoginSegue" sender:self];
}

- (void)fireTimer
{
    _counts = 60;
    [_fetchPinButton setEnabled:NO];
    [_fetchPinButton setBackgroundColor:[UIColor lightGrayColor]];
    
    if(!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(secondCounts) userInfo:nil repeats:YES];
        [_timer fire];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)secondCounts
{
    if(_counts > 0) {
        NSString *title = [NSString stringWithFormat:@"%ld秒后重发",(long)_counts];
        _fetchPinButton.titleLabel.text = title;
        [_fetchPinButton setTitle:title forState:UIControlStateDisabled];
        _counts--;
    }
    else {
        [self resetPinButton];
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)resetPinButton
{
    [_fetchPinButton setEnabled:YES];
    NSString *title = @"发送验证码";
    _fetchPinButton.titleLabel.text = title;
    [_fetchPinButton setTitle:title forState:UIControlStateNormal];
    [_fetchPinButton setBackgroundColor:[UIColor colorWithString:@"31bc67"]];
}

@end
