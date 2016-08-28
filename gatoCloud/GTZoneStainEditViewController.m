//
//  GTZoneStainEditViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/28.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTZoneStainEditViewController.h"
#import "GTEditOneRowCell.h"
#import "GTDoneButtonCell.h"
#import "GTDeviceZoneModel.h"
@interface GTZoneStainEditViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *editTable;
@property (nonatomic, strong) GTDeviceZoneModel *model;
@property (nonatomic, copy) NSString *looseValueStr;
@property (nonatomic, copy) NSString *tightValueStr;

@end

@implementation GTZoneStainEditViewController

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
    [_editTable registerNib:[UINib nibWithNibName:@"GTDoneButtonCell" bundle:nil] forCellReuseIdentifier:@"GTDoneButtonCellID"];
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
        [cell setupWithTitle:@"松弛阈值" placeholder:@"请输入松弛阈值(10~99)" content:nil showLine:YES];
        __weak __typeof(self)weakSelf = self;
        [cell setTextDidChangeBlk:^(NSString *content) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.looseValueStr = content;
        }];
    }
    else if (row == 1) {
        [cell setupWithTitle:@"拉紧阈值" placeholder:@"请输入拉紧阈值(10~99)" content:nil showLine:YES];
        __weak __typeof(self)weakSelf = self;
        [cell setTextDidChangeBlk:^(NSString *content) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.tightValueStr = content;
        }];
    }
    return cell;

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
    if(_looseValueStr == nil || [_looseValueStr isEmptyString]) {
        [MBProgressHUD showText:@"请输入松弛阈值" inView:self.view];
        return;
    }
    else if(_tightValueStr == nil || [_tightValueStr isEmptyString]) {
        [MBProgressHUD showText:@"请输入拉紧阈值" inView:self.view];
        return;
    }
    else if (_looseValueStr.integerValue < 10 || _looseValueStr.integerValue > 99) {
        [MBProgressHUD showText:@"松弛阈值的范围区间在10~99，请重新设置" inView:self.view];
        return;
    }
    else if (_tightValueStr.integerValue < 10 || _tightValueStr.integerValue > 99) {
        [MBProgressHUD showText:@"拉紧阈值的范围区间在10~99，请重新设置" inView:self.view];
        return;
    }
    
    NSString *zoneStrainVpt = [NSString stringWithFormat:@"(%@,%@)",_looseValueStr,_tightValueStr];
    
    [[GTHttpManager shareManager] GTEditZoneStrainWithZoneNo:_model.zoneNo zoneStrainVpt:zoneStrainVpt finishBlock:^(id response, NSError *error) {
        
        if(error == nil) {
            [MBProgressHUD showText:@"恭喜您设置张力阈值成功!" inView:[UIView gt_keyWindow]];
            if(_didSuccessBlock)
                _didSuccessBlock();
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
