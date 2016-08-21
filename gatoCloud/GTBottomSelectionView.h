//
//  GTBottomSelectionView.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/19.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>
/*!
 *  @brief 底部显示布防撤防按钮
 */
@interface GTBottomSelectionView : UIView
@property (weak, nonatomic) IBOutlet UIButton *guardBtn;
@property (weak, nonatomic) IBOutlet UIButton *disguardBtn;

@property (nonatomic, copy) void(^clickGuardBlock)(void);
@property (nonatomic, copy) void(^clickDisguardBlock)(void);

@end
