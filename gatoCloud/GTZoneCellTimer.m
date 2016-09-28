//
//  GTZoneCellTimer.m
//  gatoCloud
//
//  Created by 曾超然 on 16/9/2.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTZoneCellTimer.h"

typedef NS_ENUM(NSInteger, kSwitchState) {
    kSwitchStateDisguarded = 1,
    kSwitchStateGuarded = 2
};

@interface GTZoneCellTimer()
@property (nonatomic, strong) GTDeviceZoneModel *changedModel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) NSString *iState;
//@property (nonatomic, assign) NSInteger loopCount;
//@property (nonatomic, assign) BOOL isOn;
@end

@implementation GTZoneCellTimer

- (void)setupWithModel:(GTDeviceZoneModel *)model
{
    _changedModel = model;
    _changedModel.loopCount = 5;
}

- (void)startTimer
{
    if(_changedModel.isOn == YES)
        _iState = @"2";
    else
        _iState = @"1";
    
    [[GTHttpManager shareManager] GTDeviceZoneChangeDefenceWithState:_iState zoneNo:_changedModel.zoneNo finishBlock:^(id response, NSError *error) {
        if(error == nil) {
            
            _timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(innerTimerFire) userInfo:nil repeats:YES];
            [_timer fire];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        }
    }];
}

- (void)innerTimerFire;
{
    if(_changedModel.loopCount < 0) {
        [self timerInvaild];
        return;
    }
    else
        _changedModel.loopCount--;


    if(_timerFireBlock)
        _timerFireBlock();
    
    [self action];
}

- (void)action
{
    NSLog(@"开始第%d轮询,%@",5 - (int)_changedModel.loopCount ,_changedModel);
    
    __block BOOL querySuccess = NO;
    
    [[GTHttpManager shareManager] GTDeviceZoneQueryWithZoneNo:_changedModel.zoneNo finishBlock:^(id response, NSError *error) {
        if(error == nil) {
            NSArray <GTDeviceZoneModel *>* curModelArray= [MTLJSONAdapter modelsOfClass:GTDeviceZoneModel.class fromJSONArray:[response objectForKey:@"list"] error:nil];
            GTDeviceZoneModel *curModel = [curModelArray firstObject];
            
            if([curModel.zoneNo isEqualToString:_changedModel.zoneNo])
            {
                if((_iState.integerValue == kSwitchStateGuarded && curModel.zoneState.integerValue == kZoneStateGuarded)||
                   (_iState.integerValue == kSwitchStateDisguarded && curModel.zoneState.integerValue == kZoneStateDisguarded))
                {
                    querySuccess = YES;
                }
                else {
                    querySuccess = NO;
                }
            }
            
            if(querySuccess) {
                [self timerInvaild];
                if(_iState.integerValue == kSwitchStateDisguarded) {//撤防成功
                    _changedModel.zoneState = @"3";
                }
                else {//布防成功
                    _changedModel.zoneState = @"4";
                }
                //刷新界面
                [MBProgressHUD showText:@"操作成功" inView:[UIView gt_keyWindow]];
                [self timerInvaild];
            }
            else if(_changedModel.loopCount == 0){
                [MBProgressHUD showText:@"操作失败" inView:[UIView gt_keyWindow]];
                [self timerInvaild];
            }
        }
    }];
}

- (void)timerInvaild;
{
    [_timer invalidate];
    _timer = nil;
    _changedModel.loopCount = 0;
    
    if(_timerInvaildBlock)
        _timerInvaildBlock();
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}


@end
