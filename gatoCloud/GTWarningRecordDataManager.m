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
@property (nonatomic, assign) kSearchType searchType;
//search keyword
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *zoneName;
@property (nonatomic, copy) NSString *warnType;
@property (nonatomic, copy) NSString *beginDate;
@property (nonatomic, copy) NSString *endDate;
@end

@implementation GTWarningRecordDataManager

- (instancetype)init
{
    if(self = [super init]) {
        _searchType = kSearchTypeNone;
    }
    return self;
}

- (instancetype)initWithSearchType:(kSearchType)searchType
{
    if(self = [super init]) {
        _searchType = searchType;
    }
    return self;
}

- (void)refreshDataViaSearchWithFinishBlock:(GTResultBlock)finshBlock;
{
    [[GTHttpManager shareManager] GTSearchWarningRecordsWithSearchType:@(_searchType) beginDate:_beginDate endDate:_endDate warnType:_warnType deviceName:_deviceName zoneName:_zoneName pn:@1 finishBlock:^(id response, NSError *error) {
       
        if(error == nil) {
            _dataSource = [MTLJSONAdapter modelOfClass:GTWarningRecordCompleteModel.class fromJSONDictionary:[response objectForKey:@"page"] error:nil];
            _hasMore = _dataSource.hasMore;
        }
        finshBlock(response, error);
    }];
}

- (void)loadMoreDataViaSearchWithFinishBlock:(GTResultBlock)finshBlock;
{
    [[GTHttpManager shareManager] GTSearchWarningRecordsWithSearchType:@(_searchType) beginDate:_beginDate endDate:_endDate warnType:_warnType deviceName:_deviceName zoneName:_zoneName pn:@(_dataSource.currentPage.integerValue+1) finishBlock:^(id response, NSError *error) {
    
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


- (void)refreshDataWithFinishBlock:(GTResultBlock)finshBlock;
{
    NSNumber *istate = nil;
    if(_searchType == kSearchTypeWithUnhandled)
        istate = @0;
    
    if(_searchType != kSearchTypeNone &&
       _searchType != kSearchTypeWithUnhandled) {
        [self transformSearchKeyword];
        [self refreshDataViaSearchWithFinishBlock:finshBlock];
    }
    else {
        [[GTHttpManager shareManager] GTWarningRecordsWithPageNo:@1 istate:istate finishBlock:^(id response, NSError *error) {
            if(error == nil) {
                _dataSource = [MTLJSONAdapter modelOfClass:GTWarningRecordCompleteModel.class fromJSONDictionary:[response objectForKey:@"page"] error:nil];
                _hasMore = _dataSource.hasMore;
            }
            finshBlock(response, error);
        }];
    }
}

- (void)loadMoreDataWithFinishBlock:(GTResultBlock)finshBlock;
{
    NSNumber *istate = nil;
    if(_searchType == kSearchTypeWithUnhandled)
        istate = @0;
    
    if(_searchType != kSearchTypeNone &&
       _searchType != kSearchTypeWithUnhandled) {
        [self transformSearchKeyword];
        [self loadMoreDataViaSearchWithFinishBlock:finshBlock];
    }
    else {
        [[GTHttpManager shareManager] GTWarningRecordsWithPageNo:@(_dataSource.currentPage.integerValue+1) istate:istate finishBlock:^(id response, NSError *error) {
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
}

- (BOOL)transformSearchKeyword
{
    BOOL keywordNotNull = NO;
    
    switch (_searchType) {
        case kSearchTypeViaZoneName:
            _zoneName = [self searchKeyword];
            keywordNotNull = ![_zoneName isEqualToString:@""];
            break;
        case kSearchTypeViaDeviceName:
            _deviceName = [self searchKeyword];
            keywordNotNull = ![_deviceName isEqualToString:@""];
            break;
        case kSearchTypeViaWarningType:
            _warnType = [self serachWarningType];
            keywordNotNull = ![_warnType isEqualToString:@""];
            break;
        case kSearchTypeViaTime:
            _beginDate = [self searchBeginDate];
            _endDate = [self searchEndDate];
            keywordNotNull = (![_beginDate isEqualToString:@""] && ![_endDate isEqualToString:@""]);
            break;
        default:
            break;
    }
    
    return keywordNotNull;
}

- (NSString *)searchKeyword
{
    return [_searchKeywordDict objectForKey:keyForSearchKeyword];
}

- (NSString *)serachWarningType
{
    __block NSString *keyword = @"";
    
    NSDictionary *keywordDic = [GTWarningRecordCompleteModel warningTypeDict];
    
    NSString *showStr= [_searchKeywordDict objectForKey:keyForSearchWarningType];
    NSDictionary *dic = @{ devStr:@"主机报警", netStr:@"通讯报警", fenceStr:@"入侵报警", fireStr:@"火警"};
    
    NSString *normalStr = [dic objectForKey:showStr];

    [keywordDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if([obj isEqualToString:normalStr]){
            keyword = key;
            *stop = YES;
        }
    }];
    
    return keyword;
}

- (NSString *)searchBeginDate
{
    return [_searchKeywordDict objectForKey:keyForDateBegin];
}

- (NSString *)searchEndDate
{
    return [_searchKeywordDict objectForKey:keyForDateEnd];
}
@end
