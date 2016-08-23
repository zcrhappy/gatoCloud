//
//  GTLoginManager.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/11.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTWXLoginManager.h"
#import "GTUserUtils.h"
#import "NSMutableDictionary+HTTPExtension.h"
NSString *GetAccessTokenBaseURL = @"https://api.weixin.qq.com/sns/oauth2/access_token";
NSString *GetUserInfoBaseURL = @"https://api.weixin.qq.com/sns/userinfo";
NSString *kStateString = @"1q2w3e4r5t6y7u8i9o0p";
@interface GTWXLoginManager()
{
    NSString *authOpenID;
    NSString *authCode;
    NSString *authToken;
}

@end

@implementation GTWXLoginManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static GTWXLoginManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[GTWXLoginManager alloc] init];
    });
    return instance;
}

- (void)dealloc {
    self.delegate = nil;
}

#pragma mark - WXApiDelegate
/*!
 *  @brief 参数说明
 *  appid : 应用唯一标识，在微信开放平台提交应用审核通过后获得
 *  scope : 应用授权作用域，如获取用户个人信息则填写snsapi_userinfo
 *  state : 用于保持请求和回调的状态，授权请求后原样带回给第三方。该参数可用于防止csrf攻击（跨站请求伪造攻击），建议第三方带上该参数，可设置为简单的随机数加session进行校验
 */
- (void)sendAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = kAuthScope;
    req.state = kStateString;//TODO:改成随机数
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

/*!
 用户点击授权后，微信客户端会被拉起，跳转至授权界面，用户在该界面点击允许或取消，SDK通过SendAuth的Resp返回数据给调用方。
 
 ErrCode	ERR_OK = 0(用户同意)
            ERR_AUTH_DENIED = -4（用户拒绝授权）
            ERR_USER_CANCEL = -2（用户取消）
 code	用户换取access_token的code，仅在ErrCode为0时有效
 state	第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
 */
- (void)onResp:(BaseResp *)resp
{
    [MBProgressHUD showHUDAddedTo:[UIView gt_keyWindow] animated:YES];
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode == 0 && [aresp.state isEqualToString:kStateString]) {
            authCode = aresp.code;
            
            if(![authCode isEmptyString])
                [self getAccess_token];
                                  
        }else {
            [MBProgressHUD showText:@"授权失败" inView:[UIView gt_keyWindow]];
        }
    }
}
/*
 appid	是	应用唯一标识，在微信开放平台提交应用审核通过后获得
 secret	是	应用密钥AppSecret，在微信开放平台提交应用审核通过后获得
 code	是	填写第一步获取的code参数
 grant_type	是	填authorization_code
 */
-(void)getAccess_token
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:kAppId forKey:@"appid"];
    [dic safeSetObject:kAppSectet forKey:@"secret"];
    [dic safeSetObject:authCode forKey:@"code"];
    [dic safeSetObject:@"authorization_code" forKey:@"grant_type"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:GetAccessTokenBaseURL parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if([resDic objectForKey:@"errcode"]) {
                [MBProgressHUD showText:@"获取调用凭证失败" inView:[UIView gt_keyWindow]];
            }
            else {
                authToken = [resDic objectForKey:@"access_token"];
                authOpenID = [resDic objectForKey:@"openid"];
                [self getUserInfo];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showText:@"授权失败" inView:[UIView gt_keyWindow]];
    }];
}

-(void)getUserInfo
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:authToken forKey:@"access_token"];
    [dic safeSetObject:authOpenID forKey:@"openid"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:GetUserInfoBaseURL parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if([resDic objectForKey:@"errcode"]) {
            [MBProgressHUD showText:@"获取用户信息失败" inView:[UIView gt_keyWindow]];
        }
        else {
            [GTUserUtils saveUserInfoViaWX:resDic];
            [MBProgressHUD showText:@"登录成功" inView:[UIView gt_keyWindow]];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidLoginSuccessNotification object:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showText:@"授权失败" inView:[UIView gt_keyWindow]];
    }];
}


@end
