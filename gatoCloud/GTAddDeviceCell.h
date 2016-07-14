//
//  GTAddDeviceCell.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/9.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GTAddDeviceCellStyle)
{
    GTAddDeviceCellStyleTitle_textField_QRImage,
    GTAddDeviceCellStyleTitle_textField,
    GTAddDeviceCellStyleIcon_textTield
};

@interface GTAddDeviceCell : UITableViewCell

@property (nonatomic, copy) void (^textChangedBlock)(NSString *textContent);
@property (nonatomic, copy) void (^clickQRImage)(void);

- (void)setUpCellWithTitle:(NSString *)title
                   content:(NSString *)content
               placeholder:(NSString *)placeholder
                      icon:(UIImage *)icon
                 cellStyle:(GTAddDeviceCellStyle)style;


- (void)becomeActive;
@end
