//
//  GTUserInfoCell.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/18.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTUserInfoCell.h"
@interface GTUserInfoCell()

@property (nonatomic, weak) IBOutlet UIImageView *avatar;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *subTitle;
@property (nonatomic, weak) IBOutlet UIImageView *arrow;
@end
@implementation GTUserInfoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self layoutIfNeeded];
    _avatar.layer.cornerRadius = _avatar.height/2.0;
    _avatar.layer.masksToBounds = YES;
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
            _arrow.hidden = NO;
            _subTitle.hidden = _arrow.hidden = NO;
            _subTitle.text = subTitle;
            break;
        }
        case GTUserInfoCellTypeAvatar:
        {
            _avatar.hidden = NO;
            _arrow.hidden = NO;
            _subTitle.hidden = _arrow.hidden = YES;
            [_avatar sd_setImageWithURL:[NSURL URLWithString:avatarStr?:@""] placeholderImage:[UIImage imageNamed:@"GTDefaultAvatar"]];
            break;
        }
        case GTUserInfoCellTypePlain:
        {
            _avatar.hidden = YES;
            _arrow.hidden = YES;
            _subTitle.hidden = NO;
            _subTitle.text = subTitle;
            break;
        }
    }
}

@end
