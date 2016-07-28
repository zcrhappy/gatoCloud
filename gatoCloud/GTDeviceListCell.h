//
//  GTDeviceListCell.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/13.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "TLSwipeForOptionsCell.h"

@protocol GRDeviceCellDelegate <NSObject>

- (void)didSelectFunctionItemWithIndex:(NSNumber *)index;

@optional
- (void)didClickCell;

@end


@interface GTDeviceListCell : UITableViewCell

@property (nonatomic, weak) id<GRDeviceCellDelegate> delegate;

- (void)configZoneName:(NSString *)zoneName zoneCount:(NSNumber *)zoneCount state:(NSString *)state online:(NSString *)online;

- (void)setupWithExpanded:(BOOL)expanded;

//- (NSString *)deviceName;

@end
