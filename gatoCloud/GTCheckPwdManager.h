//
//  GTCheckPwdManager.h
//  gatoCloud
//
//  Created by 曾超然 on 16/9/13.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTCheckPwdManager : NSObject

- (instancetype)initWithViewController:(UIViewController *)viewController;

//检查单个设备密码
- (BOOL)shouldShowPwdCheckWithDeviceNo:(NSString *)deviceNo;
//检查全部设备密码
- (void)checkAllDevicePwd;
@end
