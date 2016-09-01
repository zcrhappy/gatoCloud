//
//  GTUserModel.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/11.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTUserModel.h"

@interface GTUserModel()
{
    NSString *avatarUrlString;
}

@end

@implementation GTUserModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:self];
}

- (void)setAvatarUrlString:(NSString *)newAvatarUrlString completion:(void (^)(void))completion
{
    [[SDImageCache sharedImageCache] removeImageForKey:newAvatarUrlString fromDisk:YES withCompletion:^{
        avatarUrlString = newAvatarUrlString;
        completion();
    }];
}

- (NSString *)avatarUrlString
{
    return avatarUrlString ?: @"";
}

@end
