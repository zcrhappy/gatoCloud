//
//  GTSearchBar.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/4.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTSearchBar : UIView

- (instancetype)initWithPlaceholder:(NSString *)placeholder;

@property (nonatomic, copy) void (^didEndEditingBlock)(NSString *keyword);
 
@end
