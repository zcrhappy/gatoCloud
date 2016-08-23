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

- (NSString *)getIstateString;
{
    NSArray *arr = @[@"未处理",@"已处理",@"误报"];
    
    if(arr.count > self.ISTATE.integerValue)
        return [arr objectAtIndex:self.ISTATE.integerValue];
    else
        return @"未知";
}

- (NSString *)getDateStrWithFormat:(NSString *)format;
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [fmt dateFromString:self.WARNDATE];
    
    NSDateFormatter *customFormat = [[NSDateFormatter alloc] init];
    customFormat.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *customDateStr = [customFormat stringFromDate:date];
    return customDateStr;
}

- (NSString *)getWarningTypeStr
{
    NSDictionary *dic = @{@"dev":@"主机报警", @"net":@"通讯报警", @"fence":@"入侵报警"};
    if(self.WARNTYPE == nil)
        return @"报警类型";
    
    NSString *str = [dic objectForKey:self.WARNTYPE];
    if(str == nil)
        return @"报警类型";
    else
        return str;
}

@end
