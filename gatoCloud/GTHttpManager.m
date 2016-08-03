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
                       finishBlock:(GTResultBlock)finishBlk;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSInteger rn = arc4random();
    
    [dic safeSetObject:pn forKey:@"pn"];
    [dic safeSetObject:@(rn) forKey:@"rn"];
    
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
    
    [dic safeSetObject:iState forKey:@"iState"];
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
- (void)GTDeviceZoneListWithPn:(NSString *)pn
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



@end
