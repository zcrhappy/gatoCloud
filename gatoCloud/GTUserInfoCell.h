//
//  GTUserInfoCell.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/18.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GTUserInfoCellType){
    GTUserInfoCellTypeAvatar,//右边是头像
    GTUserInfoCellTypeArrow,//右边是箭头，可以配置副标题
};


@interface GTUserInfoCell : UITableViewCell


- (void)setupCellWithType:(GTUserInfoCellType)type
                    title:(NSString *)title
                 subTitle:(NSString *)subTitle
                avatarStr:(NSString *)avatarStr;

@end
