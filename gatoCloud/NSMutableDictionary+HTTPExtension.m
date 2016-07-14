//
//  NSMutableDictionary+HTTPExtension.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/11.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "NSMutableDictionary+HTTPExtension.h"

@implementation NSMutableDictionary (HTTPExtension)

- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey;
{
    if(anObject != nil && aKey != nil)
        [self setObject:anObject forKey:aKey];
}

@end
