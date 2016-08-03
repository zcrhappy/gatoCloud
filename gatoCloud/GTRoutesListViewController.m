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

#define kGTDeviceZoneCellIdentifier @"GTDeviceZoneCellIdentifier"

typedef NS_ENUM(NSInteger, kListType) {
    kListTypeAllZone,
    kListTypeCertainDevice,
};

@interface GTRoutesListViewController ()<UITableViewDelegate, UITableViewDataSource, GTDeviceZoneCellDelegate>
@property (nonatomic, strong) UITableView *routesTable;
@property (nonatomic, strong) NSArray<GTDeviceZoneModel *> *zoneModelsArray;
@property (nonatomic, copy) NSString *deviceNo;
@property (nonatomic, assign) kListType listType;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation GTRoutesListViewController

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
        _listType = kListTypeAllZone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
    [self pullDownToRefresh];
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
    }
}

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
            _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerFired:) userInfo:infoDic repeats:10];
            [_timer fire];
        }
        else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
}

- (void)timerFired:(NSDictionary *)infoDic
{
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
}

@end
