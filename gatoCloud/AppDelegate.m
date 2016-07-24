//
//  AppDelegate.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/8.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "AppDelegate.h"
#import "GTWindow.h"
#import "GTLoginManager.h"
#import "GestureViewController.h"
#import "OHHTTPStubs.h"
#import "OHPathHelpers.h"
#import "IQKeyboardManager.h"

#define enableStubHTTP

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //向微信注册
    [WXApi registerApp:@"wx91186ee878bacc62" withDescription:@"Gato Security"];
    
    //初始化界面
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *rootViewController = [storyBoard instantiateInitialViewController];
    self.window = [[GTWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:rootViewController];
    [self.window makeKeyAndVisible];
    
    //配置键盘管理器
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needsLoginAction:) name:kNeedsLoginNotification object:nil];
#ifdef enableStubHTTP
    [self stubHTTP];
#endif
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:[GTLoginManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:[GTLoginManager sharedManager]];
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
    
//    GestureViewController *gestureUnlockViewController = [[GestureViewController alloc] init];
//    [self.window.rootViewController presentViewController:gestureUnlockViewController animated:YES completion:^{
//        
//    }];
    
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
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *rootViewController = [storyBoard instantiateInitialViewController];
        self.window = [[GTWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.window setRootViewController:rootViewController];
        [self.window makeKeyAndVisible];
    }];
    [controler addAction:doneAction];
    [[GTUserUtils appTopViewController] presentViewController:controler animated:YES completion:nil];
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



@end
