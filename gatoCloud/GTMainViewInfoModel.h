//
//  GTMainViewInfoModel.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/26.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GTMainViewInfoModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *deviceCount;
@property (nonatomic, copy) NSString *zoneCount;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *allDeviceCount;
@end
