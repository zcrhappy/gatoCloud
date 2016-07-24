//
//  GTUserInfoCell.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/18.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTUserInfoCell.h"
@interface GTUserInfoCell()

@property (nonatomic, strong) IBOutlet UIImageView *avatar;
@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *subTitle;
@property (nonatomic, strong) IBOutlet UIImageView *arrow;

@end
@implementation GTUserInfoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (void)setupCellWithType:(GTUserInfoCellType)type
                    title:(NSString *)title
                 subTitle:(NSString *)subTitle
                avatarStr:(NSString *)avatarStr
{
    
    _title.text = title;
    
    switch (type) {
        case GTUserInfoCellTypeArrow:
        {
            _avatar.hidden = YES;
            _subTitle.hidden = _arrow.hidden = NO;
            _subTitle.text = subTitle;
            break;
        }
        case GTUserInfoCellTypeAvatar:
        {
            _avatar.hidden = NO;
            _subTitle.hidden = _arrow.hidden = YES;
            [_avatar sd_setImageWithURL:[NSURL URLWithString:avatarStr?:@""] placeholderImage:nil];
            break;
        }
    }
}



@end