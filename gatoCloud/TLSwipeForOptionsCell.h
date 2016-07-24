//
//  TLSwipeForOptionsCell.h
//  UITableViewCell-Swipe-for-Options
//
//  Created by Ash Furrow on 2013-07-29.
//  Copyright (c) 2013 Teehan+Lax. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TLSwipeForOptionsCell;

@protocol TLSwipeForOptionsCellDelegate <NSObject>

-(void)cellDidSelectDelete:(TLSwipeForOptionsCell *)cell;
-(void)cellDidSelectMore:(TLSwipeForOptionsCell *)cell;

@end

extern NSString *const TLSwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification;

@interface TLSwipeForOptionsCell : UITableViewCell

@property (nonatomic, weak) id<TLSwipeForOptionsCellDelegate> delegate;
@property (nonatomic, weak) UIView *scrollViewContentView;      //The cell content (like the label) goes in this view.
@property (nonatomic, weak) UIView *scrollViewButtonView;       //Contains our two buttons

@property (nonatomic, assign) BOOL isMenuShowed;

- (void)enclosingTableViewDidScroll;


@end
