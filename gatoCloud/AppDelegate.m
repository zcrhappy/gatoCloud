//
//  AppDelegate.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/8.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "AppDelegate.h"
#import "GTWindow.h"
#import "GTWXLoginManager.h"
#import "GestureViewController.h"
#import "OHHTTPStubs.h"
#import "OHPathHelpers.h"
#import "IQKeyboardManager.h"
#import "GTGestureManager.h"
#import "MiPushSDK.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
//#define enableStubHTTP

@interface AppDelegate ()<WXApiDelegate, MiPushSDKDelegate, UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //开启日志收集
    [Fabric with:@[[Crashlytics class]]];
    
    //向微信注册
    [WXApi registerApp:@"wx91186ee878bacc62" withDescription:@"Gato Security"];
    
    //初始化界面
    [self showRootViewController];
    if([GTUserUtils isLogin])
    {
        [self didLoginSuccess:nil];
    }
    
    //配置键盘管理器
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needsLoginAction:) name:kNeedsLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout:) name:kDidLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginSuccess:) name:kDidLoginSuccessNotification object:nil];
#ifdef enableStubHTTP
    [self stubHTTP];
#endif
    
    //注册APNS
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//角标清除
//    [MiPushSDK registerMiPush:self];
    [MiPushSDK registerMiPush:self type:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge connect:YES];
    // 同时启用APNs跟应用内长连接
//    [self setupPushService];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:[GTWXLoginManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:[GTWXLoginManager sharedManager]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//角标清除
    if([GTUserUtils isLogin])
    {
        GestureViewController *gestureUnlockViewController = [[GestureViewController alloc] init];
        gestureUnlockViewController.type = GestureViewControllerTypeLogin;
        if(![[UIViewController gt_topViewController] isKindOfClass:GestureViewController.class])
            [[UIViewController gt_topViewController] presentViewController:gestureUnlockViewController animated:NO completion:nil];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)needsLoginAction:(NSNotification *)notification
{
    UIAlertController *controler = [UIAlertController alertControllerWithTitle:@"会话过期" message:@"需要重新登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //初始化界面
        [UIViewController gt_backToRootViewControllerWithCompletion:nil];
    }];
    [controler addAction:doneAction];
    
    [[UIViewController gt_topViewController] presentViewController:controler animated:YES completion:nil];
}

- (void)didLogout:(NSNotification *)noti
{
    [UIViewController gt_backToRootViewControllerWithCompletion:nil ];
}

- (void)didLoginSuccess:(NSNotification *)noti
{
    NSLog(@"success");
    [UIViewController gt_backToRootViewControllerWithCompletion:^{
        [[UIViewController gt_rootViewController] gt_presentViewControllerWithStoryBoardIdentifier:@"GTMainViewControllerID" animated:NO completion:^{
            if([GTGestureManager isFirstLoad])
                [[GTGestureManager sharedInstance] showSettingGestureView];
            else
                [[GTGestureManager sharedInstance] showLoginGestureView];
        }];
    }];
}

- (void)showRootViewController
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *rootViewController = [storyBoard instantiateViewControllerWithIdentifier:@"LoginMenuViewControllerID"];
    if(self.window == nil)
        self.window = [[GTWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:rootViewController];
    [self.window makeKeyAndVisible];
}

- (void)stubHTTP
{
    //test
//    NSDictionary *reqMap = @{@"queryWarningsPage.do": @"page.json"};
    NSDictionary *reqMap = @{@"start.do":@"start.json"};
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [reqMap.allKeys containsObject:request.URL.lastPathComponent];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // Stub it with our "wsresponse.json" stub file (which is in same bundle as self)
        NSString* fixture = OHPathForFile(reqMap[request.URL.lastPathComponent], self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:fixture
                                                statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
}

#pragma mark UIApplicationDelegate
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 注册APNS成功, 注册deviceToken
    [MiPushSDK bindDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    // 注册APNS失败
    // 自行处理
}

#pragma mark MiPushSDKDelegate

- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
{
    // 请求成功
    // 可在此获取regId
    if ([selector isEqualToString:@"bindDeviceToken:"]) {
        [GTUserUtils saveRegId:data[@"regid"]];
        NSLog(@"regid = %@", data[@"regid"]);
    }
}

- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data
{
    // 请求失败
}

- ( void )miPushReceiveNotification:( NSDictionary *)data
{
    // 长连接收到的消息。消息格式跟APNs格式一样
}

- ( void )application:( UIApplication *)application didReceiveRemoteNotification:( NSDictionary *)userInfo
{
    [ MiPushSDK handleReceiveRemoteNotification :userInfo];
    // 使用此方法后，所有消息会进行去重，然后通过miPushReceiveNotification:回调返回给App
}

- (void)pushStatusDidChange:(NSNotification *)noti
{
    [self setupPushService];
}

- (void)setupPushService
{
    [MiPushSDK registerMiPush:self type:0 connect:YES];
}

// iOS10新加入的回调方法
// 应用在前台收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [MiPushSDK handleReceiveRemoteNotification:userInfo];
    }
    //    completionHandler(UNNotificationPresentationOptionAlert);
}

// 点击通知进入应用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [MiPushSDK handleReceiveRemoteNotification:userInfo];
    }
    completionHandler();
}

@end
