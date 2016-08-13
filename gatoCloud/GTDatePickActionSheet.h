//
//  GTPickDateActionSheet.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/13.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTDatePickActionSheet : UIView
+ (instancetype)datePickerWithDate:(NSString *)dateStr;
- (void)show;
- (void)dismiss;

@property (nonatomic, copy) void (^dateChangedBlock)(NSString *date);

@end
