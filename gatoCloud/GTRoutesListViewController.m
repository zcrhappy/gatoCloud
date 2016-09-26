//
//  GTRoutesListViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/28.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTRoutesListViewController.h"
#import "GTDeviceZoneModel.h"
#import "GTDeviceZoneModel2.h"
#import "GTDeviceZoneCell.h"
#import "GTSearchActionSheet.h"
#import "GTSearchBar.h"
#import "GTZoneEditViewController.h"
#import "GTZoneStainEditViewController.h"
#import "GTBottomSelectionView.h"
#import "GTTimerQueue.h"
#define kGTDeviceZoneCellIdentifier @"GTDeviceZoneCellIdentifier"
#define kSearchViaZoneName @"按防区搜索"
#define kSearchViaDeviceName @"按设备搜索"

@interface GTRoutesListViewController ()<UITableViewDelegate, UITableViewDataSource, GTDeviceZoneCellDelegate>
@property (nonatomic, strong) UITableView *routesTable;
@property (nonatomic, assign) kListType listType;
@property (nonatomic, strong) GTZoneDataManager *dataManager;
//@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger loopCount;
@property (nonatomic, strong) GTSearchBar *searchBar;
@property (nonatomic, assign) BOOL autoRefresh;
@property (nonatomic, strong) NSArray <NSIndexPath *>*selectArray;//能够被选择的列表
@property (nonatomic, strong) GTBottomSelectionView *bottomSelection;
@property (nonatomic, strong) GTTimerQueue *queue;
@end

@implementation GTRoutesListViewController


- (instancetype)initWithListType:(kListType)listType
{
    if(self = [super init]) {
        _listType = listType;
    }
    return self;
}

- (instancetype)init;
{
    if(self = [super init]) {
        [self enableSearchBar:YES];
        _listType = kListTypeAllZone;
        _queue = [[GTTimerQueue alloc] init];
        
        __weak __typeof(self)weakSelf = self;
        [_queue setUpdateCellBlock:^(NSIndexPath *indexPath) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if(strongSelf.routesTable) {
                GTDeviceZoneCell *cell = [strongSelf.routesTable cellForRowAtIndexPath:indexPath];
                GTDeviceZoneModel *model = [strongSelf modelAtIndexPath:indexPath];
                [cell updateWithModel:model];
            }
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_listType == kListTypeAllZone || _listType == kListTypeViaDeviceNo)
        _autoRefresh = YES;
    else
        _autoRefresh = NO;
    
    _dataManager = [[GTZoneDataManager alloc] initWithListType:_listType];
    if(_searchKeyword)
        _dataManager.searchKeyword = _searchKeyword;
    
    [self configTable];
    [self configSearchBar];
    [self configSelectionItem];
    
    if(_autoRefresh)
        [self pullDownToRefresh];
}

- (void)dealloc
{
    [_searchBar removeFromSuperview];
}

- (void)configTable
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _routesTable = macroCreateTableView(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64), [UIColor whiteColor]);
    [self.view addSubview:_routesTable];
    _routesTable.delegate = self;
    _routesTable.dataSource = self;
    
    _routesTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToRefresh)];
    _routesTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpToRefresh)];

    _routesTable.tableFooterView = [UIView new];
    _routesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _routesTable.rowHeight = 78;
    [_routesTable registerClass:GTDeviceZoneCell.class forCellReuseIdentifier:kGTDeviceZoneCellIdentifier];
    _routesTable.mj_footer.hidden = !_autoRefresh;
    _routesTable.mj_header.hidden = !_autoRefresh;
    
    _routesTable.allowsMultipleSelectionDuringEditing = _listType == kListTypeViaDeviceNo;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(_searchBar) {
        _searchBar.hidden = YES;
        [_searchBar resignFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_searchBar) {
        _searchBar.hidden = NO;
    }
}

#pragma mark - refresh

- (void)pullUpToRefresh
{
    __weak __typeof(self)weakSelf = self;
    [_dataManager loadMoreWithFinishBlock:^(id response, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if(!strongSelf.dataManager.hasMore)
            [strongSelf.routesTable.mj_footer endRefreshingWithNoMoreData];
        else
            [strongSelf.routesTable.mj_footer endRefreshing];
        [strongSelf.routesTable reloadData];
    }];
}


