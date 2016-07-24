//
//  GTMacroConstantHeader.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/9.
//  Copyright © 2016年 Gato. All rights reserved.
//

#ifndef GTMacroConstantHeader_h
#define GTMacroConstantHeader_h

//notificationName
#define kDidLoginNotification @"kDidLoginNotification"


#define kAuthScope      @"snsapi_userinfo"
#define kAppId          @"wx91186ee878bacc62"
#define kAppSectet      @"5989fd8c7000f1f95af783e97c5239b9"
#define kReleaseVersion @"1.0.0"
#define kAppType @"1"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width;
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height;

#define kUserDefaultKeyForDeviceCellMenuShow @"kUserDefaultKeyForDeviceCellMenuShow"
#define kNeedsLoginNotification @"kNeedsLoginNotification"

/** 自动定义 NSString **/
#define NSSTRING_COPY  @property (nonatomic, copy) NSString
/** 自动定义 NSNumber **/
#define NSNUMBER_STRONG  @property (nonatomic, copy) NSNumber

#endif /* GTMacroConstantHeader_h */
