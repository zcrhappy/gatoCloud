//
//  GTDeviceManagerAuthorization.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/25.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTDeviceManagerAuthorization : NSObject

+ (instancetype)shareInstance;
- (BOOL)isCameraAccessable;
- (BOOL)isImageAlbumAccessable;

@end
