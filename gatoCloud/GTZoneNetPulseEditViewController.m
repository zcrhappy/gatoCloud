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
@interface GTZoneNetPulseEditViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *editTable;
@property (nonatomic, strong) GTDeviceZoneModel *model;
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    GTEditOneRowCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GTEditOneRowCellID" forIndexPath:indexPath];
    if(row == 0) {
        [cell setupWithTitle:@"工作模式" placeholder:@"请选择工作模式" content:[_model getNetPulseValue:GTNetPulseValueMode] showLine:YES];
        [cell shouldEditTextField:NO];
        __weak __typeof(self)weakSelf = self;
//        [cell setTextDidChangeBlk:^(NSString *content) {
//            __strong __typeof(weakSelf)strongSelf = weakSelf;
//            strongSelf.looseValueStr = content;
//        }];
    }
    else if (row == 1) {
        [cell setupWithTitle:@"电压" placeholder:@"请选择电压值" content:[_model getNetPulseValue:GTNetPulseValueVoltage] showLine:YES];
        [cell shouldEditTextField:NO];
        __weak __typeof(self)weakSelf = self;
//        [cell setTextDidChangeBlk:^(NSString *content) {
//            __strong __typeof(weakSelf)strongSelf = weakSelf;
//            strongSelf.tightValueStr = content;
//        }];
    }
    else if (row == 2) {
        [cell setupWithTitle:@"灵敏度" placeholder:@"请选择灵敏度" content:[_model getNetPulseValue:GTNetPulseValueSensitive] showLine:YES];
        [cell shouldEditTextField:NO];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSArray *selectionArr;
    NSString *title;
    GTEditOneRowCell *cell = (GTEditOneRowCell *)[tableView cellForRowAtIndexPath:indexPath];
    __weak __typeof(cell)weakCell = cell;
    if(row == 0) {
        title = @"工作模式选择";
        selectionArr = @[@"脉冲", @"触网", @"脉冲&触网"];
    }
    else if (row == 1) {
        title = @"电压选择";
        selectionArr = @[@"一级", @"二级", @"三级", @"四级"];
    }
    else if (row == 2) {
        title = @"灵敏度选择";
        selectionArr = @[@"一级", @"二级"];
    }
    
    [CRSelectActionSheet actionSheetWithTitle:title selectionArr:selectionArr buttonClicked:^(NSString *selectionTitle) {
        __strong __typeof(weakCell)strongCell = weakCell;
        [strongCell updateContent:selectionTitle];
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
    
}

@end
