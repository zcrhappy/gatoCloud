//
//  GTDeviceZoneModel.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/27.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "GTDeviceZoneModel2.h"

typedef NS_ENUM(NSInteger, kZoneState)
{
    kZoneStateUnderDisguarding = 1,
    kZoneStateUnderGuarding = 2,
    kZoneStateDisguarded = 3,
    kZoneStateGuarded = 4
};


@interface GTDeviceZoneModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *zoneOnline;//防区是否在线 0 为 离线 1为在线
@property (nonatomic, copy) NSString *zoneState;//为防区状态， 3 撤防 4 布防 1 撤防中 2 布防中
@property (nonatomic, copy) NSString *zoneName;//防区名称
@property (nonatomic, copy) NSString *zoneContactor;
@property (nonatomic, copy) NSString *zonePhone;
@property (nonatomic, copy) NSString *zoneLoc;
@property (nonatomic, copy) NSString *zoneDesc;
@property (nonatomic, strong) NSNumber *addDate;//
@property (nonatomic, copy) NSString *zoneNo;//防区编号 唯一
@property (nonatomic, copy) NSString *deviceNo;
@property (nonatomic, copy) NSString *zoneStrainVpt;
@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, copy) NSString *operatorName;//
@property (nonatomic, copy) NSString *zoneType;// 1 脉冲电子围栏 2 触网脉冲电子围栏 3 张力围栏 4 泄露电缆 5振动光纤 6地址码
@property (nonatomic, copy) NSString *zoneVmp;//电压值 ‘,’ 拼接， 前端处理 按, 拆分，后面为负数 前面为正 如 +8kv ~ -8kv
@property (nonatomic, copy) NSString *zoneStrain;
@property (nonatomic, copy) NSString *ipAddr;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *xmAppId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *zoneStyle;//1：屏蔽防区  2：24小时有声防区 3：24小时无声防区 4：即时防区  5：布撤防防区  6：延时//防区  7：传递延时防区 (若不传或则为空则以即时防区处理)


@property (nonatomic, assign) BOOL isExpand;

- (NSString *)zoneTypeStringWithSuffix:(BOOL)needsSuffix;
- (NSString *)zoneStateString;
//24小时防区状态
- (NSString *)twentyFourHourZoneStateString;
- (BOOL)zoneOnlineBoolValue;
- (BOOL)zoneStateForSwithButton;
- (BOOL)canZoneDealWithOneKey;//能够一键布防撤防

+ (NSArray <GTDeviceZoneModel *>*)transformFromArray:(NSArray <GTDeviceZoneModel2 *>*)array;

@end