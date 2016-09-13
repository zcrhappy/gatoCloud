//
//  GTHttpManager.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/10.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTHttpManager.h"
#import "NSMutableDictionary+HTTPExtension.h"
#import "NSDictionary+HTTPExtionsion.h"

#define TESTURL

NSString * const kBaseUrl = @"http://acloud.gato.com.cn:8088";
NSString * const kTestBaseUrl = @"http://115.159.44.248:8090";

NSString *const APIErrorDomain = @"server api error";
NSInteger const APIErrorCode = 138102;

@interface GTHttpManager()
{
    NSString *_baseUrl;
    NSString *token;
    NSString *userId;
}

@property(nonatomic, strong) AFHTTPSessionManager *refreshOperation;
@property(nonatomic, strong) AFHTTPSessionManager *loadMoreOperation;
@end


@implementation GTHttpManager


+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static GTHttpManager *_shareManager = nil;
    dispatch_once(&onceToken, ^{
        _shareManager = [[GTHttpManager alloc] init];
    });
    return _shareManager;
}

- (id)init
{
    self = [super init];
    if(self){
        _baseUrl = kBaseUrl;
#ifdef TESTURL
        _baseUrl = kTestBaseUrl;
#endif
        token = @"";
        userId = @"";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin) name:kDidLoginSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout) name:kDidLogoutNotification object:nil];
    }
    
    return self;
}

#pragma mark - Login

- (void)GTWxLoginWithFinishBlock:(GTResultBlock)finishBlk
{
    NSString *openId = [GTUserUtils sharedInstance].userModel.openid;
    NSString *headimgurl = [GTUserUtils sharedInstance].userModel.headimgurl;
    NSString *nickname = [GTUserUtils sharedInstance].userModel.nickname;
    NSString *unionid = [GTUserUtils sharedInstance].userModel.unionid;
    NSString *xmAppid = [GTUserUtils regId];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:openId forKey:@"openId"];
    [dic safeSetObject:headimgurl forKey:@"headimgurl"];
    [dic safeSetObject:nickname forKey:@"nickname"];
    [dic safeSetObject:unionid forKey:@"unionid"];
    [dic safeSetObject:xmAppid forKey:@"xmAppId"];
    
    [self POST:@"/user/wechatLogin.do" parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([responseObject isVaildResponse]) {
            token = [dic objectForKey:@"token"];
            userId = [dic objectForKey:@"userId"];
            
            [GTUserUtils saveToken:token userId:userId];
            [GTUserUtils loginSuccess];
        }
        finishBlk(dic, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        finishBlk(nil, error);
    }];
}

- (void)GTPhoneFetchVerifyCodeWithMobileNo:(NSString *)mobileNo
                                           type:(GTPhoneLoginType)type
                                    finishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:mobileNo forKey:@"mobileNo"];
    [dic safeSetObject:@(type) forKey:@"type"];
    
    [self POST:@"/user/sendYzm.do" parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isVaildResponse]) {
            
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        finishBlk(nil, error);
    }];
}

- (void)GTPhoneRegisterWithMobileNo:(NSString *)mobileNo
                           password:(NSString *)password
                         verifyCode:(NSString *)verifyCode
                        finishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:mobileNo forKey:@"mobileNo"];
    [dic safeSetObject:password forKey:@"password"];
    [dic safeSetObject:verifyCode forKey:@"yzm"];
    [dic safeSetObject:[GTUserUtils regId] forKey:@"xmAppId"];
    
    [self POST:@"/user/mobRegister.do" parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isVaildResponse]) {
            
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        finishBlk(nil, error);
    }];
}

- (void)GTPhoneLoginEithMobileNo:(NSString *)mobileNo
                        password:(NSString *)password
                     finishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:mobileNo forKey:@"mobileNo"];
    [dic safeSetObject:password forKey:@"password"];
    [dic safeSetObject:[GTUserUtils regId] forKey:@"xmAppId"];
    [self POST:@"/user/mobLogin.do" parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isVaildResponse]) {
            
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        finishBlk(nil, error);
    }];
}


/*!
 *  @brief 手机注册接口
 *
 *  @param mobileNo  手机号
 *  @param password  密码
 *  @param code      验证码
 *  @param finishBlk 返回结果
 */