- (void)pullDownToRefresh
{
    [_queue clearQueue];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_routesTable.mj_header setHidden:NO];
    [_routesTable.mj_footer resetNoMoreData];
    
    [self refreshData];
}

- (void)refreshData
{
    __weak __typeof(self)weakSelf = self;
    [_dataManager refreshDataWithFinishBlock:^(id response, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        
        if(!error) {
            if(!strongSelf.dataManager.hasMore)
                [strongSelf.routesTable.mj_footer endRefreshingWithNoMoreData];
            if(strongSelf.dataManager.isEmpty)
                [MBProgressHUD showText:@"未搜索到防区" inView:strongSelf.view];
            [strongSelf.routesTable.mj_footer setHidden:NO];
            [strongSelf.routesTable reloadData];
        }
        [strongSelf.routesTable.mj_header endRefreshing];
    }];
}

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataManager.zoneModelsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTDeviceZoneCell *cell = (GTDeviceZoneCell *)[tableView dequeueReusableCellWithIdentifier:kGTDeviceZoneCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    if(!tableView.isEditing)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GTDeviceZoneModel *model = [self modelAtIndexPath:indexPath];
//#ifdef kGlobalTest
//    NSInteger row = [indexPath row];
//    model.userType = @"1";
//    if(row%2 == 0){
//        model.zoneStyle = @"2";
//    }
//    if(row%4 == 0){
//        model.zoneState = @"1";
//    }
//#endif
    
    if(_listType == kListTypeViaDeviceNo) {
        model.userType = self.userType;
    }
    
    [cell updateWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static GTDeviceZoneCell *templateCell;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        templateCell = [tableView dequeueReusableCellWithIdentifier:kGTDeviceZoneCellIdentifier];
    });
    
    GTDeviceZoneModel *model = [self modelAtIndexPath:indexPath];
    [templateCell updateWithModel:model];
    
    CGFloat heigit = [templateCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    return heigit;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!tableView.isEditing) {
        GTDeviceZoneCell *cell = (GTDeviceZoneCell *)[tableView cellForRowAtIndexPath:indexPath];
        GTDeviceZoneModel *model = [self modelAtIndexPath:indexPath];
        
        model.isExpand = !model.isExpand;
        [cell updateWithModel:model];
        [_routesTable reloadData];
    }
    else {
        GTDeviceZoneModel *model = [self modelAtIndexPath:indexPath];
        if(!(model.canBatchDefendZone)){//model.canZoneDealWithOneKey
            [MBProgressHUD showText:@"当前防区不可布防撤防" inView:self.view];
        }
    }
}

#pragma mark - model / index

- (GTDeviceZoneModel *)modelAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    return _dataManager.zoneModelsArray[row];
}

- (NSIndexPath *)indexPathOfModel:(GTDeviceZoneModel *)model
{
    NSInteger row = [_dataManager.zoneModelsArray indexOfObject:model];
    return [NSIndexPath indexPathForRow:row inSection:0];
}

- (void)unfoldAllCell
{
    [_dataManager.zoneModelsArray enumerateObjectsUsingBlock:^(GTDeviceZoneModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.isExpand = NO;
    }];
}

#pragma mark - Nav Item
- (void)configSearchBar
{
    if(_listType == kListTypeViaZoneName || _listType == kListTypeViaDeviceName)
    {
        NSString *placeholder;
        if(_listType == kListTypeViaZoneName)
            placeholder = @"请输入防区名称";
        else if(_listType == kListTypeViaDeviceName)
            placeholder = @"请输入设备名";
        
        _searchBar = [[GTSearchBar alloc] initWithPlaceholder:placeholder];
        [self.navigationController.navigationBar addSubview:_searchBar];
        
        __weak __typeof(self)weakSelf = self;
        [_searchBar setDidEndEditingBlock:^(NSString *keyword) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.searchKeyword = keyword;
            strongSelf.dataManager.searchKeyword = strongSelf.searchKeyword;
            
            [strongSelf pullDownToRefresh];
        }];
    }
}

- (void)enableSearchBar:(BOOL)yesOrNo;
{
    if(yesOrNo == YES)
        self.navigationItem.rightBarButtonItem = [self itemWithTitle:nil imgName:@"GTSearch" target:self action:@selector(didClickSearch:)];
}

