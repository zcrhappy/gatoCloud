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


#define kGTDeviceZoneCellIdentifier @"GTDeviceZoneCellIdentifier"
#define kSearchViaZoneName @"按防区搜索"
#define kSearchViaDeviceName @"按设备搜索"
//typedef NS_ENUM(NSInteger, kListType) {
//    kListTypeAllZone,
//    kListTypeCertainDevice,
//    kListTypeViaDeviceName,
//    kListTypeViaZoneName
//};

@interface GTRoutesListViewController ()<UITableViewDelegate, UITableViewDataSource, GTDeviceZoneCellDelegate>
@property (nonatomic, strong) UITableView *routesTable;
@property (nonatomic, assign) kListType listType;
@property (nonatomic, strong) GTZoneDataManager *dataManager;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger loopCount;
@property (nonatomic, strong) GTSearchBar *searchBar;
@property (nonatomic, assign) BOOL autoRefresh;
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
    
    if(_autoRefresh)
        [self pullDownToRefresh];
}

- (void)dealloc
{
    [_timer invalidate];
    [_searchBar removeFromSuperview];
    _timer = nil;
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
}

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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_routesTable.mj_header setHidden:NO];
    [_routesTable.mj_footer resetNoMoreData];
    
    __weak __typeof(self)weakSelf = self;
    [_dataManager refreshDataWithFinishBlock:^(id response, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        if(!strongSelf.dataManager.hasMore)
            [strongSelf.routesTable.mj_footer endRefreshingWithNoMoreData];
        if(strongSelf.dataManager.isEmpty)
            [MBProgressHUD showText:@"未搜索到防区" inView:strongSelf.view];
        
        [strongSelf.routesTable.mj_header endRefreshing];
        [strongSelf.routesTable.mj_footer setHidden:NO];
        [strongSelf.routesTable reloadData];
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
    
    GTDeviceZoneModel *model = [self modelAtIndexPath:indexPath];
    [cell setupWithZoneModel:model];
    
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
    [templateCell setupWithZoneModel:model];
    
    CGFloat heigit = [templateCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    
    return heigit;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTDeviceZoneCell *cell = (GTDeviceZoneCell *)[tableView cellForRowAtIndexPath:indexPath];
    GTDeviceZoneModel *model = [self modelAtIndexPath:indexPath];
    
    model.isExpand = !model.isExpand;
    [cell setupWithZoneModel:model];

    [_routesTable reloadData];
}

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

#pragma mark - Search Item
- (void)enableSearchBar:(BOOL)yesOrNo;
{
    if(yesOrNo == YES)
        self.navigationItem.rightBarButtonItem = [self itemWithTitle:@"搜索" target:self action:@selector(didClickSearch:)];
    else
        self.navigationItem.rightBarButtonItem = nil;
}

//创建UIBarButtonItem
- (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"GTSearch"] forState:UIControlStateNormal];
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

#pragma mark - Cell Delegate

- (void)switchButtonWithDic:(NSDictionary *)infoDic
{
    __block GTDeviceZoneModel *model = [infoDic objectForKey:@"model"];
    NSNumber *isOn = [infoDic objectForKey:@"isOn"];
    NSString *iState;
    if(isOn.boolValue == YES)
        iState = @"2";
    else
        iState = @"1";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[GTHttpManager shareManager] GTDeviceZoneChangeDefenceWithState:iState zoneNo:model.zoneNo finishBlock:^(id response, NSError *error) {
        if(error == nil) {
            _loopCount = 5;
            _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerFired:) userInfo:infoDic repeats:YES];
            [_timer fire];
        }
        else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
}

- (void)timerFired:(NSDictionary *)infoDic
{
    if(_loopCount <= 0)
        return;
    else
        _loopCount--;
    
    __block GTDeviceZoneModel *model = [infoDic objectForKey:@"model"];
    NSNumber *isOn = [infoDic objectForKey:@"isOn"];
    NSString *iState;
    if(isOn.boolValue == YES)
        iState = @"2";
    else
        iState = @"1";
    
    NSLog(@"开始轮询");
    
    __block BOOL querySuccess = NO;
    
    switch (_listType) {
        case kListTypeAllZone:
        {
            //TODO: page number
//            [[GTHttpManager shareManager] GTDeviceZoneListWithPn:@"1" finishBlock:^(id response, NSError *error)
//             {
//                 if(error == nil)
//                 {
//                     NSArray *array = [[response objectForKey:@"page"] objectForKey:@"resultList"];
//                     NSArray *curModelArr = [MTLJSONAdapter modelsOfClass:GTDeviceZoneModel2.class fromJSONArray:array error:nil];
//                     for (GTDeviceZoneModel2 *curModel in curModelArr)
//                     {
//                         if([curModel.zoneNo isEqualToString:model.zoneNo])
//                         {
//                             if((iState.integerValue == kSwitchStateGuarded && curModel.zoneState.integerValue == kZoneStateGuarded)||
//                                (iState.integerValue == kSwitchStateDisguarded && curModel.zoneState.integerValue == kZoneStateDisguarded))
//                             {
//                                 querySuccess = YES;
//                                 break;
//                             }
//                         }
//                     }
//                 }
//             }];
            break;
        }
        case kListTypeViaDeviceNo:
        {
//            [[GTHttpManager shareManager] GTDeviceZoneWithDeviceNo:_deviceNo finishBlock:^(id response, NSError *error)
//             {
//                 if(error == nil)
//                 {
//                     NSArray *resData = [response objectForKey:@"list"];
//                     NSArray *array = [MTLJSONAdapter modelsOfClass:GTDeviceZoneModel.class fromJSONArray:resData error:nil];
//                     _dataManager.zoneModelsArray = [NSMutableArray arrayWithArray:array];
//                     
//                     for (GTDeviceZoneModel *curModel in _dataManager.zoneModelsArray)
//                     {
//                         if([curModel.zoneNo isEqualToString:model.zoneNo])
//                         {
//                             if((iState.integerValue == kSwitchStateGuarded && curModel.zoneState.integerValue == kZoneStateGuarded)||
//                                (iState.integerValue == kSwitchStateDisguarded && curModel.zoneState.integerValue == kZoneStateDisguarded))
//                             {
//                                 querySuccess = YES;
//                                 break;
//                             }
//                         }
//                     }
//                 }
//             }];
            break;
        }
        default:
            break;
    }
    
    
    if(querySuccess) {
        [_timer invalidate];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(iState.integerValue == kSwitchStateDisguarded) {//撤防成功
            [MBProgressHUD showText:@"撤防成功" inView:self.view];
            //改变model状态。
            model.zoneState = @"3";
            
        }
        else {//布防成功
            [MBProgressHUD showText:@"布防成功" inView:self.view];
            //改变model状态。
            model.zoneState = @"4";
        }
        //刷新界面
        [_routesTable reloadData];
    }
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
