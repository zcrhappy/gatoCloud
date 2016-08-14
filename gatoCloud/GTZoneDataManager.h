//
//  GTZoneDataManager.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/14.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GTDeviceZoneModel;
typedef NS_ENUM(NSInteger, kListType) {
    kListTypeAllZone, //所有防区
    kListTypeViaDeviceNo, //设备对应的防区列表，没有分页处理
    kListTypeViaDeviceName, //通过设备名查找防区列表
    kListTypeViaZoneName //通过防区名查找防区列表
};

@interface GTZoneDataManager : NSObject

@property (nonatomic, strong) NSMutableArray<GTDeviceZoneModel *> *zoneModelsArray;
@property (nonatomic, copy) NSString *searchKeyword;
@property (nonatomic, assign) BOOL hasMore;
- (instancetype)initWithListType:(kListType)type;
- (void)refreshDataWithFinishBlock:(GTResultBlock)finishBlock;
- (void)loadMoreWithFinishBlock:(GTResultBlock)finishBlock;
- (BOOL)isEmpty;
@end
