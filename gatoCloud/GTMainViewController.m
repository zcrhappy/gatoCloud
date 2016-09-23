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
#import "GTRoutesListViewController.h"
#import "GTBaseNavigationController.h"
#import "GTWarningRecordsViewController.h"
#import "GTWebViewController.h"
#import "GTRoutesListViewController.h"
#import "GTCheckPwdManager.h"
@interface GTMainViewController()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet SDCycleScrollView *carouselView;
@property (nonatomic, weak) IBOutlet UIImageView *headImgView;
@property (nonatomic, weak) IBOutlet UILabel *deviceCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *zoneCountLabel;
//dataSource
@property (nonatomic, strong) GTStartModel *startModel;
@property (nonatomic, strong) GTMainViewInfoModel *infoModel;
@property (nonatomic, strong) GTCheckPwdManager *checkPwdManager;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@end

@implementation GTMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.checkPwdManager = [[GTCheckPwdManager alloc] initWithViewController:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangedDevice:) name:kDeviceChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangedHeadImg:) name:kHeadImgChangedNotification object:nil];
    [self.view layoutIfNeeded];
    [self configUI];
    [self checkVersion];
    [self fetchMainViewInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_checkPwdManager checkAllDevicePwd];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDeviceChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHeadImgChangedNotification object:nil];
}

- (void)configUI
{
    _headImgView.layer.cornerRadius = _headImgView.width/2.0;
    _headImgView.layer.masksToBounds = YES;
    _headImgView.layer.borderWidth = 1.5;
    _headImgView.layer.borderColor = [UIColor colorWithString:@"fcfcfc"].CGColor;
    _headImgView.backgroundColor = [UIColor whiteColor];
    _headImgView.userInteractionEnabled = YES;
    [self.view bringSubviewToFront:_headImgView];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:[GTUserUtils sharedInstance].userModel.avatarUrlString] placeholderImage:[UIImage imageNamed:@"GTDefaultAvatar"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadImg)];
    [_headImgView addGestureRecognizer:tap];
    
    _carouselView.delegate = self;
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
            [[GTUserUtils sharedInstance].userModel setAvatarUrlString:_infoModel.headImg completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kHeadImgChangedNotification object:nil];
            }];
            //number
            _deviceCountLabel.text = _infoModel.deviceCount;
            _zoneCountLabel.text = _infoModel.zoneCount;
            _deviceLabel.text = _infoModel.allDeviceCount.integerValue == 0 ? @"添加设备" : @"中心设备";
            [[GTUserUtils sharedInstance].userModel setDisplayName:_infoModel.nickName];
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
    _carouselView.autoScroll = NO;
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    [[GTHttpManager shareManager] GTHandleAllWarningsWithFinishBlock:^(id response, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        if(error == nil) {
            [MBProgressHUD showText:@"消除报警成功!" inView:strongSelf.view];
        }
    }];
}

//添加设备后需要增加
- (void)didChangedDevice:(NSNotification *)notification
{
    [self fetchMainViewInfo];
}

- (void)didChangedHeadImg:(NSNotification *)notification
{
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:[GTUserUtils sharedInstance].userModel.avatarUrlString] placeholderImage:[UIImage imageNamed:@"GTDefaultAvatar"]];
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
{
    NSArray <GTBannerModel *>* bannerModels = _startModel.banners;
    __block NSString *url;
    
    [bannerModels enumerateObjectsUsingBlock:^(GTBannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx == index) {
            url = obj.url;
            *stop = YES;
        }
    }];
    
    GTWebViewController *webViewController = [[GTWebViewController alloc] initWithUrl:url];
    [self gt_presentViewController:webViewController animated:YES completion:nil];
}

@end
