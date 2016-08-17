//
//  GTNotDisturbCell.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/17.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTNotDisturbCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

- (void)setUpWithTitle:(NSString *)title selected:(BOOL)selected;

@end
