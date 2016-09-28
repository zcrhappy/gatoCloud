//
//  GTTimerQueue.h
//  gatoCloud
//
//  Created by 曾超然 on 16/9/4.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTZoneCellTimer.h"
#import "GTDeviceZoneModel.h"

@interface GTTimerQueueObj : NSObject

@property (nonatomic, strong) NSIndexPath *key;
@property (nonatomic, strong) GTZoneCellTimer *timer;
- (void)removeTimer;
@end


@interface GTTimerQueue : NSObject

- (GTTimerQueueObj *)createObjWithIndexPath:(NSIndexPath *)indexPath model:(GTDeviceZoneModel *)model;
- (void)clearQueue;

@property (nonatomic, strong) void (^updateCellBlock)(NSIndexPath *indexPath);

@end
