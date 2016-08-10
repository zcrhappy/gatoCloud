//
//  GTWarningDetailStateCell.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/23.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTWarningDetailStateCell : UITableViewCell

- (void)setupState:(NSNumber *)state;

@property (nonatomic, copy) void (^clickBtnBlock)(NSNumber *state);

@end
