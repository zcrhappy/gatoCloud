//
//  GTRenameViewController
//  gatoCloud
//
//  Created by 曾超然 on 16/7/13.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTRenameViewController.h"
#import "UIView+DisplayExtention.h"
@interface GTRenameViewController()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation GTRenameViewController

- (void)viewDidLoad
{
    [self setup];
}


- (void)setup
{
    switch (_renameType) {
        case GTRenameTypeDeviceName:
        {
            self.title = @"设备名称编辑";
            _nameTextField.placeholder = @"请输入设备名称";
            _nameTextField.text = _currentDeviceName;
            _titleLabel.text = @"设备名称:";
            [_doneButton addTarget:self action:@selector(clickEditDeviceNameDone:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
        case GTRenameTypeDisplayName:
        {
            self.title = @"昵称设置";
            _nameTextField.placeholder = @"请输入用户昵称";
            _nameTextField.text = _displayName;
            _titleLabel.text = @"昵称:";
            [_doneButton addTarget:self action:@selector(clickEditDisplayNameDone:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
    }
}

- (void)clickEditDeviceNameDone:(id)sender
{
    
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

- (void)clickEditDisplayNameDone:(id)sender
{
    if([_nameTextField.text isEmptyString]) {
        [MBProgressHUD showText:@"用户昵称不能为空" inView:self.view];
        return;
    }
    
    [[GTHttpManager shareManager] GTEditDisplayName:_nameTextField.text finishBlock:^(id response, NSError *error) {
        if(error == nil) {
            [MBProgressHUD showText:@"修改昵称成功" inView:[UIView gt_keyWindow]];
            [GTUserUtils sharedInstance].userModel.displayName = _nameTextField.text;
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoDisplayNameDidChangedNotification object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
