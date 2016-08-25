//
//  GTAddDeviceUserTypeCell.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/25.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTAddDeviceUserTypeCell : UITableViewCell

@property (nonatomic, copy) void (^clickCellBlock)(void);

@property (weak, nonatomic) IBOutlet UITextField *userTypeLabel;

@end
