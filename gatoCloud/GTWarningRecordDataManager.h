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
@interface GTWarningRecordDataManager : NSObject


@property (nonatomic, strong) GTWarningRecordCompleteModel *dataSource;
@property (nonatomic, assign) BOOL hasMore;

- (void)refreshDataWithFinishBlock:(GTResultBlock)finshBlock;

- (void)loadMoreDataWithFinishBlock:(GTResultBlock)finshBlock;


@end
