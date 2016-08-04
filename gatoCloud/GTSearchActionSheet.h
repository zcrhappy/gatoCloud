//
//  GTBaseActionSheet.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/4.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTSearchActionSheet : UIView

+ (instancetype)actionSheetWithSelection:(NSArray *)selection;

@property (nonatomic, copy) void(^didClickBlk)(NSInteger index);
- (void)setupWithSelection:(NSArray *)selection;
- (void)show;
- (void)dismiss;

@end
