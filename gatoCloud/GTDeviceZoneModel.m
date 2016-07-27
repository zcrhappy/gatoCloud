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


@end
