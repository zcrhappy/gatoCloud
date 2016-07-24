//
//  GTWarningDetailCommonCell.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/23.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTWarningDetailCommonCell.h"

@interface GTWarningDetailCommonCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;

@end

@implementation GTWarningDetailCommonCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _titleLabel.text = @"";
    _contentLabel.text = @"";
}

- (void)setupCommonCellWithTitle:(NSString *)title content:(NSString *)content
{
    _titleLabel.text = title;
    
    if(content == nil || [content isEmptyString]) {
        _contentLabel.text = @"--";
    }
    else {
        _contentLabel.text = content;
    }
}

@end
