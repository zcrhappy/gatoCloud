//
//  GTUserModel.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/11.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GTUserModel : MTLModel<MTLJSONSerializing>
NSSTRING_COPY *city;
NSSTRING_COPY *country;
NSSTRING_COPY *headimgurl;
NSSTRING_COPY *language;
NSSTRING_COPY *nickname;
NSSTRING_COPY *openid;
NSSTRING_COPY *province;
NSNUMBER_STRONG *sex;
NSSTRING_COPY *unionid;

NSSTRING_COPY *token;
NSSTRING_COPY *userId;
@end
