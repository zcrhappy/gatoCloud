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

@property (nonatomic, copy) NSString *avatarUrlString;
@property (nonatomic, strong) GTUserModel *userModel;

+ (instancetype)sharedInstance;

+ (NSArray *)banners;

//+ (NSString *)avatarURLString;
//+ (void)setAvatarURLString:(NSString *)urlStr;

//登录相关
+ (BOOL)isLogin;
+ (void)loginSuccess;
+ (void)unRegisterUserInfo;//注销当前用户的信息。


+ (void)saveToken:(NSString *)token userId:(NSString *)userId;


#pragma mark - 登录后调用
//保存通过微信登录信息
+ (void)saveUserInfoViaWX:(NSDictionary *)dic;
//保存通过手机注册返回的信息
+ (void)saveUserInfoViaPhoneRegister:(NSDictionary *)dic;
//保存通过手机登录返回的信息
+ (void)saveUserInfoViaPhoneLogin:(NSDictionary *)dic;

+ (void)saveBanners:(NSArray *)banners;

//推送相关
+ (void)saveRegId:(NSString *)regId;
+ (NSString *)regId;
@end
