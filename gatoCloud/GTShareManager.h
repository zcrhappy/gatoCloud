//
//  GTShareManager.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/23.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTShareManager : NSObject
+ (instancetype)shareInstance;
- (void)shareToWXFrindWithText:(NSString *)text;
- (void)shareViaMessageWithText:(NSString *)text;
@end
