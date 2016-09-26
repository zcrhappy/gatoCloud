//
//  GTZoneEditViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/6.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTZoneEditViewController.h"
#import "GTEditOneRowCell.h"
#import "GTEditTwoRowCell.h"
#define kZoneName @"防区名称"
#define kContact @"紧急联系人"
#define kPhone @"联系电话"
#define kLocInfo @"防区地理位置信息"
#define kSpace12 @"kSpace12"
#define kZoneDesc @"防区描述"
#define kSpace44 @"kSpace44"
#define kDoneButton @"确定"


@interface GTZoneEditViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) GTDeviceZoneModel *model;

@property (nonatomic, strong) UITableView *editTable;
@property (nonatomic, strong) NSArray *sectionArr;

@property (nonatomic, copy) NSString *zoneNo;
@property (nonatomic, copy) NSString *zoneName;
@property (nonatomic, copy) NSString *zoneContactor;
@property (nonatomic, copy) NSString *zonePhone;
@property (nonatomic, copy) NSString *zoneLoc;
@property (nonatomic, copy) NSString *zoneDesc;
@end

@implementation GTZoneEditViewController

- (instancetype)initWithModel:(GTDeviceZoneModel *)model;
{
    if(self = [super init]) {
        _model = model;
        _sectionArr = @[kZoneName, kContact, kPhone, kLocInfo, kSpace12, kZoneDesc, kSpace44, kDoneButton];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    NSLog(@"进入防区信息页面");
}

static NSString *GTEditOneRowCellID = @"GTEditOneRowCellID";
static NSString *kTwoRowIdentifier = @"kTwoRowIdentifier";

- (void)configUI
{
    self.navigationItem.title = @"防区信息";
    _editTable = [[UITableView alloc] initWithFrame:self.view.frame];
    [_editTable registerNib:[UINib nibWithNibName:@"GTEditOneRowCell" bundle:nil] forCellReuseIdentifier:GTEditOneRowCellID];
    [_editTable registerNib:[UINib nibWithNibName:@"GTEditTwoRowCell" bundle:nil] forCellReuseIdentifier:kTwoRowIdentifier];
    _editTable.tableFooterView = [[UIView alloc] init];
    
    _editTable.delegate = self;
    _editTable.dataSource = self;
    [self.view addSubview:_editTable];
}

#pragma mark - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath section];
    NSString *secName = [_sectionArr objectAtIndex:index];
    
    if([secName isEqualToString:kZoneName] ||
       [secName isEqualToString:kContact] ||
       [secName isEqualToString:kPhone] ||
       [secName isEqualToString:kLocInfo] ||
       [secName isEqualToString:kZoneDesc])
    {
        return [self tableView:tableView sectionName:secName EditRowAtIndexPath:indexPath];
    }
    if([secName isEqualToString:kDoneButton]) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
        UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH - 24, 50)];
        doneBtn.layer.cornerRadius = 4;
        doneBtn.layer.masksToBounds = YES;
        [doneBtn addTarget:self action:@selector(clickDone) forControlEvents:UIControlEventTouchUpInside];
        [doneBtn setBackgroundColor:[UIColor colorWithString:@"2abb9b"]];
        [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell addSubview:doneBtn];
        return cell;
    }
    if([secName isEqualToString:kSpace12])
        return [self cellWithHeight:12];
    if([secName isEqualToString:kSpace44])
        return [self cellWithHeight:44];
    
    return [[UITableViewCell alloc] init];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView sectionName:(NSString *)name EditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([name isEqualToString:kZoneName]) {
        GTEditOneRowCell *cell = [tableView dequeueReusableCellWithIdentifier:GTEditOneRowCellID forIndexPath:indexPath];
        __weak __typeof(self)weakSelf = self;
        [cell setTextDidChangeBlk:^(NSString *text) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.zoneName = text;
        }];
        self.zoneName = _model.zoneName;
        return [cell setupWithTitle:@"防区名称：" placeholder:@"请输入防区名称(必填)" content:_model.zoneName showLine:YES];
    }
    else if([name isEqualToString:kContact]) {
        GTEditOneRowCell *cell = [tableView dequeueReusableCellWithIdentifier:GTEditOneRowCellID forIndexPath:indexPath];
        __weak __typeof(self)weakSelf = self;
        [cell setTextDidChangeBlk:^(NSString *text) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.zoneContactor = text;
        }];
        self.zoneContactor = _model.zoneContactor;
        return [cell setupWithTitle:@"紧急联系人：" placeholder:@"请输入紧急联系人名称" content:_model.zoneContactor showLine:YES];
    }
    else if([name isEqualToString:kPhone]) {
        GTEditOneRowCell *cell = [tableView dequeueReusableCellWithIdentifier:GTEditOneRowCellID forIndexPath:indexPath];
        __weak __typeof(self)weakSelf = self;
        [cell setTextDidChangeBlk:^(NSString *text) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.zonePhone = text;
        }];
        self.zonePhone = _model.zonePhone;
        return [cell setupWithTitle:@"联系电话：" placeholder:@"请输入联系电话" content:_model.zonePhone showLine:YES];
    }
    else if ([name isEqualToString:kLocInfo]) {
        GTEditTwoRowCell *cell = [tableView dequeueReusableCellWithIdentifier:kTwoRowIdentifier forIndexPath:indexPath];
        __weak __typeof(self)weakSelf = self;
        [cell setTextDidChangeBlk:^(NSString *text) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.zoneLoc = text;
        }];
        self.zoneLoc = _model.zoneLoc;
        return [cell setupWithTitle:@"防区地理位置信息：" placeholder:@"请输入防区地理位置信息" content:_model.zoneLoc showLine:NO];
    }
    else if ([name isEqualToString:kZoneDesc]) {
        GTEditTwoRowCell *cell = [tableView dequeueReusableCellWithIdentifier:kTwoRowIdentifier forIndexPath:indexPath];
        __weak __typeof(self)weakSelf = self;
        [cell setTextDidChangeBlk:^(NSString *text) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.zoneDesc = text;
        }];
        self.zoneDesc = _model.zoneDesc;
        return [cell setupWithTitle:@"防区描述：" placeholder:@"请输入防区描述" content:_model.zoneDesc showLine:NO];
    }
    
    return [[UITableViewCell alloc] init];
}

