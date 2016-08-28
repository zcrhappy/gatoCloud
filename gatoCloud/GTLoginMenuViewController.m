//
//  GTLoginViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/11.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTLoginMenuViewController.h"
#import "GTPhoneRegisterViewController.h"
#import "GTMainViewController.h"
#import "GTWXLoginManager.h"
#import "GTGestureManager.h"
@interface GTLoginMenuViewController()

@property (weak, nonatomic) IBOutlet UIButton *phoneLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *weChatLoginButton;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIButton *quickLogin;

@end
@implementation GTLoginMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin) name:kDidLoginSuccessNotification object:nil];
    
    [self configUI];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidLoginSuccessNotification object:nil];
}

- (void)configUI
{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:_loginLabel.text];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    _loginLabel.attributedText = content;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLogin)];
    [_loginLabel addGestureRecognizer:tap];
    
    _quickLogin.hidden = YES;
#if DEBUG
    _quickLogin.hidden = NO;
#endif
}

- (void)clickLogin
{
    [self performSegueWithIdentifier:@"EnterLoginSegue" sender:self];
}


- (IBAction)clickWeChatLogin:(id)sender {
    
    [[GTWXLoginManager sharedManager] sendAuthRequest];
    
}

- (void)didLogin
{
    [[GTHttpManager shareManager] GTWxLoginWithFinishBlock:^(NSDictionary * _Nullable response, NSError * _Nullable error){
       
        if(error == nil){
            NSLog(@"success");
            
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *mainViewController = [storyBoard instantiateViewControllerWithIdentifier:@"GTMainViewControllerIdentifier"];
            [self presentViewController:mainViewController animated:YES completion:nil];
            
            if([GTGestureManager isFirstLoad])
                [[GTGestureManager sharedInstance] showSettingGestureView];
            else
                [[GTGestureManager sharedInstance] showLoginGestureView];
        }
            
    }];
}


- (IBAction)unwindToLoginController:(UIStoryboardSegue *)unwindSegue
{
    if([unwindSegue.identifier isEqualToString:@"BackToLoginSegue"]) {
     
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"EnterPhoneRegisterSegue"]) {
        GTPhoneRegisterViewController *controller = segue.destinationViewController;
        controller.enterType = kTypeRegister;
    }
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    
//}
//
//- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
//{
//    if([identifier isEqualToString:@"PushToMainView"]) {
//        
//    }
//    
//}



@end
