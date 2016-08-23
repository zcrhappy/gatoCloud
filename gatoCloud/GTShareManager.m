//
//  GTShareManager.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/23.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTShareManager.h"
#import "WXApi.h"
@implementation GTShareManager

+ (void)ShareToWXFrindWithText:(NSString *)text;
{
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text = text;
    req.bText = YES;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}
@end
