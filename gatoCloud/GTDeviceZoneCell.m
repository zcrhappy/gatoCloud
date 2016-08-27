//
//  GTDeviceZoneCell.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/28.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTDeviceZoneCell.h"
#import "GTDeviceZoneModel.h"
#import "GTZoneStrainView.h"
#import "GTZoneInfoView.h"
#define bottomBackgroundColor [UIColor colorWithString:@"f5f5f5"]
@interface GTDeviceZoneCell()
@property (strong, nonatomic) UIView *upContainer;
@property (strong, nonatomic) UIView *horSerparatorLine;
@property (strong, nonatomic) UIView *bottomContainer;
@property (nonatomic, strong) MASConstraint *expandConstaint;
@property (nonatomic, strong) MASConstraint *unExpandConstraint;

//up
@property (nonatomic, strong) UILabel *zoneNameLabel;
@property (nonatomic, strong) UILabel *zoneTypeLabel;
@property (nonatomic, strong) UILabel *zoneStateLabel;
@property (nonatomic, strong) UISwitch *guardSwitch;

//bottom
@property (nonatomic, strong) GTZoneStrainView *stainView;
@property (nonatomic, strong) GTZoneInfoView *infoView;

@property (nonatomic, strong) GTDeviceZoneModel *model;

@property (nonatomic, strong) MASConstraint *stateLabelRightConstaint;
@end

@implementation GTDeviceZoneCell
@synthesize upContainer,horSerparatorLine,bottomContainer,expandConstaint,unExpandConstraint,zoneNameLabel,zoneTypeLabel,guardSwitch,zoneStateLabel;
- (void)awakeFromNib {
    [super awakeFromNib];
    [self configUI];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.selectedBackgroundView = macroCreateView(CGRectZero, [UIColor clearColor]);
        
        [self configUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    horSerparatorLine.backgroundColor = [UIColor colorWithString:@"e0e0e0"];
}

- (void)configUI
{
    upContainer = macroCreateView(CGRectZero, [UIColor whiteColor]);
    [self.contentView addSubview:upContainer];
    [upContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@77.5);
    }];
    
    zoneNameLabel = macroCreateLabel(CGRectZero, [UIColor whiteColor], 18, [UIColor colorWithString:@"212121"]);
    [upContainer addSubview:zoneNameLabel];
    [zoneNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@16);
        make.left.equalTo(@18);
        make.height.greaterThanOrEqualTo(@21);
    }];
    
    zoneTypeLabel = macroCreateLabel(CGRectZero, [UIColor whiteColor], 14, [UIColor colorWithString:@"b9bdc0"]);
    [upContainer addSubview:zoneTypeLabel];
    [zoneTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(zoneNameLabel.mas_bottom).offset(8);
        make.left.equalTo(zoneNameLabel);
    }];
    
    guardSwitch = [[UISwitch alloc] init];
    [guardSwitch addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [upContainer addSubview:guardSwitch];
    [guardSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(upContainer).offset(-18);
        make.centerY.equalTo(zoneNameLabel);
        make.width.equalTo(@51).priorityHigh();
        make.height.equalTo(@31);
    }];
    
    zoneStateLabel = macroCreateLabel(CGRectZero, [UIColor whiteColor], 14, [UIColor colorWithString:@"b9bdc0"]);
    [upContainer addSubview:zoneStateLabel];
    [zoneStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        _stateLabelRightConstaint = make.right.equalTo(guardSwitch.mas_left).offset(-10).priorityHigh();
        make.right.equalTo(upContainer).offset(-18).priorityMedium();
        make.centerY.equalTo(guardSwitch);
    }];
    
    horSerparatorLine = macroCreateView(CGRectZero, [UIColor colorWithString:@"e0e0e0"]);
    [self.contentView addSubview:horSerparatorLine];
    [horSerparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upContainer.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@(SINGLE_LINE_WIDTH));
    }];
    
    bottomContainer = macroCreateView(CGRectZero, bottomBackgroundColor);
    [self.contentView addSubview:bottomContainer];
    
    _stainView = [[NSBundle mainBundle] loadNibNamed:@"GTZoneStrainView" owner:self options:Nil][0];
    [bottomContainer addSubview:_stainView];
    [_stainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(_stainView.viewHeight));
    }];
    __weak __typeof(self)weakSelf = self;
    
    
    
    _infoView = [[NSBundle mainBundle] loadNibNamed:@"GTZoneInfoView" owner:self options:nil][0];
    [bottomContainer addSubview:_infoView];
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_stainView.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    [_infoView setClickEditBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf clickEdit];
    }];
    
    UIView *lastView = _infoView;
    //用来计算下半部分的高度
    UIView *placeholderView = macroCreateView(CGRectZero, [UIColor clearColor]);
    [bottomContainer addSubview:placeholderView];
    [placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(lastView.mas_bottom);
    }];
    
    [bottomContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(horSerparatorLine.mas_bottom);
        make.width.equalTo(self.contentView);
        unExpandConstraint = make.height.equalTo(placeholderView.mas_height);
        expandConstaint = make.height.equalTo(@0);
        make.bottom.equalTo(self.contentView.mas_bottom);
        [self expand:NO];
    }];
}


