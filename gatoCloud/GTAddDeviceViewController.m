//
//  GTAddDeviceViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/9.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTAddDeviceViewController.h"
#import "GTAddDeviceCell.h"

#define DeviceSection @"DeviceSection"
#define UserSection   @"UserSection"
#define AddDeviceIdentifier @"AddDeviceIdentifier"
@interface GTAddDeviceViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *addDeviceButton;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userPwd;
@end

@implementation GTAddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _deviceId = _deviceName = _userName = _userPwd = @"";
    
    _sections = [NSArray arrayWithObjects:DeviceSection, UserSection, nil];
    [self configTableView];
    

}

- (void)configTableView
{
    _table.frame = self.view.bounds;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionName = _sections[section];
    
    if([sectionName isEqualToString:DeviceSection])
        return 2;
    else if ([sectionName isEqualToString:UserSection])
        return 2;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTAddDeviceCell *cell = (GTAddDeviceCell *)[tableView dequeueReusableCellWithIdentifier:AddDeviceIdentifier];
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];

    NSString *sectionName = _sections[section];
    
    __weak __typeof(self)weakSelf = self;
    
    if([sectionName isEqualToString:DeviceSection]) {
        if(row == 0) {
            [cell setUpCellWithTitle:@"设备编号:" placeholder:nil icon:nil cellStyle:GTAddDeviceCellStyleTitle_textField_QRImage];
            
            [cell becomeActive];
            
            [cell setTextChangedBlock:^(NSString *content) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                strongSelf.deviceId = content;
            }];
        }
        else {
            [cell setUpCellWithTitle:@"设备名称:" placeholder:nil icon:nil cellStyle:GTAddDeviceCellStyleTitle_textField];
            
            [cell setTextChangedBlock:^(NSString *content) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                strongSelf.deviceName = content;
            }];
        }
    }
    else if ([sectionName isEqualToString:UserSection]) {
        if(row == 0) {
            [cell setUpCellWithTitle:nil placeholder:@"请输入设备用户名" icon:nil cellStyle:GTAddDeviceCellStyleIcon_textTield];
            
            [cell setTextChangedBlock:^(NSString *content) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                strongSelf.userName = content;
            }];
        }
        else {
            [cell setUpCellWithTitle:nil placeholder:@"请输入设备密码" icon:nil cellStyle:GTAddDeviceCellStyleIcon_textTield];
            
            [cell setTextChangedBlock:^(NSString *content) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                strongSelf.userPwd = content;
            }];
        }
    }
    
    return cell;
}

- (IBAction)clickAddDeviceButton:(id)sender {
    
//    if([_deviceId isEmptyString]) {
//        [MBProgressHUD showText:@"请输出设备编号" inView:self.view];
//        return;
//    }
//    if([_deviceName isEmptyString]) {
//        [MBProgressHUD showText:@"请输出设备名称" inView:self.view];
//        return;
//    }
//    if([_deviceName isEmptyString]) {
//        [MBProgressHUD showText:@"请输出设备用户名" inView:self.view];
//        return;
//    }
//    if([_deviceName isEmptyString]) {
//        [MBProgressHUD showText:@"请输出设备密码" inView:self.view];
//        return;
//    }
    
    
    [[GTHttpManager shareManager] GTDeviceAddWithDeviceNo:@"2006c574edfa9240" deviceUserName:@"admin" devicePwd:@"111111" finishBlock:^(NSDictionary *response, NSError *error) {
        
    }];
    

    NSDictionary *dictionary = @{@"deviceNo": @"2006c574edfa9240",
                                 @"deviceUserName": @"admin",
                                 @"devicePwd": @"111111",
                                 @"userId": @"15e6e64fa5cf4473be2fb5cab8b8e6ce"};
    
}






@end
