//
//  GTDeviceListCell.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/13.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTDeviceListCell.h"
@interface GTDeviceListCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
@implementation GTDeviceListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configUI];
}

- (void)configUI
{
    [self.scrollViewContentView addSubview:_nameLabel];
    [self.scrollViewContentView addSubview:_statusLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(self.scrollViewContentView);
    }];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right).offset(15);
        make.centerY.equalTo(self.scrollViewContentView);
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
@end
