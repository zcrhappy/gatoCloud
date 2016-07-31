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
#import "GTMainViewInfoModel.h"
#import "GTShareActionSheet.h"


//test
#import "GTRoutesListViewController.h"
@interface GTMainViewController()

@property (weak, nonatomic) IBOutlet SDCycleScrollView *carouselView;
@property (nonatomic, weak) IBOutlet UIImageView *headImgView;
@property (nonatomic, weak) IBOutlet UILabel *deviceCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *zoneCountLabel;
//dataSource
@property (nonatomic, strong) GTStartModel *startModel;
@property (nonatomic, strong) GTMainViewInfoModel *infoModel;
@end

@implementation GTMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self checkVersion];
    
    [self fetchMainViewInfo];
}

- (void)configUI
{
    _carouselView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    _carouselView.placeholderImage = [UIImage imageWithColor:[UIColor grayColor]];
}

- (void)checkVersion
{
    [[GTHttpManager shareManager] GTAppCheckUpdateWithFinishBlock:^(id response, NSError *error) {
        
        if(error == nil) {
            _startModel = [MTLJSONAdapter modelOfClass:GTStartModel.class fromJSONDictionary:response error:nil];
        
            [GTUserUtils saveBanners:_startModel.banners];
        
            [self updateBanners];
            NSLog(@"");
        }
    }];
}

- (void)fetchMainViewInfo
{
    [[GTHttpManager shareManager] GTQueryMainViewInfoWithFinishBlock:^(id response, NSError *error) {
        if(error == nil) {
            _infoModel = [MTLJSONAdapter modelOfClass:GTMainViewInfoModel.class fromJSONDictionary:response error:nil];
            //headImg
            [_headImgView sd_setImageWithURL:[NSURL URLWithString:_infoModel.headImg] placeholderImage:nil completed:nil];
            [GTUserUtils saveHeadImgURLString:_infoModel.headImg];
            //number
            _deviceCountLabel.text = _infoModel.deviceCount;
            _zoneCountLabel.text = _infoModel.zoneCount;
        }
    }];
}

- (IBAction)clickZoneList:(id)sender
{
    GTRoutesListViewController *controller = [[GTRoutesListViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];

}

- (void)updateBanners
{
    NSMutableArray *urlArr = [NSMutableArray array];
    
    for (GTBannerModel *model in _startModel.banners) {
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



//********************************************************

- (IBAction)clickShare:(id)sender
{
    GTShareActionSheet *actionSheet = [[GTShareActionSheet alloc] initWithShareDestination:nil parentViewController:self];
    [actionSheet show];
}









@end
