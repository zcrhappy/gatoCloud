//
//  GTUserUtils.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/11.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTUserUtils.h"
#import "TMCache.h"

NSString *kUserInfoKey = @"kUserInfoKey";
NSString *kBannerKey = @"kBannerKey";
NSString *kRegIdKey = @"kRegIdKey";

@interface GTUserUtils()
@property (nonatomic, assign) BOOL isLogin;
@end

@implementation GTUserUtils

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static GTUserUtils *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GTUserUtils alloc] init];
        sharedInstance.userModel = [[TMCache sharedCache] objectForKey:kUserInfoKey];

        if(sharedInstance.userModel == nil || [sharedInstance.userModel isEqual:[NSNull null]])
            sharedInstance.isLogin = NO;
        else
            sharedInstance.isLogin = YES;
    });
    return sharedInstance;
}

//保存信息前重置
+ (void)refreshUserInfo;
{
     [GTUserUtils sharedInstance].userModel = [[GTUserModel alloc] init];
}
//保存通过微信登录信息
+ (void)saveUserInfoViaWX:(NSDictionary *)dic;
{
    [GTUserUtils refreshUserInfo];
    
    if(dic) {
        GTUserModel *userModel = [MTLJSONAdapter modelOfClass:[GTUserModel class] fromJSONDictionary:dic error:nil];
        [GTUserUtils sharedInstance].userModel = userModel;//内存
        [GTUserUtils loginSuccess];
    }
}
//保存通过手机注册返回的信息
+ (void)saveUserInfoViaPhoneRegister:(NSDictionary *)dic;
{
    [GTUserUtils refreshUserInfo];
    
    NSString *token = [dic objectForKey:@"token"];
    NSString *userId = [dic objectForKey:@"userId"];
    
    if(token != nil && userId != nil) {
        [GTUserUtils saveToken:token userId:userId];
        [GTUserUtils loginSuccess];
    }
}
//保存通过手机登录返回的信息
+ (void)saveUserInfoViaPhoneLogin:(NSDictionary *)dic
{
    [GTUserUtils refreshUserInfo];
    
    NSString *token = [dic objectForKey:@"token"];
    NSString *userId = [dic objectForKey:@"userId"];
    
    if(token != nil && userId != nil) {
        [GTUserUtils saveToken:token userId:userId];
        [GTUserUtils loginSuccess];
    }
}

+ (void)saveToken:(NSString *)token userId:(NSString *)userId;
{
    if(![GTUserUtils sharedInstance].userModel)
        [GTUserUtils sharedInstance].userModel = [[GTUserModel alloc] init];
    
    if(token) {
        [GTUserUtils sharedInstance].userModel.token = token;//内存
    }
    if(userId) {
        [GTUserUtils sharedInstance].userModel.userId = userId;//内存
    }
}

+ (void)unRegisterUserInfo;
{
    [GTUserUtils sharedInstance].isLogin = NO;
    [GTUserUtils sharedInstance].userModel = [[GTUserModel alloc] init];//清内存数据
    [[TMCache sharedCache] removeObjectForKey:kUserInfoKey];//数据库
}

+ (void)saveBanners:(NSArray *)banners
{
    [[TMCache sharedCache] setObject:banners forKey:kBannerKey];
}

#pragma mark -getter
+ (NSArray *)banners
{
    return [[TMCache sharedCache] objectForKey:kBannerKey];
}

+ (BOOL)isLogin
{
    return [GTUserUtils sharedInstance].isLogin;
}

+ (void)loginSuccess;
{
    NSLog(@"loginSuccess");
    [GTUserUtils sharedInstance].isLogin = YES;
    [[TMCache sharedCache] setObject:[GTUserUtils sharedInstance].userModel forKey:kUserInfoKey];//数据库
}

//推送相关
+ (void)saveRegId:(NSString *)regId
{
    if(regId)
        [[NSUserDefaults standardUserDefaults] setObject:regId forKey:kRegIdKey];
}

+ (NSString *)regId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kRegIdKey];
}

@end
