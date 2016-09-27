//
//  GTDeviceZoneModel.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/27.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTDeviceZoneModel.h"

@implementation GTDeviceZoneModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[NSDictionary mtl_identityPropertyMapWithModel:self]];
    
    [dic setObject:@"operator" forKey:@"operatorName"];
    
    return dic;
}

- (NSString *)zoneTypeStringWithSuffix:(BOOL)needsSuffix;
{
    NSArray *typeArray = @[@"未知", @"脉冲电子围栏", @"触网脉冲电子围栏", @"张力围栏", @"泄露电缆", @"振动光纤", @"地址码"];
    
    NSString *retStr;
    
    if(self.zoneType.integerValue < typeArray.count) {
        retStr = typeArray[self.zoneType.integerValue];
    }
    else {
        retStr = @"未知";
    }
    
    if(needsSuffix && self.zoneType.integerValue < 3) {
        NSString *highVmp = [[self.zoneVmp componentsSeparatedByString:@","] firstObject];
        NSString *lowVmp = [[self.zoneVmp componentsSeparatedByString:@","] lastObject];
        
        NSString *vmp = [NSString stringWithFormat:@"(+%@kv ~ -%@kv)", highVmp, lowVmp];

        retStr = [retStr stringByAppendingString:vmp];
    }
    
    return retStr;
}

- (NSString *)zoneStateString;
{
    if(![self zoneOnlineBoolValue])
        return @"离线";
    
    NSArray *stateArray = @[@"未知", @"撤防中", @"布防中", @"撤防", @"布防"];
    NSInteger index;
    
    
    if(self.zoneState == nil || [self.zoneState isEmptyString])
        index = 0;
    else {
        index = self.zoneState.integerValue;
    }
    
    return stateArray[index];
}

- (BOOL)isTwentyFourHourZone;
{
#ifdef kGlobalTest
    return NO;
#endif
    
    if(self.zoneStyle.integerValue <= 3 && self.zoneStyle.integerValue > 0)
        return YES;
    else
        return NO;
}

- (NSString *)twentyFourHourZoneStateString
{
    if([self.zoneState isEqualToString:@"4"]) {
        return @"布防";
    }
    else
        return @"故障";
}

- (BOOL)zoneStateForSwithButton;
{
    if(![self zoneOnlineBoolValue])
        return NO;
    
    NSInteger index = self.zoneState.integerValue;;
    
    if(index == 4)
        return YES;
    else
        return NO;
}

- (BOOL)zoneOnlineBoolValue
{
    if([self.zoneOnline isEqualToString:@"1"])
        return YES;
    else
        return NO;
}


+ (NSArray <GTDeviceZoneModel *>*)transformFromArray:(NSArray <GTDeviceZoneModel2 *>*)oldArr
{
    NSMutableArray *newArr = [NSMutableArray array];
    
    for(GTDeviceZoneModel2 *oldModel in oldArr) {
        GTDeviceZoneModel *newModel = [[GTDeviceZoneModel alloc] init];
        [newModel mergeValuesForKeysFromModel:oldModel];
        newModel.deviceName = oldModel.devicename;
        newModel.zoneOnline = oldModel.ZONEONLINE;
        newModel.deviceNo = oldModel.DEVICENO;
        newModel.zoneStrainVpt = oldModel.ZONESTRAINVPT;
        newModel.zoneType = oldModel.ZONETYPE;
        newModel.zoneVmp = oldModel.ZONEVMP;
        newModel.zoneStrain = oldModel.ZONESTRAIN;
        newModel.userType = oldModel.useType.stringValue;
        
        [newArr addObject:newModel];
    }
    return newArr;
}

- (BOOL)canBatchDefendZone;//能够批量布防撤防
{
    if(self.zoneStyle.integerValue > 3)
        return YES;
    else
        return NO;    
}

- (BOOL)canEdit;//管理员才可编辑
{
    if([self.userType isEqualToString:@"0"])
        return YES;
    else
        return NO;
}

//补充第一行和第一列为空
- (NSArray <NSArray *>*)fetchStainArray
{
    NSMutableArray *allDataArray = [NSMutableArray array];
    
    NSString *originStain = self.zoneStrain;
    NSArray *allRowArray = [originStain componentsSeparatedByString:@";"];
    [allRowArray enumerateObjectsUsingBlock:^(NSString *oneRowString, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *oneRowArray = [oneRowString componentsSeparatedByString:@","];
        NSMutableArray *mutbleOneRowArray = [NSMutableArray arrayWithObject:@"placeholder"];
        [mutbleOneRowArray addObjectsFromArray:oneRowArray];
        [allDataArray addObject:mutbleOneRowArray];
    }];
    
    [allDataArray insertObject:[NSArray array] atIndex:0];
    
    return allDataArray;
}

- (NSString *)getNetPulseValue:(GTNetPulseValue)type;
{
    NSArray *valueArray = [self.zoneParam componentsSeparatedByString:@","];//后台返回的均从1开始，
    if(type >= valueArray.count || valueArray == nil)
        return kDefaultString;
    NSString *value = valueArray[type];
    if([value isEmptyString])
        return kDefaultString;
    NSArray *levelArray;
    switch (type) {
        case GTNetPulseValueVoltage:{
            levelArray = [GTDeviceZoneModel netPulseZoneVoltageArray];
            
            if(value.integerValue > levelArray.count)
                return kDefaultString;//防止数组越界
            
            NSString *level = levelArray[value.integerValue];
            return level;
        }
        case GTNetPulseValueSensitive:
        {
            levelArray = [GTDeviceZoneModel netPulseZoneSensitiveArray];
            if(value.integerValue > levelArray.count)
                return kDefaultString;
            
            NSString *level = levelArray[value.integerValue];
            return level;
        }
        case GTNetPulseValueMode:
        {
            NSArray *modeArray = [GTDeviceZoneModel netPulseZoneModeArray];
            if(value.integerValue > modeArray.count)
                return kDefaultString;
            NSString *mode = modeArray[value.integerValue];
            return mode;
        }
    }
    return kDefaultString;
}

- (BOOL)shouldSetLoadingState;
{
    if(_loopCount != 0)
        return YES;
    else
        return NO;
}

#pragma mark - Constant

+ (GTZoneType)zoneTypeOfStringType:(NSString *)type
{
    if([type isEqualToString:@"脉冲"])
        return GTZoneTypePulse;
    else if ([type isEqualToString:@"脉冲&触网"])
        return GTZoneTypeNetPulse;
    else if ([type isEqualToString:@"触网"])
        return GTZoneTypeNet;
    else
        return 0;
}

+ (NSArray *)netPulseZoneModeArray {
    return @[@"", @"脉冲", @"触网", @"脉冲&触网"];
}

+ (NSArray *)netPulseZoneVoltageArray {
    return @[@"", @"一级", @"二级", @"三级", @"四级"];
}

+ (NSArray *)netPulseZoneSensitiveArray {
    return @[@"", @"一级", @"二级"];
}
#pragma mark - zone type
- (BOOL)isZoneType:(GTZoneType)zonetype;
{
    if(self.zoneType.integerValue == zonetype)
        return YES;
    else
        return NO;
}
@end
