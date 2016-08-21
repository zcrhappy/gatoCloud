//
//  GTAddDeviceViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/9.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTAddDeviceViewController.h"
#import "GTAddDeviceCell.h"
#import "GTAddDeviceNoCell.h"
#import "QRCodeReaderViewController.h"
#define DeviceSection @"DeviceSection"
#define UserSection   @"UserSection"
#define AddDeviceIdentifier @"AddDeviceIdentifier"

#define TEST
@interface GTAddDeviceViewController ()<UITableViewDelegate, UITableViewDataSource, QRCodeReaderDelegate>
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *addDeviceButton;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userPwd;
@property (nonatomic, strong) QRCodeReaderViewController *reader;
@property (nonatomic, copy) NSString *QRResult;

@property (nonatomic, strong) NSDictionary *testDic;
@end

@implementation GTAddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    _deviceId = _deviceName = _userName = _userPwd = @"";
    
    _sections = [NSArray arrayWithObjects:DeviceSection, UserSection, nil];
    [self configTableView];
    
#ifdef kGlobalTest
    _testDic = @{
                 @"deviceId":@"200753a88f5e1240",
                 @"userName":@"admin",
                 @"userPwd" :@"111111"
                 };
#endif
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
        return 1;
    else if ([sectionName isEqualToString:UserSection])
        return 2;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];

    NSString *sectionName = _sections[section];
    
    _userName = _testDic[@"userName"];
    _userPwd = _testDic[@"userPwd"];
    _deviceId = _testDic[@"deviceId"];
    
    if([sectionName isEqualToString:DeviceSection]) {
        cell = (GTAddDeviceNoCell *)[tableView dequeueReusableCellWithIdentifier:@"GTAddDeviceNoCellIdentifier" forIndexPath:indexPath];
        [(GTAddDeviceNoCell *)cell setUpCellWithContent:_deviceId placeholder:@"请输入设备编号"];
        
        __weak __typeof(self)weakSelf = self;
        [(GTAddDeviceNoCell *)cell setClickQRImage:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf goQRScan];
        }];
        
        [(GTAddDeviceNoCell *)cell setTextChangedBlock:^(NSString *content) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.deviceId = content;
        }];
    }
    else if ([sectionName isEqualToString:UserSection]) {
        
         cell = (GTAddDeviceCell *)[tableView dequeueReusableCellWithIdentifier:@"GTAddDeviceCellIdentifier" forIndexPath:indexPath];
        
        if(row == 0) {
            [(GTAddDeviceCell *)cell setUpCellWithContent:_userName placeholder:@"请输入设备用户名" icon:[UIImage imageNamed:@"GTUserIcon"]];
        
            __weak __typeof(self)weakSelf = self;
            [(GTAddDeviceCell *)cell setTextChangedBlock:^(NSString *content) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                strongSelf.userName = content;
            }];
        }
        else {

            [(GTAddDeviceCell *)cell setUpCellWithContent:_userPwd placeholder:@"请输入设备密码" icon:[UIImage imageNamed:@"GTPasswordIcon"]];
    
            __weak __typeof(self)weakSelf = self;
            [(GTAddDeviceCell *)cell setTextChangedBlock:^(NSString *content) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                strongSelf.userPwd = content;
            }];
        }
    }
    
    return cell;
}

- (IBAction)clickAddDeviceButton:(id)sender {

    if([_deviceId isEmptyString]) {
        [MBProgressHUD showText:@"请输入设备编号" inView:self.view];
        return;
    }
    else if ([_userName isEmptyString]) {
        [MBProgressHUD showText:@"请输入设备用户名" inView:self.view];
        return;
    }
    else if ([_userPwd isEmptyString]) {
        [MBProgressHUD showText:@"请输入密码" inView:self.view];
        return;
    }
    
    [[GTHttpManager shareManager] GTDeviceAddWithDeviceNo:_deviceId deviceUserName:_userName devicePwd:_userPwd finishBlock:^(NSDictionary *response, NSError *error) {
        if(error == nil) {
            [MBProgressHUD showText:@"恭喜您添加设备成功" inView:[UIView gt_keyWindow]];
            [self performSegueWithIdentifier:@"BackToListSegue" sender:self];
        }
        
    }];

}


#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    __weak __typeof(self)weakSelf = self;
    [_reader dismissViewControllerAnimated:YES completion:^{
        NSLog(@"qr:%@", result);
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.QRResult = result;
        [strongSelf.table reloadData];
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [_reader dismissViewControllerAnimated:YES completion:NULL];
}

- (void)goQRScan
{
    NSArray *types = @[AVMetadataObjectTypeQRCode];
    _reader  = [[QRCodeReaderViewController alloc] initWithCancelButtonTitle:@"取消" metadataObjectTypes:types];
    
    _reader.delegate = self;
    
    
    [self presentViewController:_reader animated:YES completion:NULL];
}


@end
