//
//  GTDeviceListCell.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/13.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "TLSwipeForOptionsCell.h"


@interface GTDeviceListCell : TLSwipeForOptionsCell

- (void)configDeviceName:(NSString *)name status:(NSString *)status;

- (NSString *)deviceName;

@end
