//
//  GTSelectionPanel.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/13.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTSelectionPanel : UIView

- (instancetype)initWithSelectionArray:(NSArray *)selectionArray;
@property (nonatomic, copy) void (^clickItemBlock)(NSString *text);
@end


@interface GTSelectionPanelItem : UIView

- (instancetype)initWithText:(NSString *)text;
@property (nonatomic, copy) void (^clickItemBlock)(NSString *text);

@end
