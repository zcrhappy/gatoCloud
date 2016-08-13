//
//  GTDatePickPanel.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/13.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GTDatePickPanelItem;
@interface GTDatePickPanel : UIView

- (instancetype)init;

@property (nonatomic, strong) GTDatePickPanelItem *leftItem;
@property (nonatomic, strong) GTDatePickPanelItem *rightItem;
@property (nonatomic, copy) void(^selectBeginDateBlock)(NSString *oriDate);
@property (nonatomic, copy) void(^selectEndDateBlock)(NSString *oriDate);
@end

@interface GTDatePickPanelItem : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@end