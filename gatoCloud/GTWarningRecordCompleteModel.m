//
//  GTWarningRecordCompleteModel.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/21.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTWarningRecordCompleteModel.h"

@implementation GTWarningRecordCompleteModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"numPerPage":@"numPerPage",
             @"currentPage":@"currentPage",
             @"totalPages":@"totalPages",
             @"resultList":@"resultList",
             };
}


+ (NSValueTransformer *)resultListJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSMutableArray arrayWithArray:[MTLJSONAdapter modelsOfClass:[GTWarningRecordModel class] fromJSONArray:value error:nil]];
    }];
}

+ (NSDictionary *)warningTypeDict
{
    return @{@"dev": @"设备故障报警", @"net": @"通讯异常", @"fence": @"入侵报警", @"fire": @"火警"};
}

- (BOOL)hasMore
{
    if(self.currentPage.integerValue < self.totalPages.integerValue)
        return YES;
    return NO;
}

@end
