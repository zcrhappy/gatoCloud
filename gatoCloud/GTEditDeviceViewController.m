//
//  GTEditDeviceViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/13.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTEditDeviceViewController.h"

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
}

@end
