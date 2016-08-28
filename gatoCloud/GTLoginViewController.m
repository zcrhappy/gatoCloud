//
//  GTLoginViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/3.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTLoginViewController.h"
#import "GTGestureManager.h"
#import "GTPhoneRegisterViewController.h"
@interface GTLoginViewController ()

@property (nonatomic, weak) IBOutlet UITextField *nameLabel;
@property (nonatomic, weak) IBOutlet UITextField *pwdLabel;

@end

@implementation GTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pwdLabel.secureTextEntry = YES;
}


- (IBAction)clickLogin:(id)sender {
    
    if(_nameLabel.text.length == 0) {
        [MBProgressHUD showText:@"请输入用户名或手机号" inView:self.view];
    }
    else if (_pwdLabel.text.length == 0) {
        [MBProgressHUD showText:@"请输入密码" inView:self.view];
    }
    else {
        [[GTHttpManager shareManager] GTPhoneLoginEithMobileNo:_nameLabel.text password:_pwdLabel.text finishBlock:^(id response, NSError *error) {
            if(error == nil) {
                [MBProgressHUD showText:@"恭喜您登录成功" inView:[UIView gt_keyWindow]];
            
                [GTUserUtils unRegisterUserInfo];
                [GTUserUtils saveUserInfoViaRegister:response];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kDidLoginSuccessNotification object:nil];
                
                [self performSegueWithIdentifier:@"kEnterMainViewSegue" sender:self];
                
                
                if([GTGestureManager isFirstLoad])
                    [[GTGestureManager sharedInstance] showSettingGestureView];
                else
                    [[GTGestureManager sharedInstance] showLoginGestureView];
            }
        }];
    }
    
}
- (IBAction)clickBack:(UIButton *)sender {
    [self performSegueWithIdentifier:@"BackToLoginMenuSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"forgetPwdSegue"]) {
        GTPhoneRegisterViewController *controller = segue.destinationViewController;
        controller.enterType = kTypeForgetPwd;
    }
}

@end
