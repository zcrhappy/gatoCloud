//
//  GTZoneStrainView.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/27.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GTDeviceZoneModel;
@interface GTZoneStrainView : UIView

- (void)setupWithModel:(GTDeviceZoneModel *)model;
- (CGFloat)viewHeight;

@end


@interface GTZoneStrainCollectionCell : UICollectionViewCell

- (void)setupContent:(NSString *)text;

@end