//
//  GTZoneNetPulseEditViewController.h
//  gatoCloud
//
//  Created by 曾超然 on 2016/9/26.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTDeviceZoneModel.h"
@interface GTZoneNetPulseEditViewController : UIViewController

- (instancetype)initWithModel:(id)model;

@property (nonatomic, copy) void (^editSuccessBlock)(GTDeviceZoneModel *model);

@end
