//
//  GTMainViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/18.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTMainViewController.h"
#import "SDCycleScrollView.h"
#import "GTStartModel.h"
@interface GTMainViewController()

@property (strong, nonatomic) IBOutlet SDCycleScrollView *carouselView;
@property (nonatomic, strong) GTStartModel *starModel;
@end

@implementation GTMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _carouselView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300) delegate:nil placeholderImage:[UIImage imageWithColor:[UIColor grayColor]]];
    
    [self.view addSubview:_carouselView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self checkVersion];
}

- (void)checkVersion
{
    [[GTHttpManager shareManager] GTAppCheckUpdateWithFinishBlock:^(id response, NSError *error) {
        
        if(error == nil) {
            _starModel = [MTLJSONAdapter modelOfClass:GTStartModel.class fromJSONDictionary:response error:nil];
        
            [GTUserUtils saveBanners:_starModel.banners];
            [self updateBanners];
            NSLog(@"");
        }
        
    }];
}


- (void)updateBanners
{
    NSMutableArray *urlArr = [NSMutableArray array];
    
    for (GTBannerModel *model in _starModel.banners) {
        [urlArr addObject:model.img];
    }
    
    _carouselView.imageURLStringsGroup = urlArr;
}

- (IBAction)unwindToMainViewController:(UIStoryboardSegue *)unwindSegue
{
    
}
- (IBAction)reCheckVersion:(id)sender {
    
    [self checkVersion];
}

@end
