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
#import "GTAddDeviceUserTypeCell.h"
#import "QRCodeReaderViewController.h"
#import "CRSelectActionSheet.h"

#define kDeviceRow          @"kDeviceRow"
#define kUserTypeRow        @"kUserTypeRow"
#define kPwdRow             @"kPwdRow"
#define AddDeviceIdentifier @"AddDeviceIdentifier"

#define TEST
@interface GTAddDeviceViewController ()<UITableViewDelegate, UITableViewDataSource, QRCodeReaderDelegate>
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *addDeviceButton;
@property (nonatomic, strong) NSArray *rowsArray;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *userType;
@property (nonatomic, copy) NSString *userPwd;
@property (nonatomic, strong) QRCodeReaderViewController *reader;

@property (nonatomic, strong) NSDictionary *testDic;
@end

@implementation GTAddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    _deviceId = _userType = _userPwd = @"";
    
    _rowsArray = @[kDeviceRow, kUserTypeRow, kPwdRow];
    
    [self configTableView];
    
//#ifdef kGlobalTest
//    _testDic = @{
//                 @"deviceId":@"2006c574edfa9240",
//                 @"userPwd" :@"111111"
//                 };
//    _userPwd = _testDic[@"userPwd"];
//    _deviceId = _testDic[@"deviceId"];
//#endif
}

- (void)configTableView
{
    _table.frame = self.view.bounds;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rowsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSInteger index = [indexPath row];
    NSString *rowName = _rowsArray[index];
    
    if([rowName isEqualToString:kDeviceRow]) {
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
    else if ([rowName isEqualToString:kUserTypeRow]) {
        
        cell = (GTAddDeviceUserTypeCell *)[tableView dequeueReusableCellWithIdentifier:@"GTAddDeviceUserTypeCellIdentifier" forIndexPath:indexPath];
        __weak __typeof(cell)weakCell = cell;
        __weak __typeof(self)weakSelf = self;
        NSArray *selectionArr = @[@"管理员",@"操作员"];
        [(GTAddDeviceUserTypeCell *)cell setClickCellBlock:^{
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            __strong __typeof(weakCell)strongCell = weakCell;
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [CRSelectActionSheet actionSheetWithTitle:@"角色选择" selectionArr:selectionArr buttonClicked:^(NSString *selectionTitle) {
                ((GTAddDeviceUserTypeCell *)strongCell).userTypeLabel.text = selectionTitle;
                strongSelf.userType = @([selectionArr indexOfObject:selectionTitle]).stringValue;
            }];
        }];
        
    }
    else if ([rowName isEqualToString:kPwdRow]) {
        cell = (GTAddDeviceCell *)[tableView dequeueReusableCellWithIdentifier:@"GTAddDeviceCellIdentifier" forIndexPath:indexPath];
        [(GTAddDeviceCell *)cell setUpCellWithContent:_userPwd placeholder:@"请输入设备密码" icon:[UIImage imageNamed:@"GTPasswordIcon"]];
        
        __weak __typeof(self)weakSelf = self;
        [(GTAddDeviceCell *)cell setTextChangedBlock:^(NSString *content) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.userPwd = content;
        }];
    }
    
    return cell;
}

- (IBAction)clickAddDeviceButton:(id)sender {

    if([_deviceId isEmptyString]) {
        [MBProgressHUD showText:@"请输入设备编号" inView:self.view];
        return;
    }
    else if ([_userType isEmptyString]) {
        [MBProgressHUD showText:@"请选择用户角色" inView:self.view];
        return;
    }
    else if ([_userPwd isEmptyString]) {
        [MBProgressHUD showText:@"请输入密码" inView:self.view];
        return;
    }
    
    [[GTHttpManager shareManager] GTDeviceAddWithDeviceNo:_deviceId deviceUserType:_userType devicePwd:_userPwd finishBlock:^(NSDictionary *response, NSError *error) {
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
        strongSelf.deviceId = result;
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
