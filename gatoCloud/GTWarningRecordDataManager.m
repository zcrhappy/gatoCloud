//
//  GTWarningRecordDataManager.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/20.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTWarningRecordDataManager.h"

@interface GTWarningRecordDataManager()
@property (nonatomic, strong) NSNumber *numPerPage;
@property (nonatomic, strong) NSNumber *currentPage;
@end

@implementation GTWarningRecordDataManager

- (instancetype)init
{
    if(self = [super init]) {
    
    }
    return self;
}

- (void)refreshDataWithFinishBlock:(GTResultBlock)finshBlock;
{
    [[GTHttpManager shareManager] GTWarningRecordsWithPageNo:@1 finishBlock:^(id response, NSError *error) {
        
        if(error == nil) {
            _dataSource = [MTLJSONAdapter modelOfClass:GTWarningRecordCompleteModel.class fromJSONDictionary:[response objectForKey:@"page"] error:nil];
            _hasMore = _dataSource.hasMore;
        }
        finshBlock(response, error);
    }];
}

- (void)loadMoreDataWithFinishBlock:(GTResultBlock)finshBlock;
{
    [[GTHttpManager shareManager] GTWarningRecordsWithPageNo:@(_dataSource.currentPage.integerValue+1) finishBlock:^(id response, NSError *error) {
        
        if(error == nil) {
            GTWarningRecordCompleteModel *addDataSource = [MTLJSONAdapter modelOfClass:GTWarningRecordCompleteModel.class fromJSONDictionary:[response objectForKey:@"page"] error:nil];
            _hasMore = addDataSource.hasMore;
            _dataSource.currentPage = addDataSource.currentPage;
            _dataSource.totalPages = addDataSource.totalPages;
            _dataSource.resultList = [NSMutableArray arrayWithArray:[_dataSource.resultList arrayByAddingObjectsFromArray:addDataSource.resultList]];
        }
        finshBlock(response, error);
    }];
}

@end
