//
//  GTWarningDetailStateCell.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/23.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTWarningDetailStateCell.h"
#import "GTWarningRecordHeader.h"
@interface GTWarningDetailStateCell()
@property (nonatomic, weak) IBOutlet UIButton *buttonForResolved;
@property (nonatomic, weak) IBOutlet UIButton *buttonForUnresolved;
@property (nonatomic, weak) IBOutlet UIButton *buttonForMisReport;
@end
@implementation GTWarningDetailStateCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_buttonForResolved setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithString:@"ffffff"]] forState:UIControlStateNormal];
    [_buttonForResolved setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithString:@"ebc42f"]] forState:UIControlStateSelected];
    [_buttonForResolved setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_buttonForResolved setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _buttonForResolved.layer.borderColor = [UIColor colorWithString:@"e0e0e0"].CGColor;
    
    [_buttonForUnresolved setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithString:@"ffffff"]] forState:UIControlStateNormal];
    [_buttonForUnresolved setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithString:@"ebc42f"]] forState:UIControlStateSelected];
    [_buttonForUnresolved setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_buttonForUnresolved setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _buttonForUnresolved.layer.borderColor = [UIColor colorWithString:@"e0e0e0"].CGColor;
    
    [_buttonForMisReport setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithString:@"ffffff"]] forState:UIControlStateNormal];
    [_buttonForMisReport setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithString:@"ebc42f"]] forState:UIControlStateSelected];
    [_buttonForMisReport setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_buttonForMisReport setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _buttonForMisReport.layer.borderColor = [UIColor colorWithString:@"e0e0e0"].CGColor;
}

- (void)setupState:(NSNumber *)state
{
    _buttonForResolved.selected = _buttonForUnresolved.selected = _buttonForMisReport.selected = NO;
    _buttonForResolved.layer.borderColor = _buttonForUnresolved.layer.borderColor = _buttonForMisReport.layer.borderColor = [UIColor colorWithString:@"e0e0e0"].CGColor;
    
    NSInteger stateIndex = state.integerValue;
    
    NSString *stateString = kWarningStateString(stateIndex);
    if([stateString isEqualToString:@"已解决"]) {
        _buttonForResolved.selected = YES;
        _buttonForResolved.layer.borderColor = [UIColor clearColor].CGColor;
    }
    else if([stateString isEqualToString:@"未解决"]) {
        _buttonForUnresolved.selected = YES;
        _buttonForUnresolved.layer.borderColor = [UIColor clearColor].CGColor;
    }
    else if([stateString isEqualToString:@"误报"]) {
        _buttonForMisReport.selected = YES;
        _buttonForMisReport.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

- (IBAction)clickButton:(UIButton *)sender {
    
    _buttonForResolved.selected = _buttonForUnresolved.selected = _buttonForMisReport.selected = NO;
    _buttonForResolved.layer.borderColor = _buttonForUnresolved.layer.borderColor = _buttonForMisReport.layer.borderColor = [UIColor colorWithString:@"e0e0e0"].CGColor;
    
    sender.selected = YES;
    sender.layer.borderColor = [UIColor clearColor].CGColor;
    
    if(self.clickBtnBlock){
        self.clickBtnBlock([self curState]);
    }
}



- (NSNumber *)curState
{
    if(_buttonForResolved.selected)
        return @(kWarningStateSolved);
    if(_buttonForUnresolved.selected)
        return @(kWarningStateUnsolved);
    if(_buttonForMisReport.selected)
        return @(kWarningStateMisReport);
    
    return @(-1);
}

@end
