//
//  GTZoneStrainView.m
//  gatoCloud
//
//  Created by 曾超然 on 16/8/27.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTZoneStrainView.h"
#import "GTDeviceZoneModel.h"
#define kCellHeight 27
#define kColumns 4
@interface GTZoneStrainView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) NSArray <NSArray *>*stainArray;

@property (nonatomic, assign) CGFloat height;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@end

@implementation GTZoneStrainView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configUI];
}

- (void)configUI
{
    self.backgroundColor = [UIColor colorWithString:kLightBackground];
    
    _containerView.layer.borderColor = [UIColor grayColor].CGColor;
    _containerView.layer.borderWidth = SINGLE_LINE_WIDTH;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.minimumLineSpacing = SINGLE_LINE_WIDTH;
    flowLayout.minimumInteritemSpacing = SINGLE_LINE_WIDTH;
    
    _collectionView.collectionViewLayout = flowLayout;
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = [UIColor colorWithString:kBorderColor];
    _collectionView.layer.borderColor = [UIColor colorWithString:kBorderColor].CGColor;
    _collectionView.layer.borderWidth = SINGLE_LINE_WIDTH;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[GTZoneStrainCollectionCell class] forCellWithReuseIdentifier:@"cell"];
}

- (void)setupWithModel:(GTDeviceZoneModel *)model
{
    if([model canEdit])
        _editButton.hidden = NO;
    else
        _editButton.hidden = YES;
    
    _stainArray = [model fetchStainArray];
    [_collectionView reloadData];
}

#pragma mark - Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return kColumns * _stainArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    GTZoneStrainCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    NSInteger index = [indexPath row];
    NSArray *firstRow = @[@"",@"松弛",@"静态",@"拉紧"];
    if(index < kColumns) {
        [cell setupContent:firstRow[index]];
    }
    else if(index % kColumns == 0) {
        [cell setupContent:@(index/kColumns).stringValue];
    }
    else {
        NSInteger row = index / kColumns;
        NSInteger column = index % kColumns;
        NSArray *rowArray = [_stainArray objectAtIndex:row];
        NSString *data = [rowArray objectAtIndex:column];
        [cell setupContent:data];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CGFloat cellWidth = (collectionView.width - 4*SINGLE_LINE_WIDTH)/4.0;
    return CGSizeMake(cellWidth, kCellHeight);
}

- (CGFloat)viewHeight;
{
    _height =  _stainArray.count * kCellHeight + (_stainArray.count - 1) * SINGLE_LINE_WIDTH + 40;
    return _height + 20;
}

- (IBAction)clickEdit:(UIButton *)sender {
    if(_clickStainEditBlock)
        _clickStainEditBlock();
}

@end

#pragma mark -

@interface GTZoneStrainCollectionCell()

@property (nonatomic, strong) UILabel *label;

@end

@implementation GTZoneStrainCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        [self configCellUI];
    }
    return self;
}

- (void)configCellUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    _label = macroCreateLabel(CGRectZero, [UIColor whiteColor], 14, [UIColor colorWithString:@"87949a"]);
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"999";
    [self addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

- (void)setupContent:(NSString *)text
{
    _label.text = text;
}

@end



