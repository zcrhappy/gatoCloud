//
//  GTAddDeviceNoCell.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/21.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTAddDeviceNoCell : UITableViewCell

- (void)setUpCellWithContent:(NSString *)content
                 placeholder:(NSString *)placeholder;

@property (nonatomic, copy) void (^textChangedBlock)(NSString *textContent);
@property (nonatomic, copy) void (^clickQRImage)(void);

@end