- (void)GTLoginForgetPwdWithMobileNo:(NSString *)mobileNo
                            password:(NSString *)password
                          verifyCode:(NSString *)verifyCode
                         finishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:mobileNo forKey:@"mobileNo"];
    [dic safeSetObject:password forKey:@"password"];
    [dic safeSetObject:verifyCode forKey:@"yzm"];
    [dic safeSetObject:[GTUserUtils regId] forKey:@"xmAppId"];
    
    [self POST:@"/user/forgeSetPwd.do" parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isVaildResponse]) {
            
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        finishBlk(nil, error);
    }];
}
#pragma mark - Main

/*!
 *  @brief 首页数据接口
 *
 *  @param finishBlk 返回参数，包括deviceCount,zoneCount,headImg,desc
 */
- (void)GTQueryMainViewInfoWithFinishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [self POST:@"/queryIndexData.do" parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:dic];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        finishBlk(nil, error);
    }];
    

}
#pragma mark - Device

/*!
 *  @brief 获取需要验证密码的设备列表.在两处地方调用,进首页和在设备列表里面点击设备时候。
 *
 *  @param finishBlk
 */
- (void)GTDeviceQueryCheckPwdDeviceWithFinishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [self POST:@"/queryCheckPwdDevices.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];
}

- (void)GTDeviceFetchListWithFinishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [self POST:@"/queryUserDevices.do" parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        if ([responseObject isVaildResponse]) {
            NSArray *list = [dic objectForKey:@"list"];
            finishBlk(list, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:dic];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        finishBlk(nil, error);
    }];

}

- (void)GTDeviceAddWithDeviceNo:(NSString *)deviceNo
                 deviceUserType:(NSString *)userType
                      devicePwd:(NSString *)devicePwd
                    finishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:deviceNo forKey:@"deviceNo"];
    [dic safeSetObject:userType forKey:@"userType"];
    [dic safeSetObject:devicePwd forKey:@"devicePwd"];
    
    [self POST:@"/service/bindDevice.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];
}

- (void)GTDeviceEditDiviceName:(NSString *)deviceName
                  withDeviceNo:(NSString *)deviceNo
                   finishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:deviceNo forKey:@"deviceNo"];
    [dic safeSetObject:deviceName forKey:@"deviceName"];
    
    [self POST:@"/service/editDeviceName.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];
}

- (void)GTDeviceDeleteWithDeviceNo:(NSString *)deviceNo
                       finishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:deviceNo forKey:@"deviceNo"];
    
    [self POST:@"/service/unbindDevice.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];
    
}

- (void)GTWarningRecordsWithPageNo:(NSNumber *)pn
                            istate:(NSNumber *)istate
                       finishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSInteger rn = arc4random();
    
    [dic safeSetObject:pn forKey:@"pn"];
    [dic safeSetObject:@(rn) forKey:@"rn"];
    [dic safeSetObject:istate forKey:@"istate"];
    
    [self POST:@"/queryWarningsPage.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];
}

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
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:warningId forKey:@"warningId"];
    [dic safeSetObject:istate forKey:@"istate"];
    [dic safeSetObject:zoneNo forKey:@"zoneNo"];
    [dic safeSetObject:memo forKey:@"memo"];
    
    [self POST:@"/service/handleWaring.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];
}

/*!
 *  @brief 一键消警
 *
 *  @param deviceNo  设备编号
 *  @param finishBlk 返回结果
 */
- (void)GTOneKeyDisableWarningWithDeviceNo:(NSString *)deviceNo
                               finishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:deviceNo forKey:@"deviceNo"];
    
    [self POST:@"/service/deviceHandleWaring.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];
}

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
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:deviceNo forKey:@"deviceNo"];
    [dic safeSetObject:istate forKey:@"istate"];
    [dic safeSetObject:pwd forKey:@"pwd"];
    
    [self POST:@"/service/deviceDefence.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];
}

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
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:searchType.stringValue forKey:@"searchType"];
    [dic safeSetObject:pn forKey:@"pn"];
    [dic safeSetObject:beginDate forKey:@"beginDate"];
    [dic safeSetObject:endDate forKey:@"endDate"];
    [dic safeSetObject:warnType forKey:@"warnType"];
    [dic safeSetObject:deviceName forKey:@"deviceName"];
    [dic safeSetObject:zoneName forKey:@"zoneName"];
    
    [self POST:@"/searchWarns.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];
}


/*!
 *  @brief 消除所有报警接口
 *
 *  @param finishBlk 返回结果
 */
- (void)GTHandleAllWarningsWithFinishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [self POST:@"/service/HandleAllWaring.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];

}

#pragma mark - Zone
/*!
 *  @brief 设备对应防区列表
 *
 *  @param devceNo   设备号
 *  @param finishBlk 返回结果zoneModel
 */
- (void)GTDeviceZoneWithDeviceNo:(NSString *)deviceNo
                     finishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:deviceNo forKey:@"deviceNo"];
    
    [self POST:@"/queryDeviceZones.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];

}

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
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:iState forKey:@"istate"];
    [dic safeSetObject:zoneNo forKey:@"zoneNo"];
    
    [self POST:@"/service/defence.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];
}

/*!
 *  @brief 全部防区列表
 *
 *  @param pn        页数
 *  @param finishBlk 返回结果 包含zoneModel
 */
- (void)GTDeviceZoneListWithPn:(NSNumber *)pn
                   finishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:pn forKey:@"pn"];
    
    [self POST:@"/queryZones.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];
}

/*!
 *  @brief 防区按设备名称搜索
 *
 *  @param name      设备名称
 *  @param pn        页数
 *  @param finishBlk 返回结果
 */
- (void)GTDeviceZoneWithDeviceName:(NSString *)deviceName
                                pn:(NSNumber *)pn
                       finishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:pn forKey:@"pn"];
    [dic safeSetObject:deviceName forKey:@"deviceName"];
    
    [self POST:@"/queryZones.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];
}

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
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:pn forKey:@"pn"];
    [dic safeSetObject:zoneName forKey:@"zoneName"];
    
    [self POST:@"/queryZones.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];
}


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
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:zoneNo forKey:@"zoneNo"];
    [dic safeSetObject:zoneName forKey:@"zoneName"];
    [dic safeSetObject:zoneContactor forKey:@"zoneContactor"];
    [dic safeSetObject:zonePhone forKey:@"zonePhone"];
    [dic safeSetObject:zoneLoc forKey:@"zoneLoc"];
    [dic safeSetObject:zoneDesc forKey:@"zoneDesc"];
    
    [self POST:@"/service/editZone.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];
}

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
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:deviceNo forKey:@"deviceNo"];
    [dic safeSetObject:istate forKey:@"istate"];
    [dic safeSetObject:pwd forKey:@"pwd"];
    [dic safeSetObject:zoneNos forKey:@"zoneNos"];
    
    [self POST:@"/service/batchDefence.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];
}

/*!
 *  @brief 单个防区状态查询（用于修改防区状态之后轮询）
 *
 *  @param zoneNo    防区编号
 *  @param finishBlk zoneState 3 或者 4 提示 恭喜您操作成功! 1、2 时  继续轮询，最多轮询5次   1 撤防中 2布放中 3 撤防 4 布防
 */
- (void)GTDeviceZoneQueryWithZoneNo:(NSString *)zoneNo
                        finishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:zoneNo forKey:@"zoneNo"];
//    [dic safeSetObject:@"1" forKey:@"pn"];
    
    [self POST:@"/queryZone.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];
}

/*!
 *  @brief 修改防区张力阈值
 *
 *  @param zoneNo        防区编号
 *  @param zoneStrainVpt 阈值范围(10,99) 中间用英文逗号分割前面 松弛阈值 后面 拉紧阈值
 *  @param finishBlk     返回值
 */
- (void)GTEditZoneStrainWithZoneNo:(NSString *)zoneNo
                     zoneStrainVpt:(NSString *)zoneStrainVpt
                       finishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:zoneNo forKey:@"zoneNo"];
    [dic safeSetObject:zoneStrainVpt forKey:@"zoneStrainVpt"];
    
    [self POST:@"/service/editZoneStrainVpt.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];
}

#pragma mark - Push Notification
/*!
 *  @brief 查询推送设置
 *
 *  @param finishBlk 返回结果
 */
- (void)GTQueryPushConfigWithFinishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [self POST:@"/queryPushConfig.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];
}

/*!
 *  @brief 推送设置
 *
 *  @param itype 0不推送   1只在白天推送   2所有时间段均推送
 */
- (void)GTPushConfigWithType:(NSString *)itype
                 finishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:itype forKey:@"itype"];
    
    [self POST:@"/service/pushConfig.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];
}

#pragma mark - UserInfo
- (void)GTUserFeedbackWithContents:(NSString *)content
                           contact:(NSString *)contact
                       finishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:content forKey:@"contents"];
    [dic safeSetObject:contact forKey:@"contact"];
    
    [self POST:@"/service/addRetroaction.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];
}

