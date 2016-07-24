//
//  GTWarningRecordCell.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/20.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GTWarningRecordCompleteModel;
@interface GTWarningRecordCell : UITableViewCell


- (void)setupWithModel:(GTWarningRecordCompleteModel *)completeModel indexPath:(NSIndexPath *)indexPath;

@end
