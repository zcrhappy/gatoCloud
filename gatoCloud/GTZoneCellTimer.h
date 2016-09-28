//
//  GTZoneCellTimer.h
//  gatoCloud
//
//  Created by 曾超然 on 16/9/2.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTDeviceZoneModel.h"

@interface GTZoneCellTimer : NSObject

@property (nonatomic, copy) void (^timerFireBlock)(void);
@property (nonatomic, copy) void (^timerInvaildBlock)(void);

- (void)setupWithModel:(GTDeviceZoneModel *)model;

- (void)startTimer;
- (void)stopTimer;
@end
