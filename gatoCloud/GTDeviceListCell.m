//
//  GTDeviceListCell.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/13.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTDeviceListCell.h"
#import "GTDeviceFuntionItem.h"
#import "GTDeviceModel.h"
@interface GTDeviceListCell()<GTDeviceFunctionItemDelegate>
@property (strong, nonatomic) UIView *upContainer;
@property (strong, nonatomic) UILabel *zoneLocationLabel;
@property (strong, nonatomic) UILabel *zoneNumberLabel;
@property (strong, nonatomic) UIButton *stateButton;
@property (strong, nonatomic) UIView *horSerparatorLine;

@property (strong, nonatomic) UIView *bottomContainer;

@property (nonatomic, strong) MASConstraint *expandConstaint;
@property (nonatomic, strong) MASConstraint *unExpandConstaint;

@property (nonatomic, strong) GTDeviceModel *model;
@end
@implementation GTDeviceListCell
@synthesize upContainer,zoneLocationLabel,zoneNumberLabel,stateButton,horSerparatorLine,bottomContainer,expandConstaint,unExpandConstaint;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configUI];
    
}


- (void)configUI
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    upContainer = macroCreateView(CGRectZero, [UIColor whiteColor]);
    [self.contentView addSubview:upContainer];
    [upContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@60);
    }];
    
    zoneLocationLabel = macroCreateLabel(CGRectZero, [UIColor whiteColor], 18, [UIColor colorWithString:@"212121"]);
    [upContainer addSubview:zoneLocationLabel];
    [zoneLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(upContainer.mas_centerY);
        make.left.equalTo(@18);
    }];
    
    zoneNumberLabel = macroCreateLabel(CGRectZero, [UIColor whiteColor], 15, [UIColor colorWithString:@"212121"]);
    [upContainer addSubview:zoneNumberLabel];
    [zoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(zoneLocationLabel.mas_centerY);
        make.left.equalTo(zoneLocationLabel.mas_right).offset(15);
    }];
    
    stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stateButton.userInteractionEnabled = NO;
    stateButton.layer.borderWidth = SINGLE_LINE_WIDTH;
    stateButton.layer.cornerRadius = 4;
    stateButton.layer.masksToBounds = YES;
    stateButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [upContainer addSubview:stateButton];
    [stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(upContainer.mas_centerY);
        make.right.equalTo(upContainer).offset(-23);
        make.width.equalTo(@40);
        make.height.equalTo(@20);
    }];
    
    horSerparatorLine = macroCreateView(CGRectZero, [UIColor colorWithString:@"e0e0e0"]);
    [self.contentView addSubview:horSerparatorLine];
    [horSerparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upContainer.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@(SINGLE_LINE_WIDTH));
    }];
    
    //----------------
    
    bottomContainer = macroCreateView(CGRectZero, [UIColor colorWithString:@"f5f5f5"]);
    [self.contentView addSubview:bottomContainer];
    
    NSArray *funcArray= [NSArray arrayWithObjects:@"布防",@"撤防",@"消警",@"防区列表", nil];
    
    NSDictionary *iconDic = @{@"布防":@"GTFuncItemIconProtect",
                          @"撤防":@"GTFuncItemIconUnProtect",
                          @"消警":@"GTFuncItemIconDisableAlarm",
                          @"防区列表":@"GTFuncItemIconZoneList"};
    

    __block UIView *lastView = nil;
    
    CGFloat itemWidth = (SCREEN_WIDTH - 15*(funcArray.count+1))/(CGFloat)(funcArray.count);
    
    [funcArray enumerateObjectsUsingBlock:^(id  _Nonnull functionName, NSUInteger idx, BOOL * _Nonnull stop) {
       
        GTDeviceFuntionItem *curItem = [[GTDeviceFuntionItem alloc] init];
        curItem.delegate = self;
        curItem.tag = idx;
        NSString *iconName = [iconDic objectForKey:functionName];
        
        [curItem setupFuncionItemWithName:functionName iconName:iconName];
        [bottomContainer addSubview:curItem];
        
        [curItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastView ? lastView.mas_right : bottomContainer.mas_left).offset(15);
            make.centerY.equalTo(bottomContainer.mas_centerY);
            make.height.equalTo(curItem.mas_width);
            make.width.equalTo(@(itemWidth));
            
            if(idx == funcArray.count - 1)
                make.right.equalTo(bottomContainer.mas_right).offset(-15);
        }];
        
        lastView = curItem; 
    }];
    
    
    [bottomContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(horSerparatorLine.mas_bottom);
        make.width.equalTo(self.contentView);
        expandConstaint = make.height.equalTo(lastView.mas_height).offset(14);
        unExpandConstaint = make.height.equalTo(@0);
        make.bottom.equalTo(self.contentView.mas_bottom);
        [self expand:NO];
    }];
    
}

- (void)expand:(BOOL)isExpand
{
    if(isExpand) {
        [unExpandConstaint uninstall];
        [expandConstaint install];
        for(UIView *view in bottomContainer.subviews) {
            view.hidden = NO;
        }
    }
    else {
        [unExpandConstaint install];
        [expandConstaint uninstall];
        for(UIView *view in bottomContainer.subviews) {
            view.hidden = YES;
        }
    }
}

- (void)setupWithModel:(GTDeviceModel *)model;
{
    _model = model;
    NSString *zoneName = model.deviceName;
    NSNumber *zoneCount = model.zoneCount;
    NSString *state = model.screenOnlineState;
    NSString *online = model.online;
    
    [self configZoneName:zoneName zoneCount:zoneCount state:state online:online];
    [self setupWithExpanded:model.expanded];
}

- (void)setupWithExpanded:(BOOL)expanded;
{
    [self expand:expanded];
}

- (void)configZoneName:(NSString *)zoneName zoneCount:(NSNumber *)zoneCount state:(NSString *)state online:(NSString *)online
{
    zoneLocationLabel.text = zoneName;
    zoneNumberLabel.text = [NSString stringWithFormat:@"(共%@个防区)",zoneCount];
    [stateButton setTitle:state forState:UIControlStateNormal];
    
    if([online isEqualToString:@"1"]) {
        [stateButton setTitleColor:[UIColor colorWithString:@"20bf4d"] forState:UIControlStateNormal];
        stateButton.layer.borderColor = [UIColor colorWithString:@"20bf4d"].CGColor;
        
        zoneLocationLabel.textColor = [UIColor colorWithString:@"212121"];
        zoneNumberLabel.textColor = [UIColor colorWithString:@"212121"];
    }
    else {
        //全部置灰
        [stateButton setTitleColor:[UIColor colorWithString:@"b9bdc0"] forState:UIControlStateNormal];
        stateButton.layer.borderColor = [UIColor colorWithString:@"b9bdc0"].CGColor;
        
        zoneLocationLabel.textColor = [UIColor colorWithString:@"b9bdc0"];
        zoneNumberLabel.textColor = [UIColor colorWithString:@"b9bdc0"];
    }
}

#pragma mark - Item delegate


- (void)clickFunctionItemAtIndex:(NSNumber *)index
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:index,@"index", _model, @"model", nil];
    
    if(_delegate && [_delegate respondsToSelector:@selector(didSelectFunctionItemWithDic:)]) {
        [_delegate performSelector:@selector(didSelectFunctionItemWithDic:) withObject:dic];
    }
}
























@end
