//
//  NSString+CheckingExtension.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/10.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CheckingExtension)

- (BOOL)isEmptyString;

+ (BOOL)valiMobile:(NSString *)mobile;//返回是否合法的电话
@end
