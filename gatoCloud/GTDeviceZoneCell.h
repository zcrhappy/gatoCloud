//
//  GTDeviceZoneCell.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/28.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, kSwitchState) {
    kSwitchStateDisguarded = 1,
    kSwitchStateGuarded = 2
};

@protocol GTDeviceZoneCellDelegate <NSObject>

- (void)clickEditWithModel:(id)model;

/*!
 *  @brief 点击防区切换
 *
 *  @param infoDic key: isOn, model
 */
- (void)switchButtonWithDic:(NSDictionary *)infoDic;

@optional

- (void)clickStainEditWithModel:(id)model;
- (void)clickNetPulseEditWithModel:(id)model;

@end


@interface GTDeviceZoneCell : UITableViewCell

@property (nonatomic, weak) id<GTDeviceZoneCellDelegate> delegate;
- (void)updateWithModel:(id)model;
@end


@interface GTPlaceholderView: UIView

@end

@interface GTLine:UIView

@end

@interface GTUpContainer:UIView

@end

@interface GTBottomContainer:UIView

@end

