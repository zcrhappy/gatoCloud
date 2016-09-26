//
//  GTZoneNetPulseEditViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 2016/9/26.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTZoneNetPulseEditViewController.h"
#import "GTDeviceZoneModel.h"
#import "GTDoneButtonCell.h"
#import "GTEditOneRowCell.h"
#import "CRSelectActionSheet.h"

#define kModeRow @"kModeRow"
#define kVoltageRow @"kVoltageRow"
#define kSensitiveRow @"kSensitiveRow"

@interface GTZoneNetPulseEditViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *editTable;
@property (nonatomic, strong) GTDeviceZoneModel *model;
@property (nonatomic, strong) NSArray *rowArray;
@property (nonatomic, copy) NSString *modeStr;
@property (nonatomic, copy) NSString *voltageStr;
@property (nonatomic, copy) NSString *sensitiveStr;
@end

@implementation GTZoneNetPulseEditViewController

- (instancetype)initWithModel:(id)model;
{
    if(self = [super init]) {
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
    _modeStr = [_model getNetPulseValue:GTNetPulseValueMode];
    _voltageStr = [_model getNetPulseValue:GTNetPulseValueVoltage];
    _sensitiveStr = [_model getNetPulseValue:GTNetPulseValueSensitive];
    [self.editTable reloadData];
}

- (void)configUI
{
    _editTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _editTable.backgroundColor = [UIColor colorWithString:kLightBackground];
    _editTable.delegate = self;
    _editTable.dataSource = self;
    [self.view addSubview:_editTable];
    
    [_editTable registerNib:[UINib nibWithNibName:@"GTEditOneRowCell" bundle:nil] forCellReuseIdentifier:@"GTEditOneRowCellID"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([_model isZoneType:GTZoneTypeNetPulse])
        _rowArray = @[kModeRow, kVoltageRow, kSensitiveRow];
    else if([_model isZoneType:GTZoneTypeNet])
        _rowArray = @[kModeRow, kSensitiveRow];
    else if ([_model isZoneType:GTZoneTypePulse])
        _rowArray = @[kModeRow, kVoltageRow];
    else
        _rowArray = @[];
    
    return _rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSString *rowName = _rowArray[row];
    
    GTEditOneRowCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GTEditOneRowCellID" forIndexPath:indexPath];
    if([rowName isEqualToString:kModeRow]) {
        
        [cell setupWithTitle:@"工作模式" placeholder:@"请选择工作模式" content:_modeStr showLine:YES];
        [cell shouldEditTextField:NO];
    }
    else if ([rowName isEqualToString:kVoltageRow]) {
        [cell setupWithTitle:@"电压" placeholder:@"请选择电压值" content:_voltageStr showLine:YES];
        [cell shouldEditTextField:NO];
    }
    else if ([rowName isEqualToString:kSensitiveRow]) {
        [cell setupWithTitle:@"灵敏度" placeholder:@"请选择灵敏度" content:_sensitiveStr showLine:YES];
        [cell shouldEditTextField:NO];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSString *rowName = _rowArray[row];
    NSArray *selectionArr;
    NSString *title;
    GTEditOneRowCell *cell = (GTEditOneRowCell *)[tableView cellForRowAtIndexPath:indexPath];
    __weak __typeof(cell)weakCell = cell;
    if([rowName isEqualToString:kModeRow]) {
        if([_model isZoneType:GTZoneTypePulse] || [_model isZoneType:GTZoneTypeNet]){
            return;//脉冲，触网防区不允许选择工作模式
        }
        else {
            title = @"工作模式选择";
            selectionArr = @[@"脉冲", @"触网", @"脉冲&触网"];
        }
    }
    else if ([rowName isEqualToString:kVoltageRow]) {
        title = @"电压选择";
        selectionArr = @[@"一级", @"二级", @"三级", @"四级"];
    }
    else if ([rowName isEqualToString:kSensitiveRow]) {
        title = @"灵敏度选择";
        selectionArr = @[@"一级", @"二级"];
    }
    __weak __typeof(self)weakSelf = self;
    [CRSelectActionSheet actionSheetWithTitle:title selectionArr:selectionArr buttonClicked:^(NSString *selectionTitle) {
        __strong __typeof(weakCell)strongCell = weakCell;
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongCell updateContent:selectionTitle];
        
        if([rowName isEqualToString:kModeRow])
            strongSelf.modeStr = selectionTitle;
        else if ([rowName isEqualToString:kVoltageRow])
            strongSelf.voltageStr = selectionTitle;
        else if ([rowName isEqualToString:kSensitiveRow])
            strongSelf.sensitiveStr = selectionTitle;
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    GTDoneButtonCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GTDoneButtonCell" owner:self options:nil][0];
    __weak __typeof(self)weakSelf = self;
    [cell setClickDoneBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf clickDone];
    }];
    
    return cell;
}

- (void)clickDone
{
    NSArray *modeArray = @[kDefaultString, @"脉冲", @"触网", @"脉冲&触网"];
    NSArray *levelArray = @[kDefaultString, @"一级", @"二级", @"三级", @"四级"];
    
    if([_rowArray containsObject:kVoltageRow] &&
       [levelArray indexOfObject:_voltageStr] == NSNotFound) {
        [MBProgressHUD showText:@"请选择电压" inView:self.view];
        return;
    }
    else if([_rowArray containsObject:kSensitiveRow] &&
            [levelArray indexOfObject:_sensitiveStr] == NSNotFound) {
        [MBProgressHUD showText:@"请选择灵敏度" inView:self.view];
        return;
    }
    
    NSString *param1 = @([levelArray indexOfObject:_voltageStr]).stringValue;
    NSString *param2 = @([levelArray indexOfObject:_sensitiveStr]).stringValue;
    NSString *param3 = @([modeArray indexOfObject:_modeStr]).stringValue;
    NSString *param = [NSString stringWithFormat:@"%@,%@,%@",param1, param2, param3];
    
    [[GTHttpManager shareManager] GTEditZoneNetPulseWithZoneNo:_model.zoneNo zoneParam:param finishBlock:^(id response, NSError *error) {
        if(!error) {
            _model.zoneParam = param;
            
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
