//
//  GTQuitCell.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/18.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTQuitCell.h"

@implementation GTQuitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
}

- (IBAction)clickQuitButton:(id)sender {
    
    if(_clickQuitButton)
        _clickQuitButton();
}


@end
