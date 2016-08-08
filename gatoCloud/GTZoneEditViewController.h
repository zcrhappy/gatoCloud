//
//  GTZoneEditViewController.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/6.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTDeviceZoneModel.h"
@interface GTZoneEditViewController : UIViewController

- (instancetype)initWithModel:(GTDeviceZoneModel *)model;

@property (nonatomic, copy) void (^editSuccessBlock)(GTDeviceZoneModel *model);

@end
