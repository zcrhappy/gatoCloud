//
//  GTDeviceZoneModel2.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/3.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GTDeviceZoneModel2 : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *zoneNo;
@property (nonatomic, copy) NSString *zoneName;
@property (nonatomic, copy) NSString *zoneState;
@property (nonatomic, copy) NSString *operatorName;
@property (nonatomic, copy) NSString *zoneDesc;
@property (nonatomic, copy) NSString *zoneContactor;
@property (nonatomic, copy) NSString *zonePhone;
@property (nonatomic, copy) NSString *zoneLoc;
@property (nonatomic, strong) NSNumber *addDate;//
@property (nonatomic, copy) NSString *DEVICENO;
@property (nonatomic, copy) NSString *ZONETYPE;
@property (nonatomic, copy) NSString *ZONEVMP;
@property (nonatomic, copy) NSString *ZONESTRAIN;
@property (nonatomic, copy) NSString *ZONESTRAINVPT;//
@property (nonatomic, copy) NSString *ZONEONLINE;
@property (nonatomic, copy) NSString *devicename;
@property (nonatomic, copy) NSString *zoneStyle;
@end
