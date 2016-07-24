//
//  GTStartModel.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/24.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GTStartModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *appversion;
@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, strong) NSNumber *bverison;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *desc;
@end

@interface GTBannerModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *url;

@end
