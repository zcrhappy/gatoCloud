//
//  GTRenameViewController
//  gatoCloud
//
//  Created by 曾超然 on 16/7/13.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GTRenameType)
{
    GTRenameTypeDisplayName,
    GTRenameTypeDeviceName
};

@interface GTRenameViewController : UIViewController

@property (nonatomic, assign) GTRenameType renameType;
//GTRenameTypeDeviceName
@property (nonatomic, copy) NSString *currentDeviceName;
@property (nonatomic, copy) NSString *deviceNo;

//GTRenameTypeDisplayName
@property (nonatomic, copy) NSString *displayName;

@end
