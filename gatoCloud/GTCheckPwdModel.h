//
//  GTCheckPwdModel.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/26.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GTCheckPwdModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *deviceNo;
@property (nonatomic, strong) NSNumber *userType;

@end
