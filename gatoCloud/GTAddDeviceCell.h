//
//  GTAddDeviceCell.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/9.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTAddDeviceCell : UITableViewCell

@property (nonatomic, copy) void (^textChangedBlock)(NSString *textContent);
@property (nonatomic, copy) void (^clickQRImage)(void);

- (void)setUpCellWithContent:(NSString *)content
               placeholder:(NSString *)placeholder
                        icon:(UIImage *)icon;


- (void)becomeActive;
@end