- (UITableViewCell *)cellWithHeight:(CGFloat)height
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
    UIView *view = macroCreateView(CGRectMake(0, 0, SCREEN_WIDTH, height), [UIColor colorWithString:@"f7f7f7"]);
    [cell addSubview:view];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath section];
    NSString *secName = [_sectionArr objectAtIndex:index];
    
    if([secName isEqualToString:kZoneName] ||
       [secName isEqualToString:kContact] ||
       [secName isEqualToString:kPhone])
    {
        return 55;
    }
    if([secName isEqualToString:kLocInfo])
        return 110;
    if([secName isEqualToString:kZoneDesc])
        return 95;
    if([secName isEqualToString:kDoneButton])
        return 50;
    if([secName isEqualToString:kSpace12])
        return 12;
    if([secName isEqualToString:kSpace44])
        return 44;
    else
        return 0;
}

- (void)clickDone
{
    if([_zoneName isEmptyString] || _zoneName == nil) {
        [MBProgressHUD showText:@"请输入防区名称" inView:self.view];
        return;
    }
    
    [[GTHttpManager shareManager] GTDeviceZoneEditInfoWithZoneNo:_model.zoneNo zoneName:_zoneName zoneContactor:_zoneContactor zonePhone:_zonePhone zoneLoc:_zoneLoc zoneDesc:_zoneDesc finishBlock:^(id response, NSError *error) {
        if(!error) {
            _model.zoneName = _zoneName;
            _model.zonePhone = _zonePhone;
            _model.zoneContactor = _zoneContactor;
            _model.zoneLoc = _zoneLoc;
            _model.zoneDesc = _zoneDesc;
            
            if(_editSuccessBlock)
                _editSuccessBlock(_model);
            
            __weak __typeof(self)weakSelf = self;
            [self gt_showMsgControllerWithTitle:@"提示" msg:@"恭喜您设置成功!\n后台可能需要几分钟响应时间，请您稍后查看!" finishBlock:^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}
@end
