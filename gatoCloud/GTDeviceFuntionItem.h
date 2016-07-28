//
//  GTDeviceFuntionItem.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/27.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTDeviceFunctionItemDelegate <NSObject>

- (void)clickFunctionItemAtIndex:(NSNumber *)index;

@end

@interface GTDeviceFuntionItem : UIView

@property (nonatomic, weak) id<GTDeviceFunctionItemDelegate> delegate;

- (void)setupFuncionItemWithName:(NSString *)name iconName:(NSString *)icon;

@end