- (void)GTUploadAvatarWithData:(NSData *)data
                   finishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [self POST:@"/user/uploadHeadImg.do" parameters:dic formData:data progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];
}


- (void)GTAppCheckUpdateWithFinishBlock:(GTResultBlock)finishBlk;
{
    [self POST:@"/start.do" parameters:[NSMutableDictionary dictionary] progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        finishBlk(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];
}

/*!
 *  @brief 设置用户昵称
 *
 *  @param nickName  用户昵称
 *  @param finishBlk 返回结果
 */
- (void)GTEditDisplayName:(NSString *)nickName
              finishBlock:(GTResultBlock)finishBlk;

{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:nickName forKey:@"nickName"];
    
    [self POST:@"/user/setNickName.do" parameters:dic progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isVaildResponse]) {
            finishBlk(responseObject, nil);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:responseObject];
            [self showErrorMsgWithResponse:responseObject];
            finishBlk(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishBlk(nil, error);
    }];

}

- (void)showErrorMsgWithResponse:(NSDictionary *)dic
{
    NSString *msg = [dic objectForKey:@"desc"];
    
    if(msg) {
        [MBProgressHUD showText:msg inView:[UIView gt_keyWindow]];
    }
}

#pragma mark - Base Mothod
- (AFHTTPSessionManager *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(void (^)(NSProgress * _Nonnull downloadProgress))progress
                       success:(void (^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))success
                       failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure
{
    return [self POST:URLString parameters:parameters formData:nil progress:progress success:success failure:failure];
}

- (AFHTTPSessionManager *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      formData:(NSData *)data
                      progress:(void (^)(NSProgress * _Nonnull downloadProgress))progress
                       success:(void (^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))success
                       failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure
{
    if (![parameters isKindOfClass:[NSMutableDictionary class]] && [parameters isKindOfClass:[NSDictionary class]]) {
        parameters = [parameters mutableCopy];
    }
    if(parameters == nil)
        parameters = [NSMutableDictionary dictionary];
    
    static NSString *uuid = nil;
    uuid = [[NSUUID UUID] UUIDString];
    static NSString *appVersion = nil;
    appVersion = [GTUserUtils version];
    
    if(token == nil || [token isEmptyString]) {
        token = [GTUserUtils sharedInstance].userModel.token;
    }
    if(userId == nil || [userId isEmptyString]) {
        userId = [GTUserUtils sharedInstance].userModel.userId;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [parameters safeSetObject:appVersion forKey:@"appVersion"];
    [parameters safeSetObject:kAppType forKey:@"appType"];
    [parameters safeSetObject:userId forKey:@"userId"];
    [parameters safeSetObject:token forKey:@"token"];
    [parameters safeSetObject:uuid forKey:@"appId"];
    
    NSString *urlString = [_baseUrl stringByAppendingString:URLString];
    
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^void(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        long index = random();
        NSLog(@"[%ld]发起POST请求：%@",index, urlString);
        NSLog(@"[%ld]参数：%@",index, parameters);
        NSLog(@"[%ld]返回的数据内容为：%@",index, responseObject);
        if([responseObject isNeedLogin]){
            NSLog(@"需要重新登录");
            [GTUserUtils unRegisterUserInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNeedsLoginNotification object:nil];
            [self didLogout];
        }
        else {
            success(task,responseObject);
        }
    };
    
    void (^failureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        long index = random();
        NSLog(@"[%ld]发起POST请求：%@",index, urlString);
        NSLog(@"[%ld]参数：%@",index, parameters);
        NSLog(@"[%ld]出错了，返回的数据内容为：%@",index, error);
        failure(task, error);
    };
    
    
    if(data == nil) {
        [manager POST:urlString parameters:parameters progress:nil success:successBlock failure:failureBlock];
    }
    else {
        [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:data name:@"file" fileName:@"headImg.jpg" mimeType:@"image/jpg"];
        } progress:nil success:successBlock failure:failureBlock];
    }
    
    
    return manager;
}

- (void)didLogin
{
    token = [GTUserUtils sharedInstance].userModel.token;
    userId = [GTUserUtils sharedInstance].userModel.userId;
}

- (void)didLogout
{
    token = @"";
    userId = @"";
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidLoginSuccessNotification object:nil];
}


@end
