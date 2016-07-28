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
@interface GTDeviceListViewController()<UITableViewDelegate, UITableViewDataSource, GRDeviceCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *deviceTable;

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
    _deviceTable.mj_header = header;
    
    _deviceTable.estimatedRowHeight = 78;
    _deviceTable.tableFooterView = [UIView new];
    _deviceTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}


- (void)pullDownToRefresh
{
    __weak __typeof(self)weakSelf = self;
    [[GTHttpManager shareManager] GTDeviceFetchListWithFinishBlock:^(id response, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.deviceTable.mj_header endRefreshing];
        
        strongSelf.deviceArray = [NSMutableArray arrayWithArray:[MTLJSONAdapter modelsOfClass:[GTDeviceModel class] fromJSONArray:(NSArray *)response error:nil]];
        
        [strongSelf.deviceTable reloadData];
    }];
}

#pragma mark - TableView Delegate

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
    cell.delegate = self;

    [cell configZoneName:model.deviceName zoneCount:model.zoneCount state:model.onlineState online:model.online];
    

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTDeviceListCell *cell = (GTDeviceListCell *)[tableView cellForRowAtIndexPath:indexPath];
    GTDeviceModel *model = [self modelAtIndexPath:indexPath];
    
    model.expanded = !model.expanded;
    [cell setupWithExpanded:model.expanded];
    [_deviceTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static GTDeviceListCell *templateCell;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        templateCell = [tableView dequeueReusableCellWithIdentifier:kDeviceListCellIdentifier];
    });
    
    GTDeviceModel *model = [self modelAtIndexPath:indexPath];
    [templateCell setupWithExpanded:model.expanded];
    
    CGFloat minHeight = [templateCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    return minHeight;
}

- (GTDeviceModel *)modelAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    return _deviceArray[row];
}


- (void)editActionWithIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"PushToEidtDeviceSegue" sender:indexPath];

}

#pragma mark - Cell Delega
- (void)didSelectFunctionItemWithIndex:(NSNumber *)index
{
    [MBProgressHUD showText:index.stringValue inView:self.view];
}

#pragma mark - 侧滑功能栏

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
            [_deviceTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
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
