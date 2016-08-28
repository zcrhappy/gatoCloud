//
//  GTDoneButtonCell.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/28.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTDoneButtonCell.h"

@implementation GTDoneButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
}

- (IBAction)clickDone:(id)sender {
    
    if(_clickDoneBlock)
        _clickDoneBlock();
}

@end
