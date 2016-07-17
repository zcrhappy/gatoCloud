//
//  GTUserInfoViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/15.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTUserInfoViewController.h"

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
    _rowArray = @[@"头像",@"功能消息免打扰",@"修改手势密码",@"版本检测",@"联系我们",@"反馈",@"退出当前账号"];
}

- (void)configUI
{

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
    
}

@end
