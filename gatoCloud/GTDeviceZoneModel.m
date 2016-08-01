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
    NSArray *stateArray = @[@"未知", @"撤防中", @"布防中", @"撤防", @"布防"];
    NSInteger index;
    
    
    if(self.zoneState == nil || [self.zoneState isEmptyString])
        index = 0;
    else {
        index = self.zoneState.integerValue;
    }
    
    return stateArray[index];
}

- (BOOL)zoneStateForSwithButton;
{
    NSInteger index = self.zoneState.integerValue;;
    
    if(index == 4)
        return YES;
    else
        return NO;
}

@end