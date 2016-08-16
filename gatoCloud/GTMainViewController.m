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
#import "GTRoutesListViewController.h"
#import "GTBaseNavigationController.h"
#import "GTWarningRecordsViewController.h"
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
    
    [self configUI];

    [self checkVersion];
    
    [self fetchMainViewInfo];
}

- (void)configUI
{
    _headImgView.layer.cornerRadius = _headImgView.width/2.0;
    _headImgView.layer.masksToBounds = YES;
    _headImgView.layer.borderWidth = 1.5;
    _headImgView.layer.borderColor = [UIColor colorWithString:@"fcfcfc"].CGColor;
    _headImgView.backgroundColor = [UIColor whiteColor];
    _headImgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadImg)];
    [_headImgView addGestureRecognizer:tap];
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


- (void)clickHeadImg
{
    [self performSegueWithIdentifier:@"modalToMeSegue" sender:self];
}

- (IBAction)reCheckVersion:(id)sender {
    
    [self checkVersion];
    [self fetchMainViewInfo];
}

#pragma mark - functions

//防区管理
- (IBAction)clickDefenceList:(id)sender
{
    GTRoutesListViewController *controller = [[GTRoutesListViewController alloc] init];
    controller.navigationItem.title = @"防区列表";
    GTBaseNavigationController *navigationController = [[GTBaseNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:nil];
}

//报警管理
- (IBAction)clickWarningList:(id)sender
{
    GTWarningRecordsViewController *controller = [[GTWarningRecordsViewController alloc] init];
    controller.navigationItem.title = @"报警记录";
    GTBaseNavigationController *navigationController = [[GTBaseNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

//设备管理
- (IBAction)clickDeviceCenter:(id)sender
{
    [self performSegueWithIdentifier:@"ModalToDeviceCenterSegue" sender:self];
}

//联系我们
- (IBAction)clickContactUs:(id)sender {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"联系我们" message:@"拨打电话:4006840078" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *call = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4006840078"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    [controller addAction:cancle];
    [controller addAction:call];
    
    [self presentViewController:controller animated:YES completion:nil];
}

//消除报警
- (IBAction)tapDisguard:(id)sender {
    
    GTWarningRecordsViewController *controller = [[GTWarningRecordsViewController alloc] initViaType:@"未处理报警"];
    controller.navigationItem.title = @"报警处理";
    GTBaseNavigationController *navigationController = [[GTBaseNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}
@end
