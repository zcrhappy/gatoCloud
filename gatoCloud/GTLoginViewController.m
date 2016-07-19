//
//  GTLoginViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/11.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTLoginViewController.h"
#import "GTLoginManager.h"
#import "GTHttpManager.h"
@interface GTLoginViewController()

@property (weak, nonatomic) IBOutlet UIButton *phoneLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *weChatLoginButton;

@end
@implementation GTLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin) name:kDidLoginNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidLoginNotification object:nil];
}

- (IBAction)clickWeChatLogin:(id)sender {
    
    [[GTLoginManager sharedManager] sendAuthRequest];
    
}

- (void)didLogin
{
    [[GTHttpManager shareManager] GTWxLoginWithFinishBlock:^(NSDictionary * _Nullable response, NSError * _Nullable error){
       
        if(error == nil){
            NSLog(@"success");
            
            [self performSegueWithIdentifier:@"EnterMainViewSegue" sender:self];
        }
            
    }];
}

- (IBAction)unwindToLoginController:(UIStoryboardSegue *)unwindSegue
{
    if([unwindSegue.identifier isEqualToString:@"BackToLoginSegue"]) {
     
    }
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    
//}

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
