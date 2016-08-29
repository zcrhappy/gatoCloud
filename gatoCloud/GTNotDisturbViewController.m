//
//  GTNotDisturbViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/17.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTNotDisturbViewController.h"
#import "GTNotDisturbCell.h"
#import "MiPushSDK.h"

#define kPushClose @"开启"
#define kPushOpen @"关闭"
#define kPushOpenAtDay @"只在夜间开启"

@interface GTNotDisturbViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *NotDisturbTable;
@property (nonatomic, strong) NSArray *disturbArray;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation GTNotDisturbViewController

- (void)awakeFromNib
{
    [super awakeFromNib];

    _disturbArray = @[kPushClose, kPushOpenAtDay, kPushOpen];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[GTHttpManager shareManager] GTQueryPushConfigWithFinishBlock:^(id response, NSError *error) {
        if(error == nil) {
            NSNumber *itype = [response objectForKey:@"itype"];
            if(itype.integerValue == 0) {
                _selectedIndex = 0;
            }
            else if (itype.integerValue == 1) {
                _selectedIndex = 1;
            }
            else if (itype.integerValue == 2) {
                _selectedIndex = 2;
            }
            [_NotDisturbTable reloadData];
        }
    }];
    
}

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _disturbArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    
    GTNotDisturbCell *cell = (GTNotDisturbCell *)[tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    [cell setUpWithTitle:_disturbArray[index] selected:(index == _selectedIndex)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    _selectedIndex = index;
    
    NSString *name = [_disturbArray objectAtIndex:index];
    NSString *pushItype;
    if([name isEqualToString:kPushClose]) {
        pushItype = @"0";
    }
    else if( [name isEqualToString:kPushOpenAtDay]) {
        pushItype = @"1";
    }
    else if ( [name isEqualToString:kPushOpen]) {
        pushItype = @"2";
    }
    
    [[GTHttpManager shareManager] GTPushConfigWithType:pushItype finishBlock:^(id response, NSError *error) {
        if(error == nil) {
            [MBProgressHUD showText:@"设置成功!" inView:self.view];
            [_NotDisturbTable reloadData];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end




