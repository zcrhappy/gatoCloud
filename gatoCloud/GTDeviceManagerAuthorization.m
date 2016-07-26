//
//  GTDeviceManagerAuthorization.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/25.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTDeviceManagerAuthorization.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

@implementation GTDeviceManagerAuthorization

+ (instancetype)shareInstance
{
    static dispatch_once_t pred;
    static GTDeviceManagerAuthorization *qdma = nil;
    dispatch_once(&pred, ^{
        qdma = [[GTDeviceManagerAuthorization alloc] init];
    });
    return qdma;
}
- (instancetype)init
{
    if (self = [super init]) {
        //
    }
    return self;
}
- (BOOL)isCameraAccessable
{
    AVAuthorizationStatus cameraAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return cameraAuthStatus != AVAuthorizationStatusRestricted && cameraAuthStatus != AVAuthorizationStatusDenied;
}
- (BOOL)isImageAlbumAccessable
{
    ALAuthorizationStatus imageAuthStatus = [ALAssetsLibrary authorizationStatus];
    return imageAuthStatus != ALAuthorizationStatusRestricted && imageAuthStatus != ALAuthorizationStatusRestricted;
}
@end