- (void)configSelectionItem
{
    if(_listType == kListTypeViaDeviceNo) {
       self.navigationItem.rightBarButtonItem = [self itemWithTitle:@"全选" imgName:nil target:self action:@selector(clickSelection:)];
    }
}

- (void)configCancelItem
{
    self.navigationItem.rightBarButtonItem = [self itemWithTitle:@"取消" imgName:nil target:self action:@selector(clickCancelSelection:)];
}

//创建UIBarButtonItem
- (UIBarButtonItem *)itemWithTitle:(NSString *)title imgName:(NSString *)imgName target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if(title)
       [button setTitle:title forState:UIControlStateNormal];
    else if (imgName)
        [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = (CGRect){CGPointZero, {40, 40}};
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)didClickSearch:(id)sender
{
    NSArray *selectionArr = @[kSearchViaDeviceName, kSearchViaZoneName];
    
    GTSearchActionSheet *actionSheet = [GTSearchActionSheet actionSheetWithSelection:selectionArr];
    [actionSheet show];
    
    __weak __typeof(self)weakSelf = self;
    __weak __typeof(actionSheet)weakSheet = actionSheet;
    [actionSheet setDidClickBlk:^(NSInteger index) {
        __strong __typeof(weakSheet)strongSheet = weakSheet;
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [strongSheet dismiss];
        NSString *selection = [selectionArr objectAtIndex:index];
        if([selection isEqualToString:kSearchViaZoneName]) {
            GTRoutesListViewController *viewController = [[GTRoutesListViewController alloc] initWithListType:kListTypeViaZoneName];
            [strongSelf.navigationController pushViewController:viewController animated:YES];
        }
        else if([selection isEqualToString:kSearchViaDeviceName]) {
            GTRoutesListViewController *viewController = [[GTRoutesListViewController alloc] initWithListType:kListTypeViaDeviceName];
            [strongSelf.navigationController pushViewController:viewController animated:YES];
        }
    }];
}

