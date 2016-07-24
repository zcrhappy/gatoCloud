//
//  GTDeviceListViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/12.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTDeviceListViewController.h"
#import "GTDeviceListCell.h"
#import "GTDeviceModel.h"
#import "GTEditDeviceViewController.h"
#define kDeviceListCellIdentifier @"kDeviceListCellIdentifier"
@interface GTDeviceListViewController()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *listTable;

@property (nonatomic, strong) NSMutableArray *deviceArray;

@end

@implementation GTDeviceListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _deviceArray = [NSMutableArray array];
    
    [self configTableView];
    
    [self pullDownToRefresh];
}

- (void)configTableView
{
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToRefresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _listTable.mj_header = header;
    
    [_listTable registerClass:[GTDeviceListCell class] forCellReuseIdentifier:kDeviceListCellIdentifier];
    _listTable.rowHeight = 60;
    _listTable.tableFooterView = [UIView new];
}


- (void)pullDownToRefresh
{
    __weak __typeof(self)weakSelf = self;
    [[GTHttpManager shareManager] GTDeviceFetchListWithFinishBlock:^(id response, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.listTable.mj_header endRefreshing];
        
        strongSelf.deviceArray = [NSMutableArray arrayWithArray:[MTLJSONAdapter modelsOfClass:[GTDeviceModel class] fromJSONArray:(NSArray *)response error:nil]];
        
        [strongSelf.listTable reloadData];
    }];
}

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _deviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTDeviceListCell *cell = (GTDeviceListCell *)[tableView dequeueReusableCellWithIdentifier:kDeviceListCellIdentifier forIndexPath:indexPath];

    
    NSInteger index = [indexPath row];
    GTDeviceModel *model = _deviceArray[index];
    [cell configDeviceName:model.deviceName status:model.onlineState];

    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self deleteActionWithIndexPath:indexPath];
    }];
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self editActionWithIndexPath:indexPath];
    }];
    
    return @[deleteAction, editAction];
    
}

- (void)deleteActionWithIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = [indexPath row];
    GTDeviceModel *model = _deviceArray[row];
    
    [[GTHttpManager shareManager] GTDeviceDeleteWithDeviceNo:model.deviceNo finishBlock:^(id response, NSError *error) {
        if(error == nil) {
            [MBProgressHUD showText:@"删除设备成功" inView:[UIView gt_keyWindow]];
            [_listTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

- (void)editActionWithIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"PushToEidtDeviceSegue" sender:indexPath];

}
#pragma mark - Segue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"PushToEidtDeviceSegue"]) {
        
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            NSInteger row = [indexPath row];
            GTDeviceModel *model = _deviceArray[row];
            
            GTEditDeviceViewController *destVC = segue.destinationViewController;
            
            destVC.currentDeviceName = model.deviceName;
            destVC.deviceNo = model.deviceNo;
        }
    }
}

- (IBAction)clickBack:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:self completion:^{
        
    }];
}

- (IBAction)unwindToListViewController:(UIStoryboardSegue *)unwindSegue
{
    if([unwindSegue.identifier isEqualToString:@"BackToListSegue"]) {
        [self pullDownToRefresh];
    }
}



@end
