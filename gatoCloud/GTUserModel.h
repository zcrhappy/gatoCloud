//
//  GTUserModel.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/11.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GTUserModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *headimgurl;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, strong) NSNumber *sex;
@property (nonatomic, copy) NSString *unionid;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userId;


@property (nonatomic, copy) NSString *customHeadImgUrlString;

@end
