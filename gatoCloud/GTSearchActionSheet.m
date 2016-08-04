//
//  GTBaseActionSheet.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/4.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTSearchActionSheet.h"

#define kAnimtionDuration 0
#define kRowHeight 50
#define kRowWidth 120
@interface GTSearchActionSheet()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *selectionList;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) NSArray *selections;
@end

@implementation GTSearchActionSheet

+ (instancetype)actionSheetWithSelection:(NSArray *)selection;
{
    GTSearchActionSheet *actionSheet = [[GTSearchActionSheet alloc] init];
    [actionSheet setupWithSelection:selection];
    return actionSheet;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
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
    tapGesture.delegate = self;
    
//    _customView = [[UIView alloc] initWithFrame:CGRectZero];
//    _customView.userInteractionEnabled = YES;
//    [self addSubview:_customView];
    
    _selectionList = [[UITableView alloc] initWithFrame:CGRectZero];
    _selectionList.separatorStyle = UITableViewCellSeparatorStyleNone;
    _selectionList.scrollEnabled = NO;
    _selectionList.rowHeight = kRowHeight;
    _selectionList.delegate = self;
    _selectionList.dataSource = self;
    [self addSubview:_selectionList];
//    [_selectionList mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_customView).insets(UIEdgeInsetsZero);
//    }];
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:gestureRecognizer.view];
    
    if (CGRectContainsPoint(_selectionList.frame, location)) {
        return NO;
    }
    
    return YES;
}

#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithString:@"393b3c"];
    
    UIView *btmLine = [[UIView alloc] init];
    btmLine.backgroundColor = [UIColor blackColor];
    [cell addSubview:btmLine];
    [btmLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(cell).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.equalTo(@(SINGLE_LINE_WIDTH));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.userInteractionEnabled = YES;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    label.text = [_selections objectAtIndex:[indexPath row]];
    label.backgroundColor = [UIColor clearColor];
    [cell addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(cell).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.left.equalTo(@20);
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    
    if(_didClickBlk)
        _didClickBlk(index);
}

#pragma mark -
- (void)setupWithSelection:(NSArray *)selection
{
    _selections = selection;
    _selectionList.frame = CGRectMake(SCREEN_WIDTH - kRowWidth - 15, 64, kRowWidth, kRowHeight*selection.count);
    [_selectionList reloadData];
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
