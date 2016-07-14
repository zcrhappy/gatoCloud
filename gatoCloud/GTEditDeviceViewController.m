//
//  GTEditDeviceViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/13.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTEditDeviceViewController.h"
#import "UIView+DisplayExtention.h"
@interface GTEditDeviceViewController()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation GTEditDeviceViewController

- (void)viewDidLoad
{
    [self setup];
}


- (void)setup
{
    [_nameTextField becomeFirstResponder];
    _nameTextField.text = _currentDeviceName;
}

- (IBAction)clickDone:(id)sender {
    
    if([_nameTextField.text isEmptyString]) {
        [MBProgressHUD showText:@"设备名称不能为空" inView:self.view];
        return;
    }
    
    [[GTHttpManager shareManager] GTDeviceEditDiviceName:_nameTextField.text  withDeviceNo:_deviceNo finishBlock:^(id response, NSError *error) {
        if(error == nil) {
            [MBProgressHUD showText:@"修改设备名称成功" inView:[UIView gt_keyWindow]];
            [self performSegueWithIdentifier:@"BackToListSegue" sender:self];
        }
    }];
}

@end
