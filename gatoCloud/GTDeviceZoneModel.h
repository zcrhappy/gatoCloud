//
//  GTDeviceZoneModel.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/27.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "GTDeviceZoneModel2.h"
@interface GTDeviceZoneModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *zoneOnline;
@property (nonatomic, copy) NSString *zoneState;
@property (nonatomic, copy) NSString *zoneName;
@property (nonatomic, copy) NSString *zoneContactor;
@property (nonatomic, copy) NSString *zonePhone;
@property (nonatomic, copy) NSString *zoneLoc;
@property (nonatomic, copy) NSString *zoneDesc;
@property (nonatomic, strong) NSNumber *addDate;//
@property (nonatomic, copy) NSString *zoneNo;
@property (nonatomic, copy) NSString *deviceNo;
@property (nonatomic, copy) NSString *zoneStrainVpt;
@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, copy) NSString *operatorName;//
@property (nonatomic, copy) NSString *zoneType;
@property (nonatomic, copy) NSString *zoneVmp;
@property (nonatomic, copy) NSString *zoneStrain;
@property (nonatomic, copy) NSString *ipAddr;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *xmAppId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *token;

@property (nonatomic, assign) BOOL isExpand;

- (NSString *)zoneTypeStringWithSuffix:(BOOL)needsSuffix;
- (NSString *)zoneStateString;
- (BOOL)zoneStateForSwithButton;

+ (NSArray <GTDeviceZoneModel *>*)transformFromArray:(NSArray <GTDeviceZoneModel2 *>*)array;

@end