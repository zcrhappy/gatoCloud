//
//  CRTextView.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/7.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRTextView : UIView
@property (nonatomic, copy) NSString *placeholder;
@property(nullable, nonatomic,strong) UIColor                *textColor;            // default is nil. use opaque black
@property(nullable, nonatomic,strong) UIFont                 *font;                 // default is nil. use system font 12 pt
@end
