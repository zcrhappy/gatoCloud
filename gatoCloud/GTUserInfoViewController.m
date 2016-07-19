//
//  GTUserInfoViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/15.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTUserInfoViewController.h"
#import "GTUserInfoCell.h"
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
    NSInteger row = [indexPath row];
    NSString *title = [_rowArray objectAtIndex:row];
    
    GTUserInfoCell *cell = (GTUserInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"GTUserInfoCellIdentifier" forIndexPath:indexPath];
    
    if([title isEqualToString:@"头像"]) {
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
    
    
    if([title isEqualToString:@"头像"]) {
//        UIAlertController *alertController = [UIAlertController all]
    }
    if([title isEqualToString:@"反馈"]) {
        [self performSegueWithIdentifier:@"pushToFeedbackSegue" sender:self];
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
