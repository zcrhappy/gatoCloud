//
//  GTZoneInfoView.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/27.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTZoneInfoView.h"
#import "GTDeviceZoneModel.h"
@interface GTZoneInfoView()

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *locLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintToTop;

@property (nonatomic, assign) CGFloat height;

@end

@implementation GTZoneInfoView


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithString:kLightBackground];
    _containerView.layer.borderColor = [UIColor grayColor].CGColor;
    _containerView.layer.borderWidth = SINGLE_LINE_WIDTH;
}

- (void)setupWithModel:(GTDeviceZoneModel *)model
{
    static NSString *devicePrefix = @"所属设备：";
    static NSString *contactPrefix = @"紧急联系人：\n";
    static NSString *phonePrefix = @"防区电话：\n";
    static NSString *locPrefix = @"防区地理位置信息：\n";
    
    if(!model.deviceName || [model.zoneName isEmptyString])
        _deviceLabel.text = [devicePrefix stringByAppendingString:@"--"];
    else
        _deviceLabel.text = [devicePrefix stringByAppendingString:model.deviceName];
    
    if(!model.zoneContactor || [model.zoneContactor isEmptyString])
        _contactLabel.text = [contactPrefix stringByAppendingString:@"--"];
    else
        _contactLabel.text = [contactPrefix stringByAppendingString:model.zoneContactor];
    
    if(!model.zonePhone || [model.zonePhone isEmptyString])
        _contactPhoneLabel.text = [phonePrefix stringByAppendingString:@"--"];
    else
        _contactPhoneLabel.text = [phonePrefix stringByAppendingString:model.zonePhone];
    
    if(!model.zoneLoc || [model.zoneLoc isEmptyString])
        _locLabel.text = [locPrefix stringByAppendingString:@"--"];
    else
        _locLabel.text = [locPrefix stringByAppendingString:model.zoneLoc];
    
    if(model.canEdit) {
        _editButton.hidden = NO;
    }
    else {
        _editButton.hidden = YES;
    }
    
    //http://tutuge.me/2015/08/08/autolayout-example-with-masonry2/
    //计算UILabel的preferredMaxLayoutWidth值，多行时必须设置这个值，否则系统无法决定Label的宽度
    _deviceLabel.preferredMaxLayoutWidth = (SCREEN_WIDTH - 20) - 16;
    _contactLabel.preferredMaxLayoutWidth = (SCREEN_WIDTH - 20) * 0.47;
    _contactPhoneLabel.preferredMaxLayoutWidth = (SCREEN_WIDTH - 20) * 0.47;
    _locLabel.preferredMaxLayoutWidth = (SCREEN_WIDTH - 20) - 16;
    
    CGSize size = [_containerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    _height = size.height;
}

- (CGFloat)viewHeight
{
    if(!self.shouldConstraintToTop) {
        NSAssert(self, @"必须要制定此block");
    }
    
    CGFloat topOffset;
    if(self.shouldConstraintToTop()) {
        [_constraintToTop setActive:YES];
        topOffset = 10;
    }
    else {
        [_constraintToTop setActive:NO];
        topOffset = 20;
    }

    return _height + topOffset;
}

- (IBAction)clickEdit:(id)sender {
    if(_clickEditBlock)
        _clickEditBlock();
}

@end
