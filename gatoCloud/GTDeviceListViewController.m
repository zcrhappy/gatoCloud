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
#import "JAActionButton.h"
#import "GTEditDeviceViewController.h"
#define kDeviceListCellIdentifier @"kDeviceListCellIdentifier"
@interface GTDeviceListViewController()<UITableViewDelegate, UITableViewDataSource,TLSwipeForOptionsCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTable;

@property (nonatomic, strong) NSArray *list;

@end

@implementation GTDeviceListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _list = [NSArray array];
    
    [self configTableView];
    
    [self pullDowmToRefresh];
}

- (void)configTableView
{
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDowmToRefresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _listTable.mj_header = header;
}


- (void)pullDowmToRefresh
{
    __weak __typeof(self)weakSelf = self;
    [[GTHttpManager shareManager] GTDeviceFetchListWithFinishBlock:^(id response, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.listTable.mj_header endRefreshing];
        
        strongSelf.list = [MTLJSONAdapter modelsOfClass:[GTDeviceModel class] fromJSONArray:(NSArray *)response error:nil];
        
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
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTDeviceListCell *cell = (GTDeviceListCell *)[tableView dequeueReusableCellWithIdentifier:kDeviceListCellIdentifier forIndexPath:indexPath];

    cell.delegate = self;
    
    NSInteger index = [indexPath row];
    GTDeviceModel *model = _list[index];
    [cell configDeviceName:model.deviceName status:model.onlineState];

    return cell;
}

- (void)cellDidSelectDelete:(GTDeviceListCell *)cell {
    
    NSIndexPath *indexPath = [_listTable indexPathForCell:cell];
    NSInteger row = [indexPath row];
    GTDeviceModel *model = _list[row];
    
    __weak __typeof(self)weakSelf = self;
    [[GTHttpManager shareManager] GTDeviceDeleteWithDeviceNo:model.deviceNo finishBlock:^(id response, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if(error == nil) {
            [MBProgressHUD showText:@"删除设备成功" inView:[UIView gt_keyWindow]];
            [strongSelf pullDowmToRefresh];
        }
    }];
}

- (void)cellDidSelectMore:(GTDeviceListCell *)cell {
    
    [self performSegueWithIdentifier:@"PushToEidtDeviceSegue" sender:cell];

}
#pragma mark - Segue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"PushToEidtDeviceSegue"]) {
        
        NSIndexPath *indexPath = [_listTable indexPathForCell:((GTDeviceListCell *)sender)];
        NSInteger row = [indexPath row];
        GTDeviceModel *model = _list[row];
        
        GTEditDeviceViewController *destVC = segue.destinationViewController;
        
        destVC.currentDeviceName = model.deviceName;
        destVC.deviceNo = model.deviceNo;
    }
}

- (IBAction)unwindToListViewController:(UIStoryboardSegue *)unwindSegue
{
    if([unwindSegue.identifier isEqualToString:@"BackToListSegue"]) {
        [self pullDowmToRefresh];
    }
}



@end
