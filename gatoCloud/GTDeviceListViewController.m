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
#import "UIViewController+GTAlertController.h"
#import "GTCheckPwdModel.h"

#define kDeviceListCellIdentifier @"kDeviceListCellIdentifier"
@interface GTDeviceListViewController()<UITableViewDelegate, UITableViewDataSource, GRDeviceCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *deviceTable;
@property (nonatomic, strong) UIView *noDeviceView;
@property (nonatomic, strong) NSMutableArray *deviceArray;

@property (nonatomic, strong) NSMutableArray <GTCheckPwdModel *> *checkPwdList;

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
    
    [self fetchPwdList];
}

- (void)fetchPwdList
{
    [[GTHttpManager shareManager] GTDeviceQueryCheckPwdDeviceWithFinishBlock:^(id response, NSError *error) {
        if(error == nil) {
            NSArray *array = [MTLJSONAdapter modelsOfClass:GTCheckPwdModel.class fromJSONArray:[response objectForKey:@"list"] error:nil];
            _checkPwdList = [NSMutableArray arrayWithArray:array];
        }
    }];
}

- (BOOL)shouldShowPwdCheckWithDeviceModel:(GTDeviceModel *)model
{
    __block BOOL shouldShow = NO;
    //sync
    [_checkPwdList enumerateObjectsUsingBlock:^(GTCheckPwdModel * _Nonnull pwdModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if([model.deviceNo isEqualToString:pwdModel.deviceNo]) {
            [self showCheckPwdWithPwdModel:pwdModel];
            shouldShow = YES;
            *stop = YES;
        }
    }];
    
    return shouldShow;
}

- (void)showCheckPwdWithPwdModel:(GTCheckPwdModel *)pwdModel
{
    __weak __typeof(self)weakSelf = self;
    [self gt_showTypingControllerWithTitle:@"验证设备密码" placeholder:[NSString stringWithFormat:@"请输入%@的密码",pwdModel.deviceName] finishBlock:^(NSString *content) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf addDeviceWithModel:pwdModel newPwd:content finishBlock:^(id response, NSError *error) {
            [weakSelf.checkPwdList removeObject:pwdModel];
            [MBProgressHUD showText:@"验证密码成功" inView:[UIView gt_keyWindow]];
        }];
    }];

}

- (void)addDeviceWithModel:(GTCheckPwdModel *)model newPwd:(NSString *)newPwd finishBlock:(GTResultBlock)finishBlock
{
    [[GTHttpManager shareManager] GTDeviceAddWithDeviceNo:model.deviceNo deviceUserType:model.userType.stringValue devicePwd:newPwd finishBlock:finishBlock];
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
    
    if([self shouldShowPwdCheckWithDeviceModel:model]) {
        
    }
    else {
        model.expanded = !model.expanded;
        [cell setupWithModel:model];
        
        [_deviceTable reloadData];
    }
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
    GTDeviceModel *model = _deviceArray[row];
    
#ifdef kGlobalTest
    if(row %2 ==0 )
        model.userType = @"1";
#endif
    return model;
}


- (void)editActionWithIndexPath:(NSIndexPath *)indexPath {
    
    [self gt_pushViewControllerWithStoryBoardIdentifier:@"GTEditDeviceViewControllerID"];
}

#pragma mark - Cell Delega
- (void)didSelectFunctionItemWithDic:(NSDictionary *)dic
{
    NSNumber *index = [dic objectForKey:@"index"];
    GTDeviceModel *model = [dic objectForKey:@"model"];

    if(index.integerValue == 0)
    { //一键布防
        [self gt_showTypingControllerWithTitle:@"验证密码" placeholder:@"请输入设备密码" finishBlock:^(NSString *content) {
            [[GTHttpManager shareManager] GTOneKeyDealingGuardWithDeviceNo:model.deviceNo istate:@2 pwd:content finishBlock:^(id response, NSError *error) {
                if(!error) {
                    [MBProgressHUD showText:@"布防成功" inView:self.view];
                }
            }];
        }];
    }
    else if(index.integerValue == 1)
    { //一键撤防
        [self gt_showTypingControllerWithTitle:@"验证密码" placeholder:@"请输入设备密码" finishBlock:^(NSString *content) {
            [[GTHttpManager shareManager] GTOneKeyDealingGuardWithDeviceNo:model.deviceNo istate:@1 pwd:content finishBlock:^(id response, NSError *error) {
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
        controller.userType = model.userType;
        NSLog(@"设备列表传入userType:%@",model.userType);
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
            [_deviceArray removeObject:model];
            [_deviceTable reloadData];
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
    //添加成功后，从加入页回来需要刷新，并且发送noti
    if([unwindSegue.identifier isEqualToString:@"BackToListSegue"]) {
        [self pullDownToRefresh];
        [[NSNotificationCenter defaultCenter] postNotificationName:kAddDeviceSuccessNotification object:nil];
    }
}



@end
