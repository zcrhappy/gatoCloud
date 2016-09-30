//
//  UIViewController+GTAlertController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/26.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "UIViewController+GTAlertController.h"

@implementation UIViewController (GTAlertController)


- (void)gt_showTypingControllerWithTitle:(NSString *)title placeholder:(NSString *)placeholder finishBlock:(void (^)(NSString *content))finishBlk
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    //创建按钮
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确认按钮block");
        //取出输入框文字
        NSString *content = alertController.textFields.firstObject.text;
        finishBlk(content);
    }];
    //取消按钮（只能创建一个）
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消按钮block");
    }];
    
    //将按钮添加到UIAlertController对象上
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    
    //添加文本框（只能在UIAlertController的UIAlertControllerStyleAlert样式下添加）
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = placeholder;
        textField.secureTextEntry = YES;
    }];
    
    //显示弹窗视图控制器
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)gt_showMsgControllerWithTitle:(NSString *)title msg:(NSString *)msg finishBlock:(void (^)(void))finishBlk
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    //创建按钮
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确认按钮block");
        if(finishBlk)
            finishBlk();
    }];
    
    //将按钮添加到UIAlertController对象上
    [alertController addAction:sureAction];
    
    //显示弹窗视图控制器
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
