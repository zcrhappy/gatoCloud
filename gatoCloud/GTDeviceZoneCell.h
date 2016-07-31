//
//  GTDeviceZoneCell.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/28.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTDeviceZoneCellDelegate <NSObject>

- (void)clickEditWithModel:(id)model;

/*!
 *  @brief 点击防区切换
 *
 *  @param infoDic key: isOn, model
 */
- (void)switchButtonWithDic:(NSDictionary *)infoDic;

@end


@interface GTDeviceZoneCell : UITableViewCell

@property (nonatomic, weak) id<GTDeviceZoneCellDelegate> delegate;
- (void)setupWithZoneModel:(id)model;

@end
