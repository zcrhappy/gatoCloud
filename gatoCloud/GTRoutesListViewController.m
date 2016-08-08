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
typedef NS_ENUM(NSInteger, kListType) {
    kListTypeAllZone,
    kListTypeCertainDevice,
    kListTypeViaDeviceName,
    kListTypeViaZoneName
};

@interface GTRoutesListViewController ()<UITableViewDelegate, UITableViewDataSource, GTDeviceZoneCellDelegate>
@property (nonatomic, strong) UITableView *routesTable;
@property (nonatomic, strong) NSMutableArray<GTDeviceZoneModel *> *zoneModelsArray;
@property (nonatomic, copy) NSString *deviceNo;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *zoneName;
@property (nonatomic, assign) kListType listType;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger loopCount;
@property (nonatomic, strong) GTSearchBar *searchBar;
@end

@implementation GTRoutesListViewController

- (instancetype)initWithDeviceName:(NSString *)deviceName;
{
    if(self = [super init]) {
        _deviceName = deviceName;
        _listType = kListTypeViaDeviceName;
    }
    return self;
}
- (instancetype)initWithZoneName:(NSString *)zoneName;
{
    if(self = [super init]) {
        _zoneName = zoneName;
        _listType = kListTypeViaZoneName;
    }
    return self;
}
- (instancetype)initWithDeviceNo:(NSString *)deviceNo
{
    if(self = [super init]) {
        _deviceNo = deviceNo;
        _listType = kListTypeCertainDevice;
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

    [self configUI];
    
    if(_listType == kListTypeAllZone || _listType == kListTypeCertainDevice)
        [self pullDownToRefresh];
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}
- (void)configUI
{
    _routesTable = macroCreateTableView(self.view.bounds, [UIColor whiteColor]);
    [self.view addSubview:_routesTable];
    _routesTable.delegate = self;
    _routesTable.dataSource = self;
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToRefresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _routesTable.mj_header = header;
    
    _routesTable.tableFooterView = [UIView new];
    _routesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _routesTable.rowHeight = 78;
    [_routesTable registerClass:GTDeviceZoneCell.class forCellReuseIdentifier:kGTDeviceZoneCellIdentifier];
    
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
            
            if(strongSelf.listType == kListTypeViaZoneName)
                strongSelf.zoneName = keyword;
            else if(strongSelf.listType == kListTypeViaDeviceName)
                strongSelf.deviceName = keyword;
            
            [strongSelf pullDownToRefresh];
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if(_searchBar) {
        [_searchBar removeFromSuperview];
    }
}


- (void)pullDownToRefresh
{
    switch (_listType) {
        case kListTypeAllZone:
            [self fetchList];
            break;
        case kListTypeCertainDevice:
            [self fetchListWithDeviceNo:_deviceNo];
            break;
        case kListTypeViaZoneName:
            [self fetchListWithZoneName:_zoneName];
            break;
        case kListTypeViaDeviceName:
            [self fetchListWithDeviceName:_deviceName];
            break;
    }
}

#pragma mark - Data Manager

- (void)fetchList
{
    [[GTHttpManager shareManager] GTDeviceZoneListWithPn:@"1" finishBlock:^(id response, NSError *error) {
        [_routesTable.mj_header endRefreshing];
        
        if(error == nil) {
            NSArray *array = [[response objectForKey:@"page"] objectForKey:@"resultList"];
            
            NSArray *oldModelArr = [MTLJSONAdapter modelsOfClass:GTDeviceZoneModel2.class fromJSONArray:array error:nil];
            _zoneModelsArray = [GTDeviceZoneModel transformFromArray:oldModelArr];
            
            [_routesTable reloadData];
            NSLog(@"");
        }
    }];
}

- (void)fetchListWithDeviceNo:(NSString *)deviceNo
{
    [[GTHttpManager shareManager] GTDeviceZoneWithDeviceNo:deviceNo finishBlock:^(id response, NSError *error) {
        [_routesTable.mj_header endRefreshing];
        
        if(error == nil) {
            NSArray *resData = [response objectForKey:@"list"];
            
            _zoneModelsArray = [MTLJSONAdapter modelsOfClass:GTDeviceZoneModel.class fromJSONArray:resData error:nil];
            [_routesTable reloadData];
            NSLog(@"");
        }
    }];
}

- (void)fetchListWithDeviceName:(NSString *)deviceName
{
    [[GTHttpManager shareManager] GTDeviceZoneWithDeviceName:deviceName pn:@"1" finishBlock:^(id response, NSError *error) {
        [_routesTable.mj_header endRefreshing];
        
        if(error == nil) {
            NSArray *array = [[response objectForKey:@"page"] objectForKey:@"resultList"];
            
            NSArray *oldModelArr = [MTLJSONAdapter modelsOfClass:GTDeviceZoneModel2.class fromJSONArray:array error:nil];
            _zoneModelsArray = [GTDeviceZoneModel transformFromArray:oldModelArr];
            
            [_routesTable reloadData];
            NSLog(@"");
        }
    }];
}

- (void)fetchListWithZoneName:(NSString *)zoneName
{
    [[GTHttpManager shareManager] GTDeviceZoneListWithZoneName:zoneName pn:@"1" finishBlock:^(id response, NSError *error) {
        [_routesTable.mj_header endRefreshing];
        
        if(error == nil) {
            NSArray *array = [[response objectForKey:@"page"] objectForKey:@"resultList"];
            
            NSArray *oldModelArr = [MTLJSONAdapter modelsOfClass:GTDeviceZoneModel2.class fromJSONArray:array error:nil];
            _zoneModelsArray = [GTDeviceZoneModel transformFromArray:oldModelArr];
            
            [_routesTable reloadData];
            NSLog(@"");
        }
    }];
}

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _zoneModelsArray.count;
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
    return _zoneModelsArray[row];
}