- (void)setupWithZoneModel:(GTDeviceZoneModel *)model
{
    _model = model;
    zoneNameLabel.text = model.zoneName;
    zoneStateLabel.text = model.zoneStateString;
    guardSwitch.on = model.zoneStateForSwithButton;
    zoneTypeLabel.text = [NSString stringWithFormat:@"防区类型:%@",[model zoneTypeStringWithSuffix:YES]];
    
    [_infoView setupWithModel:model];
    
    if(model.isStainZone){
        [_stainView setupWithModel:model];
        _stainView.hidden = NO;
    }
    else {
        _stainView.hidden = YES;
    }
    
    if(model.isTwentyFourHourZone){
        zoneStateLabel.text = [NSString stringWithFormat:@"24小时防区 %@",[model twentyFourHourZoneStateString]];
        guardSwitch.hidden = YES;
        [_stateLabelRightConstaint uninstall];
    }
    else {
        guardSwitch.hidden = NO;
        [_stateLabelRightConstaint install];
    }

    [self setupWithExpanded:model.isExpand];
}

- (void)setupWithExpanded:(BOOL)expanded;
{
    [self expand:expanded];
}

- (void)expand:(BOOL)shouldExpand
{
    if(shouldExpand) {
        [expandConstaint uninstall];
        [unExpandConstraint install];
        
        for (UIView *view in bottomContainer.subviews) {
            view.hidden = NO;
        }
    }
    else {
        [expandConstaint install];
        [unExpandConstraint uninstall];
        for (UIView *view in bottomContainer.subviews) {
            view.hidden = YES;
        }
    }
}


- (void)clickSwitch:(UISwitch *)btn
{
    [btn setOn:NO animated:YES];//状态由服务器确定。因此这里不进行修改
    
    NSString *warningString = nil;
    if(![_model zoneOnlineBoolValue]) {
        warningString =@"当前防区不在线，不能操作!";
    }
    else if(_model.zoneState.integerValue == kZoneStateUnderDisguarding) {
        warningString = @"正在撤防中，不能操作!";
    }
    else if (_model.zoneState.integerValue == kZoneStateUnderGuarding) {
        warningString = @"正在布防中，不能操作!";
    }

#ifndef kGlobalTest
    if(warningString) {
        [MBProgressHUD showText:warningString inView:[UIView gt_keyWindow]];
        return;
    }
    
#endif
    BOOL isOn = btn.isOn;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_model, @"model", @(isOn), @"isOn", nil];
    
    if(_delegate && [_delegate respondsToSelector:@selector(switchButtonWithDic:)]) {
        [_delegate performSelector:@selector(switchButtonWithDic:) withObject:dic];
    }
}

- (void)clickEdit
{
    if(_delegate && [_delegate respondsToSelector:@selector(clickEditWithModel:)]) {
        [_delegate performSelector:@selector(clickEditWithModel:) withObject:_model];
    }
}

@end
