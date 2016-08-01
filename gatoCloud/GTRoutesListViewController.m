//
//  GTRoutesListViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/28.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTRoutesListViewController.h"
#import "GTDeviceZoneModel.h"
#import "GTDeviceZoneCell.h"

#define kGTDeviceZoneCellIdentifier @"GTDeviceZoneCellIdentifier"

@interface GTRoutesListViewController ()<UITableViewDelegate, UITableViewDataSource, GTDeviceZoneCellDelegate>
@property (nonatomic, strong) UITableView *routesTable;
@property (nonatomic, strong) NSArray<GTDeviceZoneModel *> *zoneModelsArray;
@property (nonatomic, copy) NSString *deviceNo;
@end

@implementation GTRoutesListViewController

- (instancetype)initWithDeviceNo:(NSString *)deviceNo
{
    if(self = [super init]) {
        _deviceNo = deviceNo;
    }
    return self;
}

- (instancetype)init;
{
    if(self = [super init]) {
        
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
    if(_deviceNo)
        [self fetchListWithDeviceNo:_deviceNo];
    else
        [self fetchList];
}

- (void)fetchList
{
    [[GTHttpManager shareManager] GTDeviceZoneListWithPn:@"0" finishBlock:^(id response, NSError *error) {
        [_routesTable.mj_header endRefreshing];
        
        if(error == nil) {
            NSArray *array = [[response objectForKey:@"page"] objectForKey:@"resultList"];
            
            _zoneModelsArray = [MTLJSONAdapter modelsOfClass:GTDeviceZoneModel.class fromJSONArray:array error:nil];
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
    
    [[GTHttpManager shareManager] GTDeviceZoneChangeDefenceWithState:iState zoneNo:model.zoneNo finishBlock:^(id response, NSError *error) {
        if(error == nil) {
            if([iState isEqualToString:@"1"]) {//撤防成功
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
    }];
    
}

- (void)clickEditWithModel:(GTDeviceZoneModel *)model
{
    //点击进入防区信息详情页
}

@end
