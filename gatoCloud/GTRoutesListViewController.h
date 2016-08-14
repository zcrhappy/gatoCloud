//
//  GTRoutesListViewController.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/28.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTZoneDataManager.h"
@interface GTRoutesListViewController : UIViewController

@property (nonatomic, copy) NSString *searchKeyword;

- (instancetype)initWithListType:(kListType)listType;
- (instancetype)init;//全部防区


- (void)enableSearchBar:(BOOL)yesOrNo;
@end
