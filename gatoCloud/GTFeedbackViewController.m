//
//  GTFeedbackViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/19.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTFeedbackViewController.h"

@interface GTFeedbackViewController()

@property (nonatomic, strong) IBOutlet UITextView *feedback;
@property (nonatomic, strong) IBOutlet UITextField *contact;

@end

@implementation GTFeedbackViewController


- (IBAction)clickSend:(id)sender
{
    if([_feedback.text isEmptyString]) {
        [MBProgressHUD showText:@"请填写反馈内容" inView:self.view];
        return;
    }
    
    [[GTHttpManager shareManager] GTUserFeedbackWithContents:_feedback.text contact:_contact.text finishBlock:^(id response, NSError *error) {
        if(!error) {
            [MBProgressHUD showText:@"感谢您提交反馈" inView:[UIView gt_keyWindow]];
            [self performSegueWithIdentifier:@"backToUserInfoSegue" sender:self];
        }
    }];
}

- (IBAction)clickBack:(id)sender
{
    [self performSegueWithIdentifier:@"backToUserInfoSegue" sender:self];
}

@end
