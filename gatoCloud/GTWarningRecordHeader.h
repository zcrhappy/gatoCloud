//
//  GTWarningRecordHeader.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/22.
//  Copyright © 2016年 Gato. All rights reserved.
//

#ifndef GTWarningRecordHeader_h
#define GTWarningRecordHeader_h

typedef NS_ENUM(NSInteger, kWarningState)
{
    kWarningStateUnsolved = 0,
    kWarningStateSolved = 1,
    kWarningStateMissReport = 2
};
#define kWarningStateString(enum) [@[@"未解决",@"已解决",@"误报"] objectAtIndex:enum]
#define kWarningSteteCount 3

typedef NS_ENUM(NSInteger, kWarningType)
{
    kWarningTypeDev = 0,
    kWarningTypeNet = 1,
    kWarningTypeFence = 2
};
#define kWarningTypeString(enum) [@[@"主机报警",@"通讯报警",@"入侵报警"] objectAtIndex:enum]
#define kWarningTypeCount 3



#endif /* GTWarningRecordHeader_h */
