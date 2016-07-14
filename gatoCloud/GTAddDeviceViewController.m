//
//  GTAddDeviceViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/9.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTAddDeviceViewController.h"
#import "GTAddDeviceCell.h"
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
        return 1;
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
    
    [cell setClickQRImage:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf goQRScan];
    }];
    
    
#ifdef TEST
    _QRResult = @"2006c574edfa9240";
#endif
    if([sectionName isEqualToString:DeviceSection]) {
        if(row == 0) {
            [cell setUpCellWithTitle:@"设备编号:" content:_QRResult placeholder:nil icon:nil cellStyle:GTAddDeviceCellStyleTitle_textField_QRImage];
            
            [cell becomeActive];
            
            [cell setTextChangedBlock:^(NSString *content) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                strongSelf.deviceId = content;
            }];
        }
        else {
            [cell setUpCellWithTitle:@"设备名称:" content:nil placeholder:nil icon:nil cellStyle:GTAddDeviceCellStyleTitle_textField];
            
            [cell setTextChangedBlock:^(NSString *content) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                strongSelf.deviceName = content;
            }];
        }
    }
    else if ([sectionName isEqualToString:UserSection]) {
        if(row == 0) {
#ifdef TEST
            [cell setUpCellWithTitle:nil content:@"admin" placeholder:@"请输入设备用户名" icon:[UIImage imageNamed:@"GTUserIcon"] cellStyle:GTAddDeviceCellStyleIcon_textTield];
#else
            [cell setUpCellWithTitle:nil content:nil placeholder:@"请输入设备用户名" icon:[UIImage imageNamed:@"GTUserIcon"] cellStyle:GTAddDeviceCellStyleIcon_textTield];
#endif
            [cell setTextChangedBlock:^(NSString *content) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                strongSelf.userName = content;
            }];
        }
        else {
#ifdef TEST
            [cell setUpCellWithTitle:nil content:@"111111" placeholder:@"请输入设备密码" icon:[UIImage imageNamed:@"GTPasswordIcon"] cellStyle:GTAddDeviceCellStyleIcon_textTield];
#else
            [cell setUpCellWithTitle:nil content:nil placeholder:@"请输入设备密码" icon:[UIImage imageNamed:@"GTPasswordIcon"] cellStyle:GTAddDeviceCellStyleIcon_textTield];
#endif
            [cell setTextChangedBlock:^(NSString *content) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                strongSelf.userPwd = content;
            }];
        }
    }
    
    return cell;
}

- (IBAction)clickAddDeviceButton:(id)sender {

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
    _reader        = [[QRCodeReaderViewController alloc] initWithCancelButtonTitle:@"取消" metadataObjectTypes:types];
    
    _reader.delegate = self;
    
    
    [self presentViewController:_reader animated:YES completion:NULL];
}


@end
