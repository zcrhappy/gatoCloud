//
//  GTDeviceModel.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/13.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GTDeviceModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString  *deviceUserName;
@property (nonatomic, copy) NSString  *devicePwd;
@property (nonatomic, copy) NSString  *deviceName;
@property (nonatomic, strong) NSNumber  *collectId;
@property (nonatomic, strong) NSNumber  *addDate;
@property (nonatomic, copy) NSString  *deviceNo;
@property (nonatomic, copy) NSString  *deviceLocal;
@property (nonatomic, copy) NSString  *contactPerson;
@property (nonatomic, copy) NSString  *cellphone;
@property (nonatomic, copy) NSString  *addTime;
@property (nonatomic, copy) NSString  *groupId;
@property (nonatomic, copy) NSString  *collectState;
@property (nonatomic, copy) NSString  *online;
@property (nonatomic, copy) NSString  *onlineState;
@property (nonatomic, copy) NSString  *version;
@property (nonatomic, copy) NSString  *address;
@property (nonatomic, copy) NSString  *ipAddr;
@property (nonatomic, copy) NSString  *appId;
@property (nonatomic, copy) NSString  *userId;
@property (nonatomic, copy) NSString  *appVersion;
@property (nonatomic, copy) NSString  *xmAppId;
@property (nonatomic, copy) NSString  *token;
@property (nonatomic, copy) NSString  *userType;

@end


