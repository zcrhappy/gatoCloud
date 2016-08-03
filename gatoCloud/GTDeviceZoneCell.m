//
//  GTDeviceZoneCell.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/28.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTDeviceZoneCell.h"
#import "GTDeviceZoneModel.h"
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
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UILabel *contactLabel;
@property (nonatomic, strong) UILabel *zonePhoneLabel;
@property (nonatomic, strong) UILabel *zoneLocLabel;

@property (nonatomic, strong) GTDeviceZoneModel *model;

@end

@implementation GTDeviceZoneCell
@synthesize upContainer,horSerparatorLine,bottomContainer,expandConstaint,unExpandConstraint,zoneNameLabel,zoneTypeLabel,guardSwitch,contactLabel,zonePhoneLabel,zoneLocLabel,editButton,zoneStateLabel;
- (void)awakeFromNib {
    [super awakeFromNib];
    [self configUI];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
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
        make.width.equalTo(@51);
        make.height.equalTo(@31);
    }];
    
    zoneStateLabel = macroCreateLabel(CGRectZero, [UIColor whiteColor], 14, [UIColor colorWithString:@"b9bdc0"]);
    [upContainer addSubview:zoneStateLabel];
    [zoneStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(guardSwitch.mas_left).offset(-10);
        make.centerY.equalTo(guardSwitch);
    }];
    
    horSerparatorLine = macroCreateView(CGRectZero, [UIColor colorWithString:@"e0e0e0"]);
    [self.contentView addSubview:horSerparatorLine];
    [horSerparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upContainer.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@(SINGLE_LINE_WIDTH));
    }];
    
    bottomContainer = macroCreateView(CGRectZero, [UIColor colorWithString:@"f5f5f5"]);
    [self.contentView addSubview:bottomContainer];
    
    UILabel *label1 = macroCreateLabel(CGRectZero, [UIColor colorWithString:@"f5f5f5"], 14, [UIColor greenColor]);
    label1.text = @"防区信息";
    [bottomContainer addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@16);
    }];
    
    editButton = macroCreateButton(CGRectZero, [UIColor colorWithString:@"f5f5f5"]);
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(clickEdit:) forControlEvents:UIControlEventTouchUpInside];
    [bottomContainer addSubview:editButton];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label1);
        make.right.equalTo(bottomContainer).offset(-10);
        make.width.equalTo(@40);
        make.top.equalTo(@20);
    }];
    
    UILabel *label2 = macroCreateLabel(CGRectZero, [UIColor colorWithString:@"f5f5f5"], 14, [UIColor colorWithString:@"212121"]);
    label2.text = @"紧急联系人";
    [bottomContainer addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(16);
        make.left.equalTo(label1);
    }];
    
    contactLabel = macroCreateLabel(CGRectZero, [UIColor colorWithString:@"f5f5f5"], 14, [UIColor colorWithString:@"212121"]);
    [bottomContainer addSubview:contactLabel];
    contactLabel.numberOfLines = 0;
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).offset(3);
        make.left.equalTo(label2);
        make.width.lessThanOrEqualTo(@(SCREEN_WIDTH/2.0 - 40));
    }];
    
    UILabel *label3 = macroCreateLabel(CGRectZero, [UIColor colorWithString:@"f5f5f5"], 14, [UIColor colorWithString:@"212121"]);
    label3.text = @"防区电话";
    [bottomContainer addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2);
        make.left.equalTo(@(SCREEN_WIDTH/2.0));
    }];
    
    zonePhoneLabel = macroCreateLabel(CGRectZero, [UIColor colorWithString:@"f5f5f5"], 14, [UIColor colorWithString:@"212121"]);
    [bottomContainer addSubview:zonePhoneLabel];
    zonePhoneLabel.numberOfLines = 0;
    [zonePhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label3.mas_bottom).offset(3);
        make.left.equalTo(label3);
        make.right.lessThanOrEqualTo(bottomContainer).offset(-10);
    }];
    
    UILabel *label4 = macroCreateLabel(CGRectZero, [UIColor colorWithString:@"f5f5f5"], 14, [UIColor colorWithString:@"212121"]);
    label4.text = @"防区地理位置信息";
    [bottomContainer addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contactLabel.mas_bottom).offset(30);
        make.left.equalTo(label2);
    }];
    
    zoneLocLabel = macroCreateLabel(CGRectZero, [UIColor colorWithString:@"f5f5f5"], 14, [UIColor colorWithString:@"212121"]);
    zoneLocLabel.numberOfLines = 0;
    [bottomContainer addSubview:zoneLocLabel];
    [zoneLocLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label4.mas_bottom).offset(3);
        make.left.equalTo(label4);
        make.right.lessThanOrEqualTo(bottomContainer).offset(-10);
    }];
    
    UIView *placeholderView = macroCreateView(CGRectZero, [UIColor clearColor]);
    [bottomContainer addSubview:placeholderView];
    [placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(zoneLocLabel.mas_bottom).offset(14);;
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
    
    if(model.zoneContactor || [model.zoneContactor isEmptyString])
        contactLabel.text = @"--";
    else
        contactLabel.text = model.zoneContactor;
    
    if(model.zonePhone || [model.zonePhone isEmptyString])
        zonePhoneLabel.text = @"--";
    else
        zonePhoneLabel.text = model.zonePhone;
    
    if(model.zoneLoc || [model.zoneLoc isEmptyString])
        zoneLocLabel.text = @"--";
    else
        zoneLocLabel.text = model.zoneLoc;
    
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
    
    if(warningString) {
        [MBProgressHUD showText:warningString inView:[UIView gt_keyWindow]];
        return;
    }
    
    BOOL isOn = btn.isOn;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_model, @"model", @(isOn), @"isOn", nil];
    
    if(_delegate && [_delegate respondsToSelector:@selector(switchButtonWithDic:)]) {
        [_delegate performSelector:@selector(switchButtonWithDic:) withObject:dic];
    }
}

- (void)clickEdit:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(clickEditWithModel:)]) {
        [_delegate performSelector:@selector(clickEditWithModel:) withObject:_model];
    }
}

@end
