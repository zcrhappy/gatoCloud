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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin) name:kDidLoginNotification object:nil];
    }
    
    return self;
}

#pragma mark - Login

- (void)GTWxLoginWithFinishBlock:(GTResultBlock)finishBlk
{
    NSString *openId = [GTUserUtils userInfo].openid;
    NSString *headimgurl = [GTUserUtils userInfo].headimgurl;
    NSString *nickname = [GTUserUtils userInfo].nickname;
    NSString *unionid = [GTUserUtils userInfo].unionid;
    NSString *xmAppid = [[NSUUID UUID] UUIDString];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:openId forKey:@"openId"];
    [dic safeSetObject:headimgurl forKey:@"headimgurl"];
    [dic safeSetObject:nickname forKey:@"nickname"];
    [dic safeSetObject:unionid forKey:@"unionid"];
    [dic safeSetObject:xmAppid forKey:@"xmAppid"];
    
    [self POST:@"/user/wechatLogin.do" parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([responseObject isVaildResponse]) {
            token = [dic objectForKey:@"token"];
            userId = [dic objectForKey:@"userId"];
            
            [GTUserUtils saveTokenViaWX:token];
            [GTUserUtils saveUserIdViaWX:userId];
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
                 deviceUserName:(NSString *)deviceUserName
                      devicePwd:(NSString *)devicePwd
                    finishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic safeSetObject:deviceNo forKey:@"deviceNo"];
    [dic safeSetObject:deviceUserName forKey:@"deviceUserName"];
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
    
    if(token == nil || [token isEmptyString]) {
        token = [GTUserUtils userInfo].token;
    }
    if(userId == nil || [userId isEmptyString]) {
        userId = [GTUserUtils userInfo].userId;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [parameters safeSetObject:kReleaseVersion forKey:@"releaseVersion"];
    [parameters safeSetObject:kAppType forKey:@"appType"];
    [parameters safeSetObject:userId forKey:@"userId"];
    [parameters safeSetObject:token forKey:@"token"];
    [parameters safeSetObject:uuid forKey:@"appId"];
    
    NSString *urlString = [_baseUrl stringByAppendingString:URLString];
    
    
    NSLog(@"发起POST请求：%@",urlString);
    NSLog(@"参数：%@",parameters);
    
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^void(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSLog(@"返回的数据内容为：%@",responseObject);
        if([responseObject isNeedLogin]){
            NSLog(@"需要重新登录");
            [GTUserUtils unRegisterUserInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNeedsLoginNotification object:nil];
        }
        else {
            success(task,responseObject);
        }
    };
    
    void (^failureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"出错了，返回的数据内容为：%@", error);
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
    token = [GTUserUtils userInfo].token;
    userId = [GTUserUtils userInfo].userId;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidLoginNotification object:nil];
}


@end
