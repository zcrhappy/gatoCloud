//
//  GTWarningRecordDataManager.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/20.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTHttpManager.h"
#import "GTWarningRecordCompleteModel.h"

#define keyForSearchKeyword @"keyForSearchKeyword"
#define keyForSearchWarningType @"keyForSearchWarningType"
#define keyForDateBegin @"keyForDateBegin"
#define keyForDateEnd @"keyForDateEnd"

typedef NS_ENUM(NSInteger, kSearchType) {
    kSearchTypeNone           = -1,
    kSearchTypeViaTime        = 0,
    kSearchTypeViaWarningType = 1,
    kSearchTypeViaDeviceName  = 2,
    kSearchTypeViaZoneName    = 3,
    kSearchTypeWithUnhandled  = 99,//未处理的报警记录
};

#define fenceStr @"入侵报警"
#define netStr   @"通讯异常"
#define devStr   @"设备故障报警"
#define fireStr  @"火警"

@interface GTWarningRecordDataManager : NSObject

@property (nonatomic, strong) GTWarningRecordCompleteModel *dataSource;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) BOOL isEmpty;
@property (nonatomic, strong) NSMutableDictionary *searchKeywordDict;

- (void)refreshDataWithFinishBlock:(GTResultBlock)finshBlock;

- (void)loadMoreDataWithFinishBlock:(GTResultBlock)finshBlock;

- (instancetype)init;
- (instancetype)initWithSearchType:(kSearchType)searchType;
@end
