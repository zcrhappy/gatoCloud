//
//  GTWarningRecordCell.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/20.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTWarningRecordCell.h"
#import "GTWarningRecordCompleteModel.h"
#import "GTWarningRecordHeader.h"
@interface GTWarningRecordCell()

@property (nonatomic, weak) IBOutlet UILabel *deviceLabel;//设备名称
@property (nonatomic, weak) IBOutlet UILabel *warntypeLabel;//报警类型
@property (nonatomic, weak) IBOutlet UILabel *warnTime;//报警时间
@property (nonatomic, weak) IBOutlet UIButton *status;
@property (nonatomic, weak) IBOutlet UIImageView *statusIcon;


@end

@implementation GTWarningRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setupWithModel:(GTWarningRecordCompleteModel *)completeModel indexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    
    GTWarningRecordModel *model = [completeModel.resultList objectAtIndex:index];
    
    
    [self setupDeviceName:[NSString stringWithFormat:@"%@:%@",model.devicename,model.zonename]
          warningWithType:model.WARNTYPE
                    state:model.ISTATE
                     time:model.WARNDATE];
}


- (void)setupDeviceName:(NSString *)deviceName
        warningWithType:(NSString *)type
                  state:(NSNumber *)state
                   time:(NSString *)time
{
    _deviceLabel.text = deviceName;
    _warnTime.text = time;

    NSDictionary *warningTypeDict = [GTWarningRecordCompleteModel warningTypeDict];
    _warntypeLabel.text = [warningTypeDict objectForKey:type];
    
    kWarningState warnStateIndex = state.integerValue;
    
    if(kWarningStateUnsolved == warnStateIndex) {
        UIColor *buttonColor = [UIColor colorWithString:@"f1d66f"];
        _status.layer.borderColor = buttonColor.CGColor;
        [_status setTitleColor:buttonColor forState:UIControlStateNormal];
    }
    else if(kWarningStateSolved == warnStateIndex){
        UIColor *buttonColor = [UIColor colorWithString:@"1bbc9b"];
        _status.layer.borderColor = buttonColor.CGColor;
        [_status setTitleColor:buttonColor forState:UIControlStateNormal];
    }
    else if(kWarningStateMisReport == warnStateIndex) {
        UIColor *buttonColor = [UIColor redColor];
        _status.layer.borderColor = buttonColor.CGColor;
        [_status setTitleColor:buttonColor forState:UIControlStateNormal];
    }
    _statusIcon.image = [UIImage imageNamed:kWarningStateIconWithIndex(warnStateIndex)];
    
    if(warnStateIndex < kWarningSteteCount) {
        [_status setTitle:kWarningStateString(warnStateIndex) forState:UIControlStateNormal];
    }
}

@end
