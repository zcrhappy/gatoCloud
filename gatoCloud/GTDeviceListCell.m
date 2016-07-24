//
//  GTDeviceListCell.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/13.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTDeviceListCell.h"
#import "GTDeviceCellGestureManager.h"
@interface GTDeviceListCell()
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *statusLabel;

@end
@implementation GTDeviceListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}


- (void)configUI
{
    _nameLabel = [[UILabel alloc] init];
    _statusLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_statusLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)configDeviceName:(NSString *)name status:(NSString *)status
{
    _nameLabel.text = name;
    _statusLabel.text = status;
}

- (NSString *)deviceName;
{
    return _nameLabel.text;
}


//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    NSLog(@"---->hitText开始，当前cell:%@",_nameLabel.text);
//    if(![GTDeviceCellGestureManager sharedInstance].isMenuShown) {
//        NSLog(@"当前无菜单:%@",_nameLabel.text);
//        return [super hitTest:point withEvent:event];
//    }
//    //否则有菜单时
//    if(self.isMenuShowed) {
//        
//        CGPoint btnPointInCell = [self.scrollViewButtonView convertPoint:point fromView:self];
//        if([self.scrollViewButtonView pointInside:btnPointInCell withEvent:event]) {
//            //点击的是按钮区域
//            NSLog(@"本cell有菜单，选中按钮Cell:%@",_nameLabel.text);
//            return self.scrollViewButtonView;
//        }
//        else {
//            [[GTDeviceCellGestureManager sharedInstance] dismissMenu];
//            NSLog(@"本cell有菜单，选中按钮之外Cell:%@",_nameLabel.text);
//            return [super hitTest:point withEvent:event];
//        }
//    }
//    else {
//        [[GTDeviceCellGestureManager sharedInstance] dismissMenu];
//        NSLog(@"本cell无菜单，Cell:%@",_nameLabel.text);
//        return [super hitTest:point withEvent:event];
//    }
//}




@end
