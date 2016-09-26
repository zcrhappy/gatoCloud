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
#import "GTElectricZoneInfoView.h"
#import "GTZoneInfoView.h"
//#import "GTZoneCellTimer.h"
#define bottomBackgroundColor [UIColor colorWithString:@"f5f5f5"]
@interface GTDeviceZoneCell()
//@property (strong, nonatomic) GTZoneCellTimer *timerObj;
@property (strong, nonatomic) GTUpContainer *upContainer;
@property (strong, nonatomic) GTLine *horSerparatorLine;
@property (strong, nonatomic) GTBottomContainer *bottomContainer;
@property (nonatomic, strong) MASConstraint *expandConstaint;
@property (nonatomic, strong) MASConstraint *unExpandConstraint;

//up
@property (nonatomic, strong) UILabel *zoneNameLabel;
@property (nonatomic, strong) UILabel *zoneTypeLabel;
@property (nonatomic, strong) UILabel *zoneStateLabel;
@property (nonatomic, strong) UISwitch *guardSwitch;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

//bottom
@property (nonatomic, strong) GTElectricZoneInfoView *netPulseView;
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

- (void)dealloc
{

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
    upContainer = [[GTUpContainer alloc] initWithFrame:CGRectZero];
    //macroCreateView(CGRectZero, [UIColor whiteColor]);
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
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.hidden = YES;
    [upContainer addSubview:_indicator];
    [_indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(zoneNameLabel);
        make.right.equalTo(upContainer).offset(-30);
    }];
    
    horSerparatorLine = [[GTLine alloc] initWithFrame:CGRectZero];
    horSerparatorLine.backgroundColor = [UIColor colorWithString:@"e0e0e0"];
//    macroCreateView(CGRectZero, [UIColor colorWithString:@"e0e0e0"]);
    [self.contentView addSubview:horSerparatorLine];
    [horSerparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upContainer.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@(SINGLE_LINE_WIDTH));
    }];
    
    bottomContainer = [[GTBottomContainer alloc] initWithFrame:CGRectZero];
    bottomContainer.backgroundColor = bottomBackgroundColor;
    //macroCreateView(CGRectZero, bottomBackgroundColor);
    [self.contentView addSubview:bottomContainer];
    
    _stainView = [[NSBundle mainBundle] loadNibNamed:@"GTZoneStrainView" owner:self options:Nil][0];
    [bottomContainer addSubview:_stainView];
    [_stainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(_stainView.viewHeight));
    }];
    __weak __typeof(self)weakSelf = self;
    [_stainView setClickStainEditBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf clickStainEdit];
    }];
    
    _netPulseView = [[NSBundle mainBundle] loadNibNamed:@"GTElectricZoneInfoView" owner:self options:nil][0];
    [bottomContainer addSubview:_netPulseView];
    [_netPulseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        //高度在得到model的时候update
    }];
    [_netPulseView setClickEditBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf clickNetPulseEdit];
    }];
    
    _infoView = [[NSBundle mainBundle] loadNibNamed:@"GTZoneInfoView" owner:self options:nil][0];
    [bottomContainer addSubview:_infoView];
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        //top在得到model的时候update
        make.left.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    [_infoView setClickEditBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf clickEdit];
    }];
    
    UIView *lastView = _infoView;
    //用来计算下半部分的高度
    GTPlaceholderView *placeholderView = [[GTPlaceholderView alloc] initWithFrame:CGRectZero];
    [bottomContainer addSubview:placeholderView];
    [placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(lastView.mas_bottom).priorityHigh();
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
    
    [bottomContainer setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}


- (void)updateWithModel:(GTDeviceZoneModel *)model
{
    _model = model;
    zoneNameLabel.text = model.zoneName;
    zoneStateLabel.text = model.zoneStateString;
    guardSwitch.on = model.zoneStateForSwithButton;
    zoneTypeLabel.text = [NSString stringWithFormat:@"防区类型:%@",[model zoneTypeStringWithSuffix:YES]];
    
    if(model.shouldSetLoadingState) {
        [self setLoadingState:YES];
    }
    else {
        [self setLoadingState:NO];
    }
    
    [_infoView setupWithModel:model];
    
    [self updateLayoutWithModel:model];
    
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


- (void)updateLayoutWithModel:(GTDeviceZoneModel *)model
{
    if([model isZoneType:GTZoneTypeStrain]) {
        [_netPulseView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [_stainView setupWithModel:model];
        [_stainView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_stainView.viewHeight);
        }];
        [_infoView setShouldConstraintToTop:^BOOL{
            return YES;
        }];
        [_infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_stainView.mas_bottom);
            make.left.equalTo(@0);
            make.width.equalTo(@(SCREEN_WIDTH));
            make.height.mas_equalTo(_infoView.viewHeight);
        }];
    }
    else if ([model isZoneType:GTZoneTypeNetPulse] || [model isZoneType:GTZoneTypePulse]) {
        [_stainView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [_netPulseView setupWithModel:model];
        [_netPulseView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_netPulseView.viewHeight);
        }];
        [_infoView setShouldConstraintToTop:^BOOL{
            return YES;
        }];
        [_infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_netPulseView.mas_bottom);
            make.left.equalTo(@0);
            make.width.equalTo(@(SCREEN_WIDTH));
            make.height.mas_equalTo(_infoView.viewHeight);
        }];
    }
    else
    {
        [_stainView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [_netPulseView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [_infoView setShouldConstraintToTop:^BOOL{
            return NO;
        }];
        [_infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(_infoView.viewHeight);
        }];
    }
    

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
        
        if([_model isZoneType:GTZoneTypeStrain]) {
            _netPulseView.hidden = YES;
            _stainView.hidden = NO;
        }
        else if ([_model isZoneType:GTZoneTypeNetPulse] || [_model isZoneType:GTZoneTypePulse]) {
            _netPulseView.hidden = NO;
            _stainView.hidden = YES;
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
    BOOL isOn = btn.isOn;
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

    _model.isOn = isOn;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_model, @"model",nil];
    
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

- (void)clickStainEdit
{
    if(_delegate && [_delegate respondsToSelector:@selector(clickStainEditWithModel:)]) {
        [_delegate performSelector:@selector(clickStainEditWithModel:) withObject:_model];
    }
}

- (void)clickNetPulseEdit
{
    if(_delegate && [_delegate respondsToSelector:@selector(clickNetPulseEditWithModel:)]) {
        [_delegate performSelector:@selector(clickNetPulseEditWithModel:) withObject:_model];
    }
}

- (void)setLoadingState:(BOOL)setOn
{
    if(setOn) {
        [_indicator startAnimating];
        _indicator.hidden = NO;
        
        [guardSwitch mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(upContainer).offset(51);//移除屏幕。。
        }];

        zoneStateLabel.hidden = YES;
    }
    else {
        _indicator.hidden = YES;
        [_indicator endEditing:NO];

        [guardSwitch mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(upContainer).offset(-18);
        }];
        zoneStateLabel.hidden = NO;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end

@implementation GTPlaceholderView
@end
@implementation GTLine
@end
@implementation GTUpContainer
@end
@implementation GTBottomContainer
@end
