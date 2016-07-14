//
//  NSMutableDictionary+HTTPExtension.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/11.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (HTTPExtension)

- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end
