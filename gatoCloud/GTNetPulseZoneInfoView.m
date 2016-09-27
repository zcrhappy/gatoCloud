//
//  GTNetPulseZoneInfoView.m
//  gatoCloud
//
//  Created by 曾超然 on 2016/9/22.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTNetPulseZoneInfoView.h"

@interface GTNetPulseZoneInfoView()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeLineConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoLineConstaint;

@property (nonatomic, assign) CGFloat height;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@end

@implementation GTNetPulseZoneInfoView
@synthesize firstLabel, secondLabel, thirdLabel;
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithString:kLightBackground];
    _containerView.layer.borderColor = [UIColor colorWithString:kBorderColor].CGColor;
    _containerView.layer.borderWidth = SINGLE_LINE_WIDTH;
    
    [self configUI];
}

- (void)configUI
{
    
}

- (void)setupWithModel:(GTDeviceZoneModel *)model
{
    if([model isZoneType:GTZoneTypePulse]) {
        firstLabel.text = [NSString stringWithFormat:@"工作模式：%@", [model getNetPulseValue:GTNetPulseValueMode]];
        secondLabel.text = [NSString stringWithFormat:@"电压：%@",[model getNetPulseValue:GTNetPulseValueVoltage]];
        thirdLabel.hidden = YES;
        _twoLineConstaint.active = YES;
        _threeLineConstraint.active = NO;
    }
    else if ([model isZoneType:GTZoneTypeNetPulse]) {
        firstLabel.text = [NSString stringWithFormat:@"工作模式：%@", [model getNetPulseValue:GTNetPulseValueMode]];
        secondLabel.text = [NSString stringWithFormat:@"电压：%@",[model getNetPulseValue:GTNetPulseValueVoltage]];
        thirdLabel.text = [NSString stringWithFormat:@"灵敏度：%@",[model getNetPulseValue:GTNetPulseValueSensitive]];
        thirdLabel.hidden = NO;
        _twoLineConstaint.active = NO;
        _threeLineConstraint.active = YES;
    }
    
    firstLabel.preferredMaxLayoutWidth = (SCREEN_WIDTH - 20) - 16;
    secondLabel.preferredMaxLayoutWidth = (SCREEN_WIDTH - 20) - 16;
    thirdLabel.preferredMaxLayoutWidth = (SCREEN_WIDTH - 20) - 16;
    CGSize size = [_containerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    _height = size.height;
}

- (CGFloat)viewHeight
{
    return _height + 20;
}

- (IBAction)clickEdit:(id)sender {
    if(_clickEditBlock)
        _clickEditBlock();
}

@end
