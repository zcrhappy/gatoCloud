//
//  GTTimerQueue.m
//  gatoCloud
//
//  Created by 曾超然 on 16/9/4.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTTimerQueue.h"

@interface GTTimerQueue()

@property (nonatomic, strong) NSMutableArray <GTTimerQueueObj *>* queue;

@end

@implementation GTTimerQueue

- (instancetype)init
{
    if(self = [super init])
    {
        _queue = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    [self clearQueue];
}

- (void)addObject:(GTTimerQueueObj *)obj;
{
    if(obj) {
        [_queue addObject:obj];
        [self activateObj:obj];
    }
}

- (void)removeObjForKey:(NSIndexPath *)key
{
    GTTimerQueueObj *target;
    for (GTTimerQueueObj *obj in _queue) {
        if([obj.key isEqual:key]) {
            target = obj;
            break;
        }
    }
    
    if(target) {
        [_queue removeObject:target];
        [target removeTimer];
    }}

- (GTTimerQueueObj *)createObjWithIndexPath:(NSIndexPath *)indexPath model:(GTDeviceZoneModel *)model;
{
    GTZoneCellTimer *timer = [[GTZoneCellTimer alloc] init];
    [timer setupWithModel:model];
    
    __weak __typeof(self)weakSelf = self;
    [timer setTimerFireBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if(strongSelf.updateCellBlock)
            strongSelf.updateCellBlock(indexPath);
    }];
    [timer setTimerInvaildBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf removeObjForKey:indexPath];
        
        if(strongSelf.updateCellBlock)
            strongSelf.updateCellBlock(indexPath);
    }];
    
    GTTimerQueueObj *obj = [[GTTimerQueueObj alloc] init];
    obj.key = indexPath;
    obj.timer = timer;
    [self addObject:obj];
    
    return obj;
}

- (void)clearQueue
{
    for (GTTimerQueueObj *obj in _queue) {
        [obj removeTimer];
    }
    [_queue removeAllObjects];
}

- (void)activateObj:(GTTimerQueueObj *)obj
{
    GTZoneCellTimer *timer = obj.timer;
    [timer startTimer];
}


@end



@implementation GTTimerQueueObj

- (instancetype)init
{
    if(self = [super init]) {
        
    }
    return self;
}

- (void)timerFire;
{
    
}
- (void)timerInvaild;
{
    
}

- (void)removeTimer;
{
    [_timer stopTimer];
}


@end
