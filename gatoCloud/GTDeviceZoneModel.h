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
    kZoneStateUnderDisguarding = 1,//撤防中
    kZoneStateUnderGuarding = 2,//布防中
    kZoneStateDisguarded = 3,//撤防
    kZoneStateGuarded = 4//布防
};

typedef NS_ENUM(NSInteger, GTZoneType)
{
    GTZoneTypePulse = 1,//脉冲
    GTZoneTypeNetPulse = 2,//触网脉冲
    GTZoneTypeStrain = 3,//张力围栏
    GTZoneTypeNet = -1,//触网
};

typedef NS_ENUM(NSInteger, GTNetPulseValue)
{
    GTNetPulseValueVoltage = 0,//电压
    GTNetPulseValueSensitive = 1,//灵敏度
    GTNetPulseValueMode = 2,//工作模式
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
@property (nonatomic, copy) NSString *userType;//0:管理员， 1:操作员
@property (nonatomic, copy) NSString *zoneParam;

@property (nonatomic, assign) BOOL isExpand;

@property (nonatomic, assign) NSInteger loopCount;//布防撤防用，循环次数
@property (nonatomic, assign) BOOL isOn;//布防撤防用，目标状态

- (NSString *)zoneTypeStringWithSuffix:(BOOL)needsSuffix;
- (NSString *)zoneStateString;

- (BOOL)isTwentyFourHourZone;//24小时防区状态
- (BOOL)isZoneType:(GTZoneType)zonetype;
- (NSString *)twentyFourHourZoneStateString;
- (BOOL)zoneOnlineBoolValue;
- (BOOL)zoneStateForSwithButton;
- (BOOL)canBatchDefendZone;//能够批量布防撤防
- (BOOL)canEdit;//管理员才可编辑
- (BOOL)shouldSetLoadingState;//

- (NSString *)getNetPulseValue:(GTNetPulseValue)type;


+ (NSArray <GTDeviceZoneModel *>*)transformFromArray:(NSArray <GTDeviceZoneModel2 *>*)array;
- (NSArray <NSArray *>*)fetchStainArray;//补充第一行和第一列为空

#pragma mark - Constant
+ (GTZoneType)zoneTypeOfStringType:(NSString *)type;//将类型名转换为GTZoneType
+ (NSArray *)netPulseZoneModeArray;//对应实际的数据结构
+ (NSArray *)netPulseZoneModeVisableArray;//这个是在编辑下可以展现出来的
+ (NSArray *)netPulseZoneVoltageArray;
+ (NSArray *)netPulseZoneSensitiveArray;

@end
