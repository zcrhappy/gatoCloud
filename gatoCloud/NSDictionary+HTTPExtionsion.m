//
//  NSDictionary+HTTPExtionsion.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/11.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "NSDictionary+HTTPExtionsion.h"

@implementation NSDictionary (HTTPExtionsion)

- (BOOL)isVaildResponse
{
    NSString *code = [self objectForKey:@"code"];
    if([code isEqualToString:@"10000"])
        return YES;
    return NO;
}

- (BOOL)isNeedLogin
{
    NSString *code = [self objectForKey:@"code"];
    if([code isEqualToString:@"-6666"])
        return YES;
    return NO;
}

@end
