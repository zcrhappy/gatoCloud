//
//  GTBottomSelectionView.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/19.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTBottomSelectionView.h"

@implementation GTBottomSelectionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _guardBtn.layer.borderColor = [UIColor colorWithString:@"fefefe"].CGColor;
    _disguardBtn.layer.borderColor = [UIColor colorWithString:@"fefefe"].CGColor;
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
}

- (IBAction)clickGuard:(id)sender {
    if(_clickGuardBlock)
        _clickGuardBlock();
}
- (IBAction)clickDisguard:(id)sender {
    if(_clickDisguardBlock)
        _clickDisguardBlock();
}

@end
