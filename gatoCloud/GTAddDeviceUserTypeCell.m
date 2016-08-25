//
//  GTAddDeviceUserTypeCell.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/25.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTAddDeviceUserTypeCell.h"

@interface GTAddDeviceUserTypeCell()

@end

@implementation GTAddDeviceUserTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction:(id)sender
{
    if(_clickCellBlock)
        _clickCellBlock();
}
@end
