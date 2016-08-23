//
//  GTShareActionSheet.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/25.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTShareActionSheet : UIView

- (instancetype)initWithShareDestination:(NSArray *)destination parentViewController:(UIViewController *)parentViewController;

- (void)show;

@property (nonatomic, copy) void (^shareToWXFriend)(void);
@property (nonatomic, copy) void (^shareViaMessage)(void);
@end
