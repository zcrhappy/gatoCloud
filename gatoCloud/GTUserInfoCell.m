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
@property (nonatomic, weak) IBOutlet UIButton *quitBtn;
@end
@implementation GTUserInfoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
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
            _subTitle.hidden = _arrow.hidden = NO;
            _quitBtn.hidden = YES;
            _subTitle.text = subTitle;
            break;
        }
        case GTUserInfoCellTypeAvatar:
        {
            _avatar.hidden = NO;
            _subTitle.hidden = _arrow.hidden = YES;
            _quitBtn.hidden = YES;
            [_avatar sd_setImageWithURL:[NSURL URLWithString:avatarStr?:@""] placeholderImage:nil];
            break;
        }
        case GTUserInfoCellTypeButton:
        {
            _avatar.hidden = YES;
            _subTitle.hidden = _arrow.hidden = YES;
            _quitBtn.hidden = NO;
            break;
        }
    }
}

- (IBAction)clickQuitAccount:(id)sender {
    
    if(_clickQuitBlock)
        _clickQuitBlock();
}


@end
