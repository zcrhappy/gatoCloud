//
//  GTWarningDetailCommentCell.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/24.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTWarningDetailCommentCell : UITableViewCell

@property (nonatomic, copy) void (^memoDidChangeBlock)(NSString *text);

@end
