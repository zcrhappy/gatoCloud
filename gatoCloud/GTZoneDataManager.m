//
//  GTZoneDataManager.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/14.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTZoneDataManager.h"
#import "GTDeviceZoneModel2.h"
#import "GTDeviceZoneModel.h"
@interface GTZoneDataManager()

@property (nonatomic, assign) kListType type;
//@property (nonatomic, strong) NSNumber *numPerPage;
@property (nonatomic, strong) NSNumber *totalPages;
@property (nonatomic, strong) NSNumber *currentPage;

@end

@implementation GTZoneDataManager

- (instancetype)initWithListType:(kListType)type;
{
    if(self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)refreshDataWithFinishBlock:(GTResultBlock)finishBlock
{
    switch (_type) {
        case kListTypeAllZone:
            [self refreshListWithFinishBlock:finishBlock];
            break;
        case kListTypeViaZoneName:
            [self refreshListWithZoneName:_searchKeyword finishBlock:finishBlock];
            break;
        case kListTypeViaDeviceNo:
            [self refreshListWithDeviceNo:_searchKeyword finishBlock:finishBlock];
            break;
        case kListTypeViaDeviceName:
            [self refreshListWithDeviceName:_searchKeyword finishBlock:finishBlock];
            break;
    }
}


- (void)loadMoreWithFinishBlock:(GTResultBlock)finishBlock
{
    switch (_type) {
        case kListTypeAllZone:
            [self loadMoreListWithFinishBlock:finishBlock];
            break;
        case kListTypeViaZoneName:
            [self loadMoreViaZoneNameWithFinishBlock:finishBlock];
            break;
        case kListTypeViaDeviceNo:
            break;
        case kListTypeViaDeviceName:
            [self loadMoreViaDeviceNameWithFinishBlock:finishBlock];
            break;
    }
}

#pragma mark -
- (void)loadMoreListWithFinishBlock:(GTResultBlock)finishBlock {
    
    [[GTHttpManager shareManager] GTDeviceZoneListWithPn:@(self.currentPage.integerValue + 1) finishBlock:^(id response, NSError *error) {
        
        if(error == nil) {
            NSArray *array = [[response objectForKey:@"page"] objectForKey:@"resultList"];
            _currentPage = [[response objectForKey:@"page"] objectForKey:@"currentPage"];
            _totalPages = [[response objectForKey:@"page"] objectForKey:@"totalPages"];
            _hasMore = [self checkDataHasMore];
            
            NSArray *oldModelArr = [MTLJSONAdapter modelsOfClass:GTDeviceZoneModel2.class fromJSONArray:array error:nil];
            NSArray *addModelArr = [NSMutableArray arrayWithArray:[GTDeviceZoneModel transformFromArray:oldModelArr]];
            [_zoneModelsArray addObjectsFromArray:addModelArr];
        }
        finishBlock(response, error);
    }];
}

- (void)loadMoreViaDeviceNameWithFinishBlock:(GTResultBlock)finishBlock
{
    [[GTHttpManager shareManager] GTDeviceZoneWithDeviceName:_searchKeyword pn:@(_currentPage.integerValue + 1) finishBlock:^(id response, NSError *error) {
        
        if(error == nil) {
            NSArray *array = [[response objectForKey:@"page"] objectForKey:@"resultList"];
            _currentPage = [[response objectForKey:@"page"] objectForKey:@"currentPage"];
            _totalPages = [[response objectForKey:@"page"] objectForKey:@"totalPages"];
            _hasMore = [self checkDataHasMore];
            
            NSArray *oldModelArr = [MTLJSONAdapter modelsOfClass:GTDeviceZoneModel2.class fromJSONArray:array error:nil];
            NSArray *addModelArr = [NSMutableArray arrayWithArray:[GTDeviceZoneModel transformFromArray:oldModelArr]];
            [_zoneModelsArray addObjectsFromArray:addModelArr];
        }
        finishBlock(response, error);
    }];
}

- (void)loadMoreViaZoneNameWithFinishBlock:(GTResultBlock)finishBlock
{
    [[GTHttpManager shareManager] GTDeviceZoneListWithZoneName:_searchKeyword pn:@(_currentPage.integerValue + 1) finishBlock:^(id response, NSError *error) {
        
        if(error == nil) {
            NSArray *array = [[response objectForKey:@"page"] objectForKey:@"resultList"];
            _currentPage = [[response objectForKey:@"page"] objectForKey:@"currentPage"];
            _totalPages = [[response objectForKey:@"page"] objectForKey:@"totalPages"];
            _hasMore = [self checkDataHasMore];
            
            NSArray *oldModelArr = [MTLJSONAdapter modelsOfClass:GTDeviceZoneModel2.class fromJSONArray:array error:nil];
            NSArray *addModelArr = [NSMutableArray arrayWithArray:[GTDeviceZoneModel transformFromArray:oldModelArr]];
            [_zoneModelsArray addObjectsFromArray:addModelArr];
        }
        finishBlock(response, error);
    }];

}
- (void)refreshListWithFinishBlock:(GTResultBlock)finishBlock
{
    [[GTHttpManager shareManager] GTDeviceZoneListWithPn:@1 finishBlock:^(id response, NSError *error) {

        if(error == nil) {
            NSArray *array = [[response objectForKey:@"page"] objectForKey:@"resultList"];
            self.currentPage = [[response objectForKey:@"page"] objectForKey:@"currentPage"];
            self.hasMore = [self checkDataHasMore];
            
            NSArray *oldModelArr = [MTLJSONAdapter modelsOfClass:GTDeviceZoneModel2.class fromJSONArray:array error:nil];
            _zoneModelsArray = [NSMutableArray arrayWithArray:[GTDeviceZoneModel transformFromArray:oldModelArr]];

        }
        finishBlock(response, error);
    }];
}

- (void)refreshListWithDeviceNo:(NSString *)deviceNo finishBlock:(GTResultBlock)finishBlock
{
    [[GTHttpManager shareManager] GTDeviceZoneWithDeviceNo:deviceNo finishBlock:^(id response, NSError *error) {
        
        if(error == nil) {
            NSArray *resData = [response objectForKey:@"list"];
            self.hasMore = NO;
            
            NSArray *array = [MTLJSONAdapter modelsOfClass:GTDeviceZoneModel.class fromJSONArray:resData error:nil];
            _zoneModelsArray = [NSMutableArray arrayWithArray:array];
        }
        finishBlock(response, error);
    }];
}

- (void)refreshListWithDeviceName:(NSString *)deviceName finishBlock:(GTResultBlock)finishBlock
{
    [[GTHttpManager shareManager] GTDeviceZoneWithDeviceName:deviceName pn:@1 finishBlock:^(id response, NSError *error) {
        
        if(error == nil) {
            NSArray *array = [[response objectForKey:@"page"] objectForKey:@"resultList"];
            self.currentPage = [[response objectForKey:@"page"] objectForKey:@"currentPage"];
            self.hasMore = [self checkDataHasMore];
            
            NSArray *oldModelArr = [MTLJSONAdapter modelsOfClass:GTDeviceZoneModel2.class fromJSONArray:array error:nil];
            _zoneModelsArray = [NSMutableArray arrayWithArray:[GTDeviceZoneModel transformFromArray:oldModelArr]];
        }
        finishBlock(response, error);
    }];
}

- (void)refreshListWithZoneName:(NSString *)zoneName finishBlock:(GTResultBlock)finishBlock
{
    [[GTHttpManager shareManager] GTDeviceZoneListWithZoneName:zoneName pn:@1 finishBlock:^(id response, NSError *error) {
        
        if(error == nil) {
            NSArray *array = [[response objectForKey:@"page"] objectForKey:@"resultList"];
            self.currentPage = [[response objectForKey:@"page"] objectForKey:@"currentPage"];
            self.hasMore = [self checkDataHasMore];
            
            NSArray *oldModelArr = [MTLJSONAdapter modelsOfClass:GTDeviceZoneModel2.class fromJSONArray:array error:nil];
            _zoneModelsArray = [NSMutableArray arrayWithArray:[GTDeviceZoneModel transformFromArray:oldModelArr]];
        }
        finishBlock(response, error);
    }];
}

- (BOOL)checkDataHasMore
{
    if(self.currentPage.integerValue < self.totalPages.integerValue)
        return YES;
    return NO;
}

- (BOOL)isEmpty
{
    if(self.zoneModelsArray.count == 0)
        return YES;
    return NO;
}


@end
