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

+ (UIViewController *)appTopViewController;
@end
