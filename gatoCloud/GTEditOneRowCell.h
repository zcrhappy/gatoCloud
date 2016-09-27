//
//  GTEditOneRowCell.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/8.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTEditOneRowCell : UITableViewCell

- (id)setupWithTitle:(NSString *)title placeholder:(NSString *)placeholder content:(NSString *)content showLine:(BOOL)shouldShowLine;
- (id)setupWithTitle:(NSString *)title placeholder:(NSString *)placeholder content:(NSString *)content showLine:(BOOL)shouldShowLine shouldEditTextField:(BOOL)shouldEdit;

- (NSString *)contentString;
- (void)updateContent:(NSString *)string;
- (void)shouldEditTextField:(BOOL)shouldEdit;
@property (nonatomic, copy) void (^textDidChangeBlk)(NSString *text);

@end
