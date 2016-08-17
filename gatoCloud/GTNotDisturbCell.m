//
//  GTNotDisturbCell.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/17.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTNotDisturbCell.h"

@implementation GTNotDisturbCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setUpWithTitle:(NSString *)title selected:(BOOL)selected
{
    _label.text = title;
    _icon.hidden = !selected;
}

@end
