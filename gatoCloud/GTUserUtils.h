//
//  GTUserUtils.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/11.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTUserModel.h"

@interface GTUserUtils : NSObject

+ (void)saveUserInfo:(NSDictionary *)dic;

+ (GTUserModel *)userInfo;

+ (void)saveToken:(NSString *)token;

+ (void)saveUserId:(NSString *)userId;
@end
