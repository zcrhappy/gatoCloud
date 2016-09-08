//
//  GTDeviceModel.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/13.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTDeviceModel.h"

@implementation GTDeviceModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:self];
}

- (NSString *)screenOnlineState
{
    if([self.onlineState isEqualToString:@"上线"]) {
        return @"在线";
    }
    else if ([self.onlineState isEqualToString:@"下线"]) {
        return @"离线";
    }
    else
        return self.onlineState;
}

- (BOOL)isOnline
{
    if([self.onlineState isEqualToString:@"上线"]) {
        return YES;
    }
    else
        return NO;
}
@end