#pragma mark - Selection
//点击右上角全选按钮：所有cell折叠，变更cell选中样式
- (void)clickSelection:(id)sender
{
    [self unfoldAllCell];
    [_routesTable reloadData];
    [self configSelectArray];
    
    if (_selectArray.count == 0) {
        [MBProgressHUD showText:@"没有可以布防撤防的防区" inView:self.view];
    }
    else {
        //刷新navItem
        [self configCancelItem];
        
        //选择可以被选中的cell
        [_routesTable setEditing:YES animated:YES];
        __weak __typeof(self)weakSelf = self;
        [_selectArray enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.routesTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }];
        
        //底部弹出选项
        [self showBottomSelection];
    }
}
//点击右上角取消按钮
- (void)clickCancelSelection:(id)sender
{
    [self configSelectionItem];
    //停止编辑状态
    [_routesTable setEditing:NO animated:YES];
    _selectArray = [NSArray array];
    
    [self hideButtonSelection];
    [_routesTable reloadData];
}
- (void)configSelectArray
{
    //获取可以选中的indexPath
    NSMutableArray *array = [NSMutableArray array];
    
   [_dataManager.zoneModelsArray enumerateObjectsUsingBlock:^(GTDeviceZoneModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        GTDeviceZoneCell *cell = (GTDeviceZoneCell *)[_routesTable cellForRowAtIndexPath:indexPath];
       
        if (model.canBatchDefendZone) {//model.canZoneDealWithOneKey
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            [array addObject:indexPath];
        }
        else {
            //不可被选中
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
   }];
    
    _selectArray = [NSArray arrayWithArray:array];
}

//底部显示布防撤防按钮
- (void)showBottomSelection
{
    if(!_bottomSelection)
        _bottomSelection =  [[[NSBundle mainBundle] loadNibNamed:@"GTBottomSelectionView" owner:self options:nil] lastObject];
    _bottomSelection.top = _routesTable.bottom;
    
    [UIView animateWithDuration:0.3 animations:^{
        _bottomSelection.bottom = _routesTable.bottom;
    }];
    
    [self.view addSubview:_bottomSelection];
    __weak __typeof(self)weakSelf = self;
    //批量布防
    [_bottomSelection setClickGuardBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf gt_showTypingControllerWithTitle:@"验证密码" placeholder:@"请输入验证密码" finishBlock:^(NSString *content) {
            if([content isEmptyString] || content == nil) {
                [MBProgressHUD showText:@"请输入密码再进行操作" inView:[UIView gt_keyWindow]];
            }
            else {
                [[GTHttpManager shareManager] GTDeviceZoneBatchGuardWithDeviceNo:strongSelf.searchKeyword istate:@2 pwd:content zoneNos:strongSelf.zoneNos finishBlock:^(id response, NSError *error) {
                    [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                    if(!error) {
                        [strongSelf gt_showMsgControllerWithTitle:@"提示" msg:@"恭喜您批量布防成功!\n后台可能需要几分钟响应时间，请您稍后查看!" finishBlock:^{
                            __strong __typeof(weakSelf)strongSelf = weakSelf;
                            [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                                [strongSelf refreshData];
                            });
                        }];
                    }
                    [strongSelf clickCancelSelection:nil];
                }];
            }
        }];
    }];
    
    //批量撤防
    [_bottomSelection setClickDisguardBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf gt_showTypingControllerWithTitle:@"验证密码" placeholder:@"请输入验证密码" finishBlock:^(NSString *content) {
            if([content isEmptyString] || content == nil) {
                [MBProgressHUD showText:@"请输入密码再进行操作" inView:[UIView gt_keyWindow]];
            }
            else {
                [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
                [[GTHttpManager shareManager] GTDeviceZoneBatchGuardWithDeviceNo:strongSelf.searchKeyword istate:@1 pwd:content zoneNos:strongSelf.zoneNos finishBlock:^(id response, NSError *error) {
                    [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                    if(!error) {
                        [strongSelf gt_showMsgControllerWithTitle:@"提示" msg:@"恭喜您批量撤防成功!\n后台可能需要几分钟响应时间，请您稍后查看!" finishBlock:^{
                            __strong __typeof(weakSelf)strongSelf = weakSelf;
                            [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                                [strongSelf refreshData];
                            });
                        }];
                    }
                    [strongSelf clickCancelSelection:nil];
                }];
            }
        }];
    }];
}

- (void)hideButtonSelection
{
    [UIView animateWithDuration:0.3 animations:^{
        _bottomSelection.top = self.view.bottom;
        _routesTable.bottom = self.view.height;
    } completion:^(BOOL finished) {
    }];
}

- (NSString *)zoneNos
{
    __block NSString *str = @"";
    
    __weak __typeof(self)weakSelf = self;
    [_selectArray enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSInteger row = [indexPath row];
        GTDeviceZoneModel *model = [strongSelf.dataManager.zoneModelsArray objectAtIndex:row];
        str = [str stringByAppendingString:model.zoneNo];
        str = [str stringByAppendingString:@","];
    }];
    
    if(str.length > 0)
        str = [str substringToIndex:str.length-1];
    
    return str;
}

#pragma mark - Cell Delegate

- (void)switchButtonWithDic:(NSDictionary *)infoDic
{
    GTDeviceZoneModel *model = [infoDic objectForKey:@"model"];
    NSIndexPath *indexPath = [self indexPathOfModel:model];
    
    [_queue createObjWithIndexPath:indexPath model:model];
}

- (void)clickStainEditWithModel:(GTDeviceZoneModel *)model
{
    GTZoneStainEditViewController *controller = [[GTZoneStainEditViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:controller animated:YES];
    __weak __typeof(self)weakSelf = self;
    [controller setDidSuccessBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf pullDownToRefresh];
    }];
}


- (void)clickEditWithModel:(GTDeviceZoneModel *)model
{
    //点击进入防区信息详情页
    NSIndexPath *indexPath = [self indexPathOfModel:model];
    
    GTZoneEditViewController *viewController = [[GTZoneEditViewController alloc] initWithModel:model];
    __weak __typeof(self)weakSelf = self;
    [viewController setEditSuccessBlock:^(GTDeviceZoneModel *newModel) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSInteger row = [indexPath row];
        strongSelf.dataManager.zoneModelsArray[row] = newModel;
        [strongSelf.routesTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

@end
