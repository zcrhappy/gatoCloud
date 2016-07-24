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
        _currentPage = @1;
    }
    return self;
}

- (void)refreshDataWithFinishBlock:(GTResultBlock)finshBlock;
{
    [[GTHttpManager shareManager] GTWarningRecordsWithPageNo:_currentPage finishBlock:^(id response, NSError *error) {
       
        if(error == nil) {
            _dataSource = [MTLJSONAdapter modelOfClass:GTWarningRecordCompleteModel.class fromJSONDictionary:[response objectForKey:@"page"] error:nil];
        }
        finshBlock(response, error);
    }];
}

- (void)loadMoreDataWithFinishBlock:(GTResultBlock)finshBlock;
{
    
}

@end
