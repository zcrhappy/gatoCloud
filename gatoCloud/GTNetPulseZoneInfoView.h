//
//  GTNetPulseZoneInfoView.h
//  gatoCloud
//
//  Created by 曾超然 on 2016/9/22.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTDeviceZoneModel.h"

//脉冲，触网，触网脉冲的二级配置界面
@interface GTNetPulseZoneInfoView : UIView

- (void)setupWithModel:(GTDeviceZoneModel *)model;

- (CGFloat)viewHeight;
@property (nonatomic, copy) void (^clickEditBlock)(void);
@end
