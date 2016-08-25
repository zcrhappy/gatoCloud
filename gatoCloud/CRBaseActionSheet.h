//
//  CRBaseActionSheet.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/25.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum CRActionSheetStyle: NSInteger {
    CRActionSheetStyleActionSheet = 0,
    CRActionSheetStyleAlert
} CRActionSheetStyle;

@interface CRBaseActionSheet : UIControl
{
    
@protected
    UIView *_contentView;
    
}


- (void)show;

- (BOOL)showing;

- (void)hide;


@end
