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


- (void)GTWxLoginWithFinishBlock:(GTResultBlock)finishBlk;


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

@end

#pragma clang diagnostic pop