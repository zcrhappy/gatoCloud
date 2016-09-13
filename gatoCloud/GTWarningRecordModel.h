//
//  GTWarningRecordModel.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/20.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GTWarningRecordModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy  ) NSString *WARNINGID;
@property (nonatomic, copy  ) NSString *ZONENO;
@property (nonatomic, copy  ) NSString *WARNDATE;
@property (nonatomic, strong) NSNumber *ISTATE;
@property (nonatomic, copy  ) NSString *HANDLER;
@property (nonatomic, copy  ) NSString *HANDLEDATE;
@property (nonatomic, copy  ) NSString *memo;
@property (nonatomic, copy  ) NSString *WARNTYPE;
@property (nonatomic, copy  ) NSString *zonename;
@property (nonatomic, copy  ) NSString *devicename;
@property (nonatomic, copy  ) NSString *zonecontactor;
@property (nonatomic, copy  ) NSString *zonephone;
@property (nonatomic, copy  ) NSString *zoneLoc;
@property (nonatomic, copy) NSString *deviceNo;

- (NSString *)getIstateString;

- (NSString *)getDateStrWithFormat:(NSString *)format;

- (NSString *)getWarningTypeStr;
@end


