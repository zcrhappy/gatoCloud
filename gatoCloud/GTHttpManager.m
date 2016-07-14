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

NSString * const kFeedBaseUrl = @"http://api.t.iqiyi.com";

NSString * const kBaseUrl = @"http://acloud.gato.com.cn:8088";


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
        token = @"";
        userId = @"";
    }
    
    return self;
}


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
            NSError *error = [NSError errorWithDomain:@"返回参数非法" code:-200 userInfo:dic];
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

//- (AFHTTPSessionManager *)GET:(NSString *)URLString
//                   parameters:(id)parameters
//                     progress:(void (^)(NSProgress * _Nonnull downloadProgress))progress
//                      success:(void (^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))success
//                      failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure
//{
//    if (![parameters isKindOfClass:[NSMutableDictionary class]] && [parameters isKindOfClass:[NSDictionary class]]) {
//        parameters = [parameters mutableCopy];
//    }
//    if(parameters == nil)
//        parameters = [NSMutableDictionary dictionary];
//    
//    [parameters setObject:@"1.0.0" forKey:@"releaseVersion"];
//    [parameters setObject:@"1" forKey:@"appType"];
//    [parameters setObject:@"123" forKey:@"userId"];
//    [parameters setObject:@"123224" forKey:@"token"];
//    [parameters setObject:[] forKey:@"appId"];
// 
//    
////    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
////    [request setTimeoutInterval:20];
//
//    
//
//    
//    NSString *requestString = [_baseUrl stringByAppendingString:URLString];
//    NSLog(@"发起GET请求：%@",requestString);
//    NSLog(@"%@", parameters);
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager GET:requestString parameters:parameters progress:progress success:successBlock failure:failure];
//    
//
//    
//    return manager;
//}



//- (void)refreshDataWithCompletion:(void (^)(BOOL success, NSError *error))completion
//{
//    [self refreshAPIBaseUrl];
//    AFHTTPSessionManager *mgr = [self afHttpManager];
//    
//    [self cancelRefresh];
//    
//    self.refreshOperation
//    = [mgr GET:[self refreshAPIName] parameters:[self refreshParameters]
//       success:^(AFHTTPRequestOperation *operation, id responseObject)
//       {
//           if ([responseObject[@"code"] isEqualToString:@"A00000"]) {
//               _refreshError = nil;
//               _refreshResponseData = responseObject;
//               [self didResfreshWithHandler:completion];
//           }
//           else {
//               _refreshError = [NSError errorWithDomain:APIErrorDomain code:APIErrorCode userInfo:responseObject];
//               [self didResfreshWithHandler:completion];
//           }
//           
//       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//           _refreshError = error;
//           [self didResfreshWithHandler:completion];
//       }];
//}
//
//- (void)loadMoreDataWithCompletion:(void (^)(BOOL success, NSError *error, BOOL hasMore))completion
//{
//    [self loadMoreAPIBaseUrl];
//    AFHTTPSessionManager *mgr = [self afHttpManager];
//    
//    [self cancelLoadMore];
//    
//    self.loadMoreOperation
//    = [mgr GET:[self loadMoreAPIName] parameters:[self loadMoreParameters]
//       success:^(AFHTTPRequestOperation *operation, id responseObject)
//       {
//           if ([responseObject[@"code"] isEqualToString:@"A00000"]) {
//               _loadMoreError = nil;
//               _loadMoreResponseData = responseObject;
//               [self didLoadMoreWithHandler:completion];
//           }
//           else {
//               _loadMoreError = [NSError errorWithDomain:APIErrorDomain code:APIErrorCode userInfo:responseObject];
//               [self didLoadMoreWithHandler:completion];
//           }
//           
//       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//           _loadMoreError = error;
//           [self didLoadMoreWithHandler:completion];
//       }];
//}
//
//- (void)cancelRefresh
//{
//    [self.refreshOperation setCompletionBlockWithSuccess:NULL failure:NULL];
//    [self.refreshOperation cancel];
//}
//
//- (void)cancelLoadMore
//{
//    [self.loadMoreOperation setCompletionBlockWithSuccess:NULL failure:NULL];
//    [self.loadMoreOperation cancel];
//}
//
//- (void)refreshAPIBaseUrl//刷新时baseurl处理
//{
//    
//}
//
//- (void)loadMoreAPIBaseUrl//更多时baseUrl处理
//{
//    
//}
//
//- (NSString *)refreshAPIName
//{
//    return @"";
//}
//
//- (NSString *)loadMoreAPIName
//{
//    return @"";
//}
//
//- (NSDictionary *)refreshParameters
//{
//    return nil;
//}
//
//- (NSDictionary *)loadMoreParameters
//{
//    return nil;
//}
//
//- (void)didResfreshWithHandler:(void (^)(BOOL success, NSError *error))completion
//{
//    if (![self isMemberOfClass:[QPAPIDataManager class]]) {
//        NSAssert(0, @"can't call super in subclass");
//    }
//    
//    if (!_refreshError) {
//        if (completion) {
//            completion(YES,nil);
//        }
//    }
//    else {
//        if (completion) {
//            completion(NO,_refreshError);
//        }
//    }
//}
//
//- (void)didLoadMoreWithHandler:(void (^)(BOOL success, NSError *error, BOOL hasMore))completion
//{
//    if (![self isMemberOfClass:[QPAPIDataManager class]]) {
//        NSAssert(0, @"can't call super in subclass");
//    }
//    
//    if (!_loadMoreError) {
//        if (completion) {
//            completion(YES,nil,_hasMore);
//        }
//    }
//    else {
//        if (completion) {
//            completion(NO,_loadMoreError,_hasMore);
//        }
//    }
//}

@end
