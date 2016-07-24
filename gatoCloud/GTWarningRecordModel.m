//
//  GTWarningRecordModel.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/20.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTWarningRecordModel.h"

@implementation GTWarningRecordModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"WARNINGID":@"WARNINGID",
             @"ZONENO":@"ZONENO",
             @"WARNDATE":@"WARNDATE",
             @"ISTATE":@"ISTATE",
             @"HANDLER":@"HANDLER",
             @"HANDLEDATE":@"HANDLEDATE",
             @"memo":@"memo",
             @"WARNTYPE":@"WARNTYPE",
             @"zonename":@"zonename",
             @"zonecontactor":@"zonecontactor",
             @"zonephone":@"zonephone",
             @"zoneLoc":@"zoneLoc",
             @"devicename":@"devicename"
             };
}

@end
