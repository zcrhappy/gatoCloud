//
//  UIView+Zone.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/6.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TextFieldWithTag 1001
#define TextViewWithTag 1002
#define rowHeight 55
typedef enum{
    oneLineType = 0,
    twoLineType = 1
}kRowType;

@interface UIView (Zone)

+ (UIView *)rowViewWithTitle:(NSString *)title placeholder:(NSString *)placeholder showSeparatorLine:(BOOL)shouldShowLine type:(kRowType)type;

@end
