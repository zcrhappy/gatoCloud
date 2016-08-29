//
//  GTUserUtils.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/11.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTUserModel.h"

@interface GTUserUtils : NSObject



+ (GTUserModel *)userInfo;
+ (NSArray *)banners;

+ (NSString *)userHeadImgURLString;
+ (void)saveHeadImgURLString:(NSString *)urlStr;

//登录相关
+ (BOOL)isLogin;
+ (void)loginSuccess;
+ (void)unRegisterUserInfo;//注销当前用户的信息。

//保存通过微信登录信息
+ (void)saveUserInfoViaWX:(NSDictionary *)dic;
+ (void)saveTokenViaWX:(NSString *)token;
+ (void)saveUserIdViaWX:(NSString *)userId;
//保存通过手机注册返回的信息
+ (void)saveUserInfoViaRegister:(NSDictionary *)dic;

+ (void)saveBanners:(NSArray *)banners;

//推送相关
+ (void)saveRegId:(NSString *)regId;
+ (NSString *)regId;
//+ (void)setNotDisturbStatus:(NSInteger)status;//免打扰0开启，1只在夜间开启，2关闭
//+ (NSNumber *)notDisturbStatus;//免打扰0开启，1只在夜间开启，2关闭

//视图相关工具类
+ (UIViewController *)appTopViewController;
+ (BOOL)isViewControllerPresent;
@end
