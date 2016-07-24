//
//  GTHttpManager.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/10.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullability-completeness"

typedef void(^GTResultBlock)(id response, NSError *error);
typedef NS_ENUM(NSInteger, GTPhoneLoginType)
{
    GTPhoneLoginTypeRegister,
    GTPhoneLoginTypeForgetPwd
};
@interface GTHttpManager : AFHTTPSessionManager

+ (instancetype _Nullable)shareManager;

//- (nullable AFHTTPSessionManager *)GET:(NSString *)URLString
//                   parameters:(id)parameters
//                     progress:(void (^)(NSProgress * _Nonnull downloadProgress))progress
//                      success:(void (^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))success
//                      failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

- (AFHTTPSessionManager *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(void (^)(NSProgress *downloadProgress))progress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;



#pragma mark - Login
- (void)GTWxLoginWithFinishBlock:(GTResultBlock)finishBlk;


/*!
 *  @brief 获取验证码接口
 *
 *  @param mobileNo  手机号
 *  @param type      业务类型：0：注册，1：忘记密码
 *  @param finishBlk 返回结果
 */
- (void)GTPhoneFetchVerifyCodeWithMobileNo:(NSString *)mobileNo
                                      type:(GTPhoneLoginType)type
                               finishBlock:(GTResultBlock)finishBlk;


/*!
 *  @brief 手机注册接口
 *
 *  @param mobileNo  手机号
 *  @param password  密码
 *  @param code      验证码
 *  @param finishBlk 返回结果
 */
- (void)GTPhoneRegisterWithMobileNo:(NSString *)mobileNo
                           password:(NSString *)password
                         verifyCode:(NSString *)verifyCode
                        finishBlock:(GTResultBlock)finishBlk;

/*!
 *  @brief 手机号登录接口
 *
 *  @param mobileNo  手机号
 *  @param password  密码
 *  @param finishBlk 返回结果
 */
- (void)GTPhoneLoginEithMobileNo:(NSString *)mobileNo
                        password:(NSString *)password
                     finishBlock:(GTResultBlock)finishBlk;


#pragma mark - Device
- (void)GTDeviceFetchListWithFinishBlock:(GTResultBlock)finishBlk;
/*!
 *  @brief 添加设备
 *
 *  @param deviceNo       设备标号
 *  @param deviceUserName 用户名
 *  @param devicePwd      用户密码
 *  @param finishBlk      返回结果
 */
- (void)GTDeviceAddWithDeviceNo:(NSString *)deviceNo
                 deviceUserName:(NSString *)deviceUserName
                      devicePwd:(NSString *)devicePwd
                    finishBlock:(GTResultBlock)finishBlk;
/*!
 *  @brief 设备名称编辑
 *
 *  @param deviceName 设备名称
 *  @param deviceNo   设备编号
 *  @param finishBlk  返回结果
 */
- (void)GTDeviceEditDiviceName:(NSString *)deviceName
                  withDeviceNo:(NSString *)deviceNo
                   finishBlock:(GTResultBlock)finishBlk;

/*!
 *  @brief 删除设备
 *
 *  @param deviceNo  设备编号
 *  @param finishblk 返回结果
 */
- (void)GTDeviceDeleteWithDeviceNo:(NSString *)deviceNo
                       finishBlock:(GTResultBlock)finishBlk;

/*!
 *  @brief 报警记录接口
 *
 *  @param pn        页数
 *  @param finishBlk 返回结果
 */
- (void)GTWarningRecordsWithPageNo:(NSNumber *)pn
                       finishBlock:(GTResultBlock)finishBlk;


#pragma mark - UserInfo
/*!
 *  @brief 用户反馈
 *
 *  @param content 反馈内容
 *  @param contact 联系方式
 */
- (void)GTUserFeedbackWithContents:(NSString *)content
                           contact:(NSString *)contact
                       finishBlock:(GTResultBlock)finishBlk;


/*!
 *  @brief 启动接口-处理升级
 *
 *  @param finishBlk 返回结果,需要自己处理返回结果，code=1代表可以升级，code=0代表不需升级。
 */
- (void)GTAppCheckUpdateWithFinishBlock:(GTResultBlock)finishBlk;
@end

#pragma clang diagnostic pop