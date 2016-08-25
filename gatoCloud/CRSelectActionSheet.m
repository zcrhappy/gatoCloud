//
//  CRSelectActionSheet.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/25.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "CRSelectActionSheet.h"
#import "NSString+GTCommon.h"

#define kCellHeight 60
#define kButtonHeight 50
#define kActionSheetWidth 290
#define kActionSheetLeftMargin 18
#define kActionSheetTopMargin 25
@interface CRSelectActionSheet()<UITableViewDelegate, UITableViewDataSource>
//contentComponent
@property ( nonatomic, strong ) UILabel *titleLabel;
@property ( nonatomic, strong) UITableView *selectionTable;
@property ( nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIButton *button;

//data
@property ( nonatomic, strong) NSArray *selectionArray;
@property (nonatomic , copy) NSString *currentSelection;
@property ( nonatomic, copy) actionSheetButtonClick clickBlock;
@end


@implementation CRSelectActionSheet

+ (instancetype)actionSheetWithTitle:(NSString *)title selectionArr:(NSArray *)array buttonClicked:(actionSheetButtonClick)buttonClick;
{
    CRSelectActionSheet *baseSheet = [[CRSelectActionSheet alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];

    [baseSheet setTitle:title];
    [baseSheet setSelectionArray:array];
    [baseSheet setClickBlock:buttonClick];
    [baseSheet show];
    
    return baseSheet;
}

#pragma mark - CreateUI

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( nil != self )
    {
        _contentView.layer.cornerRadius = 6;
        _contentView.clipsToBounds = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
        
        [self createSubViews];
    }
    
    return self;
}

- (void)createSubViews
{
    self.titleLabel = macroCreateBoldLabel( CGRectZero, [UIColor clearColor], 20, [UIColor blackColor]);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    [_contentView addSubview:self.titleLabel];
    
    self.selectionTable = macroCreateTableView(CGRectZero, [UIColor clearColor]);
    self.selectionTable.scrollEnabled = NO;
    self.selectionTable.delegate = self;
    self.selectionTable.dataSource = self;
    [_contentView addSubview:self.selectionTable];
    
    self.separatorLine = macroCreateView( CGRectZero, [UIColor colorWithString:@"212121"]);
    [_contentView addSubview:_separatorLine];
    
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.backgroundColor = [UIColor clearColor];
    self.button.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button setTitle:@"取消" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_button];
}

#pragma mark - SetupUI

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (void)setSelectionArray:(NSArray *)selectionArray
{
    _selectionArray = selectionArray;
}

- (void)setClickBlock:(actionSheetButtonClick)clickBlock
{
    _clickBlock = clickBlock;
}

#pragma mark - Show
- (void)prepareToShow
{
    [self layoutContentElement];
}

- (void)layoutContentElement
{
    CGFloat textHeight = [_titleLabel.text getHeightWithFont:_titleLabel.font];
    _titleLabel.frame = CGRectMake(kActionSheetLeftMargin, kActionSheetTopMargin, kActionSheetWidth - 2*kActionSheetLeftMargin, textHeight);
    _selectionTable.frame = CGRectMake(0, _titleLabel.bottom, kActionSheetWidth, _selectionArray.count * kCellHeight - SINGLE_LINE_WIDTH);
    _separatorLine.frame = CGRectMake(0, _selectionTable.bottom, kActionSheetWidth, SINGLE_LINE_WIDTH);
    _button.frame = CGRectMake(0, _separatorLine.bottom, kActionSheetWidth, kButtonHeight);
    
    UIView *lastView = _button;
    CGFloat contentViewInitX = (SCREEN_WIDTH - kActionSheetWidth)/2;
    CGFloat contentViewHeight = lastView.bottom;
    CGFloat contentViewInitY = (SCREEN_HEIGHT - contentViewHeight)/2;
    _contentView.frame = CGRectMake(contentViewInitX, contentViewInitY, kActionSheetWidth, contentViewHeight);
}

#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"actionSheetIdentifier";
    NSInteger index = [indexPath row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = _selectionArray[index];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];

    if(_clickBlock)
        _clickBlock(_selectionArray[index]);
    
    [self hide];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

#pragma mark - Action
- (void)clickCancel
{
    [self hide];
}
@end
