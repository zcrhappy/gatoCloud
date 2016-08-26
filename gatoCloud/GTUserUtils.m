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

//保存通过手机注册返回的信息
+ (void)saveUserInfoViaRegister:(NSDictionary *)dic;
{
    [GTUserUtils sharedInstance].userModel = [[GTUserModel alloc] init];
    
    NSString *token = [dic objectForKey:@"token"];
    NSString *userId = [dic objectForKey:@"userId"];
    
    if(token != nil && userId != nil) {
        [GTUserUtils saveToken:token];
        [GTUserUtils saveUserId:userId];
        [[TMCache sharedCache] setObject:[GTUserUtils sharedInstance].userModel forKey:kUserInfoKey];
        [GTUserUtils loginSuccess];
    }
    
}


+ (void)saveTokenViaRegister:(NSString *)token;
{
    [GTUserUtils saveToken:token];
}
+ (void)saveUserIdViaRegister:(NSString *)userId;
{
    [GTUserUtils saveUserId:userId];
}
#pragma mark - Save Info

+ (void)saveUserInfo:(NSDictionary *)dic;
{
    if(dic) {
        GTUserModel *userModel = [MTLJSONAdapter modelOfClass:[GTUserModel class] fromJSONDictionary:dic error:nil];
        [GTUserUtils sharedInstance].userModel = userModel;
        [[TMCache sharedCache] setObject:userModel forKey:kUserInfoKey];
        [GTUserUtils loginSuccess];
    }
    else {
        [GTUserUtils sharedInstance].userModel = nil;//清内存数据
    }
}

+ (void)saveToken:(NSString *)token
{
    if(token) {
        [GTUserUtils sharedInstance].userModel.token = token;
        [[TMCache sharedCache] setObject:[GTUserUtils sharedInstance].userModel forKey:kUserInfoKey];
    }
}

+ (void)saveUserId:(NSString *)userId
{
    if(userId) {
        [GTUserUtils sharedInstance].userModel.userId = userId;
        [[TMCache sharedCache] setObject:[GTUserUtils sharedInstance].userModel forKey:kUserInfoKey];
    }
}

+ (void)unRegisterUserInfo;
{
    [GTUserUtils sharedInstance].isLogin = NO;
    [GTUserUtils saveUserInfo:nil];
    [[TMCache sharedCache] removeObjectForKey:kUserInfoKey];
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

+ (NSString *)userHeadImgURLString
{
    NSString *fileName = [GTUserUtils sharedInstance].userModel.customHeadImgUrlString;
    if(fileName == nil || [fileName isEmptyString])
        return @"";

    return fileName;
}
+ (void)saveHeadImgURLString:(NSString *)urlStr;
{
    //因为头像有缓存，但是一个用户的头像url是一样的，所以每次修改完头像，都需要清除缓存。
    [[SDImageCache sharedImageCache] removeImageForKey:urlStr fromDisk:YES];
    [GTUserUtils sharedInstance].userModel.customHeadImgUrlString = urlStr;
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
