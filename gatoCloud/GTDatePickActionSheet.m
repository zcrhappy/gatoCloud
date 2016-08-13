//
//  GTPickDateActionSheet.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/13.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTDatePickActionSheet.h"
#define kAnimtionDuration 0
@interface GTDatePickActionSheet ()

@property (nonatomic, copy) NSDate *date;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation GTDatePickActionSheet

+ (instancetype)datePickerWithDate:(NSString *)dateStr
{
    GTDatePickActionSheet *actionSheet = [[GTDatePickActionSheet alloc] initWithDate:dateStr];
    return actionSheet;
}

- (instancetype)initWithDate:(NSString *)dateStr
{
    if(self = [super init])
    {
        _date = [self dateWithString:dateStr];
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tapGesture];
    
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.frame = CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216);
    
    _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker setDate:_date];
    
    [self addSubview:_datePicker];
    
    UIView *toolbar = macroCreateView(CGRectMake(0, 0, SCREEN_WIDTH, 44), [UIColor whiteColor]);
    toolbar.bottom = _datePicker.top;
    [self addSubview:toolbar];
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    doneBtn.right = toolbar.right;
    [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(clickDone) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [toolbar addSubview:doneBtn];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:cancelBtn];
    
}

- (NSString *)dateDidPicked
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [fmt stringFromDate:_datePicker.date];
    return dateStr;
}

- (NSDate *)dateWithString:(NSString *)dateStr
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    return [fmt dateFromString:dateStr];
}

- (void)clickDone
{
    if(_dateChangedBlock)
        _dateChangedBlock([self dateDidPicked]);
    
    [self dismiss];
}

- (void)clickCancel
{
    [self dismiss];
}

- (void)dismiss
{
    [UIView animateWithDuration:kAnimtionDuration animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:kAnimtionDuration animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }];
}

@end
