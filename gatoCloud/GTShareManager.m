//
//  GTShareManager.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/23.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTShareManager.h"
#import "WXApi.h"
#import <MessageUI/MessageUI.h>

@interface GTShareManager()<MFMessageComposeViewControllerDelegate>

@end

@implementation GTShareManager

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static GTShareManager *shareManager;
    dispatch_once(&onceToken, ^{
        shareManager = [[GTShareManager alloc] init];
    });
    return shareManager;
}

- (void)shareToWXFrindWithText:(NSString *)text;
{
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text = text;
    req.bText = YES;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}

- (void)shareViaMessageWithText:(NSString *)text;
{
    UIViewController *currentViewController = [GTUserUtils appTopViewController];
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if(messageClass != nil) {
        if([messageClass canSendText]) {
            MFMessageComposeViewController *msgPicker = [[MFMessageComposeViewController alloc] init];
            msgPicker.messageComposeDelegate = self;
            msgPicker.body = text;
            [currentViewController presentViewController:msgPicker animated:YES completion:nil];
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"该设备不支持短信功能" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:action];
            
            [currentViewController presentViewController:alertController animated:YES completion:nil];
        }
    }
    else {
        
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result;
{
    UIViewController *currentViewController = [GTUserUtils appTopViewController];
    [currentViewController dismissViewControllerAnimated:YES completion:nil];
    
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            [MBProgressHUD showText:@"信息发送成功" inView:[UIView gt_keyWindow]];
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            [MBProgressHUD showText:@"信息发送失败" inView:[UIView gt_keyWindow]];
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送

            break;
        default:
            break;
    }
}

@end
