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
@interface GTNotDisturbViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *NotDisturbTable;
@property (nonatomic, strong) NSArray *disturbArray;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation GTNotDisturbViewController

- (void)awakeFromNib
{
    [super awakeFromNib];

    _disturbArray = @[@"开启", @"只在夜间开启", @"关闭"];
    _selectedIndex = [GTUserUtils notDisturbStatus].integerValue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    [GTUserUtils setNotDisturbStatus:index];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPushStatusDidChange object:nil];
    
    [_NotDisturbTable reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end




