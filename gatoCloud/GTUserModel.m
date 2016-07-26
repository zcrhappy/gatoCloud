//
//  GTUserModel.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/11.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTUserModel.h"

@implementation GTUserModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:self];
}

@end
