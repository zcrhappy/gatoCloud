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


#pragma mark - Main

/*!
 *  @brief 首页数据接口
 *
 *  @param finishBlk 返回参数，包括deviceCount,zoneCount,headImg,desc
 */
- (void)GTQueryMainViewInfoWithFinishBlock:(GTResultBlock)finishBlk;

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
                            istate:(NSNumber *)istate
                       finishBlock:(GTResultBlock)finishBlk;


/*!
 *  @brief 单个报警消警
 *
 *  @param warningId 报警Id1470253697
 *  @param istate    0未处理  1已处理  2误报
 *  @param zoneNo    防区200afe6b30e38003
 *  @param memo      hello
 *  @param finishBlk 返回结果
 */
- (void)GTWarningRecordHandleWithWarningId:(NSString *)warningId
                                    istate:(NSNumber *)istate
                                    zoneNo:(NSString *)zoneNo
                                      memo:(NSString *)memo
                               finishBlock:(GTResultBlock)finishBlk;

/*!
 *  @brief 报警搜索
 *
 *  @param searchType 查询类型0时间段搜索 1报警类型搜索 2设备搜索 3防区搜索
 *  @param beginDate  开始时间 yyyy-MM-dd
 *  @param endDate    结束时间 yyyy-MM-dd
 *  @param warnType   报警类型 dev:主机报警 net:通讯报警 fence:入侵报警
 *  @param deivceName 设备名称
 *  @param zoneName   防区名称
 *  @param pn         页数
 *  @param finishBlk  返回结果
 */
- (void)GTSearchWarningRecordsWithSearchType:(NSNumber *)searchType
                                   beginDate:(NSString *)beginDate
                                     endDate:(NSString *)endDate
                                    warnType:(NSString *)warnType
                                  deviceName:(NSString *)deviceName
                                    zoneName:(NSString *)zoneName
                                          pn:(NSNumber *)pn
                                 finishBlock:(GTResultBlock)finishBlk;

/*!
 *  @brief 一键消警
 *
 *  @param deviceNo  设备编号
 *  @param finishBlk 返回结果
 */
- (void)GTOneKeyDisableWarningWithDeviceNo:(NSString *)deviceNo
                               finishBlock:(GTResultBlock)finishBlk;


/*!
 *  @brief 一键布撤防
 *
 *  @param deviceNo  设备编号
 *  @param istate    状态  2一键布防   1一键撤防
 *  @param pwd       设备密码
 *  @param finishBlk  code  10000调用成功  其他失败  -4000:密码错误
 */
- (void)GTOneKeyDealingGuardWithDeviceNo:(NSString *)deviceNo
                                  istate:(NSNumber *)istate
                                     pwd:(NSString *)pwd
                             finishBlock:(GTResultBlock)finishBlk;

#pragma mark - Zone
/*!
 *  @brief 设备对应防区列表
 *
 *  @param devceNo   设备号
 *  @param finishBlk 返回结果zoneModel
 */
- (void)GTDeviceZoneWithDeviceNo:(NSString *)deviceNo
                     finishBlock:(GTResultBlock)finishBlk;

/*!
 *  @brief 单个防区布防，撤防操作
 *
 *  @param iState    1撤防 2布防
 *  @param zoneNo    防区唯一编号
 *  @param finishBlk 返回结果
 */
- (void)GTDeviceZoneChangeDefenceWithState:(NSString *)iState
                                    zoneNo:(NSString *)zoneNo
                               finishBlock:(GTResultBlock)finishBlk;

/*!
 *  @brief 全部防区列表
 *
 *  @param pn        页数
 *  @param finishBlk 返回结果 包含zoneModel
 */
- (void)GTDeviceZoneListWithPn:(NSNumber *)pn
                   finishBlock:(GTResultBlock)finishBlk;


/*!
 *  @brief 防区按设备名称搜索
 *
 *  @param name      设备名称 eg.武汉展厅
 *  @param pn        页数 eg.1
 *  @param finishBlk 返回结果
 */
- (void)GTDeviceZoneWithDeviceName:(NSString *)name
                                pn:(NSNumber *)pn
                       finishBlock:(GTResultBlock)finishBlk;


/*!
 *  @brief 防区按防区名称搜索
 *
 *  @param zoneName  防区名称 eg.武汉001
 *  @param pn        页数 eg.1
 *  @param finishBlk 返回结果
 */
- (void)GTDeviceZoneListWithZoneName:(NSString *)zoneName
                                  pn:(NSNumber *)pn
                         finishBlock:(GTResultBlock)finishBlk;


/*!
 *  @brief 设备防区信息编辑
 *
 *  @param zoneNo        编号200afe6b30e38007
 *  @param zoneName      名称007
 *  @param zoneContactor 联系人1
 *  @param zonePhone     电话2
 *  @param zoneLoc       地理信息3
 *  @param zoneDesc      描述4
 *  @param finishBlk     返回结果
 */
- (void)GTDeviceZoneEditInfoWithZoneNo:(NSString *)zoneNo
                              zoneName:(NSString *)zoneName
                         zoneContactor:(NSString *)zoneContactor
                             zonePhone:(NSString *)zonePhone
                               zoneLoc:(NSString *)zoneLoc
                              zoneDesc:(NSString *)zoneDesc
                           finishBlock:(GTResultBlock)finishBlk;

/*!
 *  @brief 批量布撤防
 *
 *  @param deviceNo  设备编号
 *  @param istate    1批量撤防 2批量布防
 *  @param pwd       密码
 *  @param zoneNos   防区编号  用英文逗号分割
 *  @param finishBlk 返回结果
 */
- (void)GTDeviceZoneBatchGuardWithDeviceNo:(NSString *)deviceNo
                                    istate:(NSNumber *)istate
                                       pwd:(NSString *)pwd
                                   zoneNos:(NSString *)zoneNos
                               finishBlock:(GTResultBlock)finishBlk;


/*!
 *  @brief 单个防区状态查询（用于修改防区状态之后轮询）
 *
 *  @param zoneNo    防区编号
 *  @param finishBlk zoneState 3 或者 4 提示 恭喜您操作成功! 1、2 时  继续轮询，最多轮询5次   1 撤防中 2布放中 3 撤防 4 布防
 */
- (void)GTDeviceZoneQueryWithZoneNo:(NSString *)zoneNo
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
 *  @brief 头像上传
 *
 *  @param data      图片流
 *  @param finishBlk 返回结果
 */
- (void)GTUploadAvatarWithData:(NSData *)data
                   finishBlock:(GTResultBlock)finishBlk;

/*!
 *  @brief 启动接口-处理升级:两处有调用，首页和检测升级
 *
 *  @param finishBlk 返回结果,需要自己处理返回结果，code=1代表可以升级，code=0代表不需升级。
 */
- (void)GTAppCheckUpdateWithFinishBlock:(GTResultBlock)finishBlk;

@end

#pragma clang diagnostic pop