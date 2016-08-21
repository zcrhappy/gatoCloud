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
#import "GTRoutesListViewController.h"
#import "GTNoDeviceView.h"
#define kDeviceListCellIdentifier @"kDeviceListCellIdentifier"
@interface GTDeviceListViewController()<UITableViewDelegate, UITableViewDataSource, GRDeviceCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *deviceTable;
@property (nonatomic, strong) UIView *noDeviceView;
@property (nonatomic, strong) NSMutableArray *deviceArray;

@end

@implementation GTDeviceListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _deviceArray = [NSMutableArray array];
    _noDeviceView = [[GTNoDeviceView alloc] initWithFrame:self.view.bounds];
    _noDeviceView.hidden = YES;
    [self.view addSubview:_noDeviceView];
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
        
        if(strongSelf.deviceArray.count == 0){
            strongSelf.deviceTable.hidden = YES;
            strongSelf.noDeviceView.hidden = NO;
        }
        else {
            strongSelf.deviceTable.hidden = NO;
            strongSelf.noDeviceView.hidden = YES;
        }
        
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
    cell.delegate = self;

    GTDeviceModel *model = [self modelAtIndexPath:indexPath];
    [cell setupWithModel:model];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTDeviceListCell *cell = (GTDeviceListCell *)[tableView cellForRowAtIndexPath:indexPath];
    GTDeviceModel *model = [self modelAtIndexPath:indexPath];
    model.expanded = !model.expanded;
    [cell setupWithModel:model];
   
    [_deviceTable reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static GTDeviceListCell *templateCell;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        templateCell = [tableView dequeueReusableCellWithIdentifier:kDeviceListCellIdentifier];
    });
    
    GTDeviceModel *model = [self modelAtIndexPath:indexPath];
    [templateCell setupWithModel:model];
    
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
- (void)didSelectFunctionItemWithDic:(NSDictionary *)dic
{
    NSNumber *index = [dic objectForKey:@"index"];
    GTDeviceModel *model = [dic objectForKey:@"model"];

    if(index.integerValue == 0)
    { //一键布防
        [self checkPwdWithFinishBlk:^(NSString *pwd) {
            [[GTHttpManager shareManager] GTOneKeyDealingGuardWithDeviceNo:model.deviceNo istate:@2 pwd:pwd finishBlock:^(id response, NSError *error) {
                if(!error) {
                    [MBProgressHUD showText:@"布防成功" inView:self.view];
                }
            }];
        }];
    }
    else if(index.integerValue == 1)
    { //一键撤防
        [self checkPwdWithFinishBlk:^(NSString *pwd) {
            [[GTHttpManager shareManager] GTOneKeyDealingGuardWithDeviceNo:model.deviceNo istate:@1 pwd:pwd finishBlock:^(id response, NSError *error) {
                if(!error) {
                    [MBProgressHUD showText:@"撤防成功" inView:self.view];
                }
            }];
        }];
    }
    else if(index.integerValue == 2)
    { //一键消警
        [[GTHttpManager shareManager] GTOneKeyDisableWarningWithDeviceNo:model.deviceNo finishBlock:^(id response, NSError *error) {
            if(!error) {
                [MBProgressHUD showText:@"消警成功" inView:self.view];
            }
        }];
    }
    else if(index.integerValue == 3)
    {//防区列表
        GTRoutesListViewController *controller = [[GTRoutesListViewController alloc] initWithListType:kListTypeViaDeviceNo];
        controller.searchKeyword = model.deviceNo;
        controller.navigationItem.title = @"通道列表";
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

- (void)checkPwdWithFinishBlk:(void (^)(NSString *pwd))finishBlk
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"验证密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    //创建按钮
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确认按钮block");
        //取出输入框文字
        NSString *pwd = alertController.textFields.firstObject.text;
        finishBlk(pwd);
    }];
    //取消按钮（只能创建一个）
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消按钮block");
    }];

    //将按钮添加到UIAlertController对象上
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    
    //添加文本框（只能在UIAlertController的UIAlertControllerStyleAlert样式下添加）
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入设备密码";
        textField.secureTextEntry = YES;
    }];
    
    //显示弹窗视图控制器
    [self presentViewController:alertController animated:YES completion:nil];
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

- (IBAction)unwindToListViewController:(UIStoryboardSegue *)unwindSegue
{
    if([unwindSegue.identifier isEqualToString:@"BackToListSegue"]) {
        [self pullDownToRefresh];
    }
}



@end
