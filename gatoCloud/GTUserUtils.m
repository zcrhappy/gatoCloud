//
//  GTUserUtils.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/11.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTUserUtils.h"
#import "TMCache.h"

static NSString *kUserInfoKey = @"kUserInfoKey";

@interface GTUserUtils()

@property (nonatomic, strong) GTUserModel *userModel;

@end

@implementation GTUserUtils

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static GTUserUtils *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GTUserUtils alloc] init];
    });
    return sharedInstance;
}

+ (void)saveUserInfo:(NSDictionary *)dic;
{
    GTUserModel *userModel = [MTLJSONAdapter modelOfClass:[GTUserModel class] fromJSONDictionary:dic error:nil];
    
    [[TMCache sharedCache] setObject:userModel forKey:kUserInfoKey];
}

/*!
 *  @brief 先从内存取，没有的话从缓存，再没有返回nil
 */
+ (GTUserModel *)userInfo;
{
    if([GTUserUtils sharedInstance].userModel) {
        return [GTUserUtils sharedInstance].userModel;
    }
    else if([[TMCache sharedCache] objectForKey:kUserInfoKey]) {
        [GTUserUtils sharedInstance].userModel = [[TMCache sharedCache] objectForKey:kUserInfoKey];
        return [GTUserUtils sharedInstance].userModel;
    }
    else
        return nil;
}

+ (void)saveToken:(NSString *)token
{
    [GTUserUtils sharedInstance].userModel.token = token;
    [[TMCache sharedCache] setObject:[GTUserUtils sharedInstance].userModel forKey:kUserInfoKey];
}

+ (void)saveUserId:(NSString *)userId
{
    [GTUserUtils sharedInstance].userModel.userId = userId;
    [[TMCache sharedCache] setObject:[GTUserUtils sharedInstance].userModel forKey:kUserInfoKey];
}

@end
