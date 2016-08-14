//
//  GTSelectionPanel.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/13.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTSelectionPanel.h"
#import "NSString+GTCommon.h"
#define HGap 10
#define VGap 15
@interface GTSelectionPanel()

@property (nonatomic, strong) NSArray <NSString *>*selectionArr;
@property (nonatomic, strong) UIFont *font;

@end

@implementation GTSelectionPanel

- (instancetype)initWithSelectionArray:(NSArray *)selectionArray
{
    if(self = [super init]) {
        _selectionArr = selectionArray;
        _font = [UIFont systemFontOfSize:15];
        
        [self configUI];
    }
    
    return self;
}

- (void)configUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    NSInteger index = 0;
    GTSelectionPanelItem *lastItem = nil;
    
    for(NSString *text in _selectionArr)
    {
        GTSelectionPanelItem *item = [[GTSelectionPanelItem alloc] initWithText:text];
        __weak __typeof(self)weakSelf = self;
        
        [item setClickItemBlock:^(NSString *text)
        {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if(strongSelf.clickItemBlock)
            {
                strongSelf.clickItemBlock(text);
            }
            
        }];
        
        if(lastItem)
        {
            if(lastItem.right + HGap + item.width > SCREEN_WIDTH)
            {
                //另起一行
                item.top = lastItem.bottom + VGap;
                item.left = HGap;
            }
            else
            {
                item.top = lastItem.top;
                item.left = lastItem.right + HGap;
            }
        }
        else
        {
            item.top = VGap;
            item.left = HGap;
        }
        [self addSubview:item];
        lastItem = item;
        index++;
    }
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, lastItem.bottom + VGap);
    
    UIView *btmLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - SINGLE_LINE_WIDTH, SCREEN_WIDTH, SINGLE_LINE_WIDTH)];
    btmLine.backgroundColor = [UIColor colorWithString:@"c2c2c2"];
    [self addSubview:btmLine];
}

@end


@interface GTSelectionPanelItem()

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat height;
@end

@implementation GTSelectionPanelItem

- (instancetype)initWithText:(NSString *)text
{
    if(self = [super init]){
        _text = text;
        _font = [UIFont systemFontOfSize:15];
        _height = 33.5;
        
        [self configUI];
    }
    return self;
}


- (void)configUI
{
    CGFloat width = [_text getWidthWithFont:_font];
    self.frame = CGRectMake(0, 0, width + 22, _height);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.bounds;
    [btn setTitleColor:[UIColor colorWithString:@"393b3c"] forState:UIControlStateNormal];
    btn.titleLabel.font = _font;
    btn.layer.borderColor = [UIColor colorWithString:@"c2c2c2"].CGColor;
    btn.layer.cornerRadius = btn.height/2.0;
    btn.layer.borderWidth = SINGLE_LINE_WIDTH;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(clickItem) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    [btn setTitle:_text forState:UIControlStateNormal];
}

- (void)clickItem
{
    if(_clickItemBlock)
        _clickItemBlock(_text);
}


@end