- (NSIndexPath *)indexPathOfModel:(GTDeviceZoneModel *)model
{
    NSInteger row = [_zoneModelsArray indexOfObject:model];
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
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = (CGRect){CGPointZero, {100, 20}};
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
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
            GTRoutesListViewController *viewController = [[GTRoutesListViewController alloc] initWithZoneName:nil];
            [strongSelf.navigationController pushViewController:viewController animated:YES];
        }
        else if([selection isEqualToString:kSearchViaDeviceName]) {
            GTRoutesListViewController *viewController = [[GTRoutesListViewController alloc] initWithDeviceName:nil];
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
            [[GTHttpManager shareManager] GTDeviceZoneListWithPn:@"1" finishBlock:^(id response, NSError *error)
             {
                 if(error == nil)
                 {
                     NSArray *array = [[response objectForKey:@"page"] objectForKey:@"resultList"];
                     NSArray *curModelArr = [MTLJSONAdapter modelsOfClass:GTDeviceZoneModel2.class fromJSONArray:array error:nil];
                     for (GTDeviceZoneModel2 *curModel in curModelArr)
                     {
                         if([curModel.zoneNo isEqualToString:model.zoneNo])
                         {
                             if((iState.integerValue == kSwitchStateGuarded && curModel.zoneState.integerValue == kZoneStateGuarded)||
                                (iState.integerValue == kSwitchStateDisguarded && curModel.zoneState.integerValue == kZoneStateDisguarded))
                             {
                                 querySuccess = YES;
                                 break;
                             }
                         }
                     }
                 }
             }];
            break;
        }
        case kListTypeCertainDevice:
        {
            [[GTHttpManager shareManager] GTDeviceZoneWithDeviceNo:_deviceNo finishBlock:^(id response, NSError *error)
             {
                 if(error == nil)
                 {
                     NSArray *resData = [response objectForKey:@"list"];
                     _zoneModelsArray = [MTLJSONAdapter modelsOfClass:GTDeviceZoneModel.class fromJSONArray:resData error:nil];
                     for (GTDeviceZoneModel *curModel in _zoneModelsArray)
                     {
                         if([curModel.zoneNo isEqualToString:model.zoneNo])
                         {
                             if((iState.integerValue == kSwitchStateGuarded && curModel.zoneState.integerValue == kZoneStateGuarded)||
                                (iState.integerValue == kSwitchStateDisguarded && curModel.zoneState.integerValue == kZoneStateDisguarded))
                             {
                                 querySuccess = YES;
                                 break;
                             }
                         }
                     }
                     
                 }
             }];
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
        strongSelf.zoneModelsArray[row] = newModel;
        [strongSelf.routesTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

@end
