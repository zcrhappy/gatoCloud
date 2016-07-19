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
//        _baseUrl = kTestBaseUrl;
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
            
            [GTUserUtils saveToken:token];
            [GTUserUtils saveUserId:userId];
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
    [dic safeSetObject:verifyCode forKey:@"code"];
    
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
    
    if (![parameters isKindOfClass:[NSMutableDictionary class]] && [parameters isKindOfClass:[NSDictionary class]]) {
        parameters = [parameters mutableCopy];
    }
    if(parameters == nil)
        parameters = [NSMutableDictionary dictionary];
    
    static NSString *uuid = nil;
    uuid = [[NSUUID UUID] UUIDString];
    
    if([token isEmptyString]) {
        token = [GTUserUtils userInfo].token;
    }
    if([userId isEmptyString]) {
        userId = [GTUserUtils userInfo].userId;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [parameters safeSetObject:kReleaseVersion forKey:@"releaseVersion"];
    [parameters safeSetObject:kAppType forKey:@"appType"];
    [parameters safeSetObject:userId forKey:@"userId"];
    [parameters safeSetObject:token forKey:@"token"];
    [parameters safeSetObject:uuid forKey:@"appId"];
    
    NSString *urlString = [_baseUrl stringByAppendingString:URLString];
    
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^void(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSLog(@"返回的数据内容为：%@",responseObject);
        success(task,responseObject);
    };
    
    [manager POST:urlString parameters:parameters progress:progress success:successBlock failure:failure];
    
    return manager;
}


@end
