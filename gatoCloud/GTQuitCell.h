//
//  GTQuitCell.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/18.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTQuitCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *quitButton;//height:50;
@property (nonatomic, copy) void (^clickQuitButton)(void);
@end
