//
//  CRBaseActionSheet.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/25.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "CRBaseActionSheet.h"

@implementation CRBaseActionSheet


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( nil != self )
    {
        self.alpha = 0.0;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [self addTarget:self action:@selector(onBackgroundClick) forControlEvents:UIControlEventTouchUpInside];
        
        _contentView = macroCreateView( CGRectZero, [UIColor clearColor]);
        [self addSubview:_contentView];
    }
    
    return self;
}


- (void)onBackgroundClick
{
    [self virtualBackgroundClick];
}


- (void)virtualBackgroundClick
{
    [self hide];
}


- (void)show
{
    [self prepareToShow];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^
     {
         self.alpha = 1.0;
     }];
    
    [self virtualDidShow];
}


- (void)prepareToShow
{
}


- (void)virtualDidShow
{
}


- (BOOL)showing
{
    return 1.0 == self.alpha;
}


- (void)hide
{
    [self virtualWillHide];
    
    [UIView animateWithDuration:0.3 animations:^
     {
         self.alpha = 0.0;
     }];
    [self removeFromSuperview];
    
    [self virtualDidHide];
}


- (void)virtualWillHide
{
}


- (void)virtualDidHide
{
}


@end
