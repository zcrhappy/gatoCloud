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
NSString *kPushStatus = @"kPushStatus";
//NSString *kImgBaseURL = @"http://115.159.44.248:8085/";

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
    });
    return sharedInstance;
}

#pragma mark - InfoViaWeChat
+ (void)saveUserInfoViaWX:(NSDictionary *)dic;
{
    if(dic) {
        GTUserModel *userModel = [MTLJSONAdapter modelOfClass:[GTUserModel class] fromJSONDictionary:dic error:nil];
        [GTUserUtils sharedInstance].userModel = userModel;//内存
        [[TMCache sharedCache] setObject:userModel forKey:kUserInfoKey];//数据库
        [GTUserUtils loginSuccess];
    }
}

//保存通过手机注册返回的信息
+ (void)saveUserInfoViaRegister:(NSDictionary *)dic;
{
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
    
    [[TMCache sharedCache] setObject:[GTUserUtils sharedInstance].userModel forKey:kUserInfoKey];//数据库
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

+ (BOOL)isViewControllerPresent
{
    UIViewController *topVC = [GTUserUtils appTopViewController];
    NSArray *viewcontrollers = topVC.navigationController.viewControllers;
    
    if (viewcontrollers.count > 1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式
            return NO;
        }
    }
    
    //present方式
    return YES;
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

+ (void)setNotDisturbStatus:(NSInteger)status
{
     [[NSUserDefaults standardUserDefaults] setObject:@(status) forKey:kPushStatus];
}

+ (NSNumber *)notDisturbStatus
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kPushStatus];
}

@end
