//
//  GTZoneStainEditViewController.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/28.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTZoneStainEditViewController : UIViewController

- (instancetype)initWithModel:(id)model;

@property (nonatomic, copy) void (^didSuccessBlock)(void);
@end
