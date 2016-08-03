//
//  GTDeviceZoneModel2.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/3.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTDeviceZoneModel2.h"

@implementation GTDeviceZoneModel2

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[NSDictionary mtl_identityPropertyMapWithModel:self]];
    
    [dic setObject:@"operator" forKey:@"operatorName"];
    
    return dic;
}

@end
