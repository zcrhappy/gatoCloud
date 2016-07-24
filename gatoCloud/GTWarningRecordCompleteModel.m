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
             @"resultList":@"resultList",
             };
}


+ (NSValueTransformer *)resultListJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelsOfClass:[GTWarningRecordModel class] fromJSONArray:value error:nil];
    }];
}

+ (NSDictionary *)warningTypeDict
{
    return @{@"dev": @"主机报警", @"net": @"通讯报警", @"fence": @"入侵报警"};
}

@end
