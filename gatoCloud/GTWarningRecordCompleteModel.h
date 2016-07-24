//
//  GTWarningRecordCompleteModel.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/21.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "GTWarningRecordModel.h"

@interface GTWarningRecordCompleteModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *numPerPage;
@property (nonatomic, strong) NSNumber *currentPage;
@property (nonatomic, strong) NSArray *resultList;

+ (NSDictionary *)warningTypeDict;

@end
