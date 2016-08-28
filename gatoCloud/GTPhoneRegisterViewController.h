//
//  GTPhoneLoginViewController.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/15.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, kType){
    kTypeRegister,
    kTypeForgetPwd,
};

@interface GTPhoneRegisterViewController : UIViewController

@property (nonatomic, assign) kType enterType;

@end
