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

@interface GTUserUtils()

@property (nonatomic, strong) GTUserModel *userModel;
@property (nonatomic, assign) BOOL isLogin;
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

#pragma mark - InfoViaWeChat
+ (void)saveUserInfoViaWX:(NSDictionary *)dic;
{
    [GTUserUtils saveUserInfo:dic];
}
+ (void)saveTokenViaWX:(NSString *)token;
{
    [GTUserUtils saveToken:token];
}
+ (void)saveUserIdViaWX:(NSString *)userId;
{
    [GTUserUtils saveUserId:userId];
}
#pragma mark - Save Info

+ (void)saveUserInfo:(NSDictionary *)dic;
{
    if(dic) {
        GTUserModel *userModel = [MTLJSONAdapter modelOfClass:[GTUserModel class] fromJSONDictionary:dic error:nil];
        [[TMCache sharedCache] setObject:userModel forKey:kUserInfoKey];
    }
    else {
        [GTUserUtils sharedInstance].userModel = nil;//清内存数据
        [[TMCache sharedCache] removeObjectForKey:kUserInfoKey];//清本地数据
    }

}

+ (void)saveToken:(NSString *)token
{
    if(token) {
        [GTUserUtils sharedInstance].userModel.token = token;
        [[TMCache sharedCache] setObject:[GTUserUtils sharedInstance].userModel forKey:kUserInfoKey];
    }
    else {
        [[TMCache sharedCache] removeObjectForKey:kUserInfoKey];//清本地数据
    }
}

+ (void)saveUserId:(NSString *)userId
{
    if(userId) {
        [GTUserUtils sharedInstance].userModel.userId = userId;
        [[TMCache sharedCache] setObject:[GTUserUtils sharedInstance].userModel forKey:kUserInfoKey];
    }
    else {
        [[TMCache sharedCache] removeObjectForKey:kUserInfoKey];
    }
}

+ (void)unRegisterUserInfo;
{
    [GTUserUtils sharedInstance].isLogin = NO;
    [GTUserUtils saveUserInfo:nil];
    [GTUserUtils saveToken:nil];
    [GTUserUtils saveUserId:nil];
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



+ (void)saveBanners:(NSArray *)banners
{
    [[TMCache sharedCache] setObject:banners forKey:kBannerKey];
}

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
    [GTUserUtils sharedInstance].isLogin = YES;
}
#pragma mark - other
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)appTopViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

@end
