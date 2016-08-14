//
//  GTDatePickPanel.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/13.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTDatePickPanel.h"
#define HALF_YEAR		15778463
@implementation GTDatePickPanel

- (instancetype)init
{
    if(self = [super init]) {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    self.backgroundColor = [UIColor whiteColor];
    
    _leftItem = [[GTDatePickPanelItem alloc] init];
    _leftItem.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapLeft = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBegin)];
    [_leftItem addGestureRecognizer:tapLeft];
    _leftItem.titleLabel.text = @"起始日期";
    _leftItem.dateLabel.text = [self stringFromDate:[self dateBeforeHalfYear]];
    [self addSubview:_leftItem];
    
    
    _rightItem = [[GTDatePickPanelItem alloc] init];
    _rightItem.left = _leftItem.right;
    _rightItem.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRight = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEnd)];
    [_rightItem addGestureRecognizer:tapRight];
    _rightItem.titleLabel.text = @"结束日期";
    _rightItem.dateLabel.text = [self stringFromDate:[NSDate date]];
    [self addSubview:_rightItem];
    
    UIView *btmLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - SINGLE_LINE_WIDTH, SCREEN_WIDTH, SINGLE_LINE_WIDTH)];
    btmLine.backgroundColor = [UIColor colorWithString:@"c2c2c2"];
    [self addSubview:btmLine];
}

- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [fmt stringFromDate:date];
    return dateStr;
}

- (NSDate *)dateBeforeHalfYear
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceReferenceDate] - HALF_YEAR;
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:interval];
    return date;
}

- (void)tapBegin
{
    if(_selectBeginDateBlock)
        _selectBeginDateBlock(_leftItem.dateLabel.text);
}

- (void)tapEnd
{
    if(_selectEndDateBlock)
        _selectEndDateBlock(_rightItem.dateLabel.text);
}

@end

@implementation GTDatePickPanelItem

- (instancetype)init
{
    if(self = [super init]) {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH/2.0, 44);
    self.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = macroCreateLabel(CGRectMake(0, 0, self.width, self.height/2.0), [UIColor whiteColor], 15, [UIColor blackColor]);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    _dateLabel = macroCreateLabel(CGRectMake(0, _titleLabel.bottom, self.width, self.height/2.0), [UIColor whiteColor], 15, [UIColor colorWithString:@"393b3c"]);
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_dateLabel];
    
}
@end