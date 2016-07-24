//
//  GTUserInfoViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/15.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTUserInfoViewController.h"
#import "GTUserInfoCell.h"
#import "GTStartModel.h"
NSString *kAvatar = @"头像";
NSString *kNoDisturb = @"功能消息免打扰";
NSString *kModifyGestureCode = @"修改手势密码";
NSString *kCheckVersion = @"版本检测";
NSString *kContactUs = @"联系我们";
NSString *kFeedback = @"反馈";
NSString *kQuitAccount = @"退出当前账号";

@interface GTUserInfoViewController()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *listTable;
@property (nonatomic, strong) NSArray *rowArray;

@end

@implementation GTUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configSource];
    [self configUI];
}

- (void)configSource
{
    _rowArray = @[kAvatar, kNoDisturb, kModifyGestureCode, kCheckVersion, kContactUs, kFeedback, kQuitAccount];
    
}

- (void)configUI
{
    _listTable.tableFooterView = [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSString *title = [_rowArray objectAtIndex:row];
    
    GTUserInfoCell *cell = (GTUserInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"GTUserInfoCellIdentifier" forIndexPath:indexPath];
    
    if([title isEqualToString:kAvatar]) {
        [cell setupCellWithType:GTUserInfoCellTypeAvatar title:title subTitle:nil avatarStr:@""];
    }
    else {
        [cell setupCellWithType:GTUserInfoCellTypeArrow title:title subTitle:nil avatarStr:nil];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = [indexPath row];
    NSString *title = [_rowArray objectAtIndex:row];
    
    
    if([title isEqualToString:kAvatar]) {
//        UIAlertController *alertController = [UIAlertController all]
    }
    else if([title isEqualToString:kFeedback]) {
        [self performSegueWithIdentifier:@"pushToFeedbackSegue" sender:self];
    }
    else if([title isEqualToString:kContactUs]) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"联系我们" message:@"拨打电话:4006840078" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:cancle];
        
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
    else if ([title isEqualToString:kCheckVersion]) {
        [[GTHttpManager shareManager] GTAppCheckUpdateWithFinishBlock:^(id response, NSError *error) {
            GTStartModel *startModel = [MTLJSONAdapter modelOfClass:GTStartModel.class fromJSONDictionary:response error:nil];
            if([startModel.code isEqualToString:@"0"]) {
                [MBProgressHUD showText:@"您已经是最新版本" inView:self.view];
            }
            else {
                [MBProgressHUD showText:@"有新版本" inView:self.view];
            }
        }];
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSString *title = [_rowArray objectAtIndex:row];
    
    if([title isEqualToString:@"头像"]){
        return 88;
    }
    else {
        return 44;
    }
}

- (IBAction)unwindToUserInfoViewController:(UIStoryboardSegue *)unwindSegue
{
    
}


- (IBAction)clickBack:(id)sender
{
//    [self performSegueWithIdentifier:@"backToMainViewSegue" sender:self];
    [self.navigationController dismissViewControllerAnimated:self completion:^{
        
    }];
}


@end
