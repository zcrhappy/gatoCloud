//
//  GTRoutesListViewController.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/28.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTRoutesListViewController : UIViewController

- (instancetype)initWithDeviceNo:(NSString *)deviceNo;//特定设备的防区列表
- (instancetype)initWithDeviceName:(NSString *)deviceName;
- (instancetype)initWithZoneName:(NSString *)zoneName;
- (instancetype)init;//全部防区


- (void)enableSearchBar:(BOOL)yesOrNo;
@end
