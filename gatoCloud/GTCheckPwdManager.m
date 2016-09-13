//
//  GTCheckPwdManager.m
//  gatoCloud
//
//  Created by 曾超然 on 16/9/13.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTCheckPwdManager.h"
#import "GTCheckPwdModel.h"
@interface GTCheckPwdManager()

@property (nonatomic, strong) NSMutableArray <GTCheckPwdModel *> *checkPwdList;
@property (nonatomic, strong) UIViewController *parentViewController;
@end

@implementation GTCheckPwdManager

- (instancetype)initWithViewController:(UIViewController *)viewController;
{
    if(self = [super init])
    {
        _parentViewController = viewController;
    }
    return self;
}

- (instancetype)init
{
    UIViewController *topViewController = [UIViewController gt_topViewController];
    if(self = [self initWithViewController:topViewController])
    {
        [[GTHttpManager shareManager] GTDeviceQueryCheckPwdDeviceWithFinishBlock:^(id response, NSError *error) {
            if(error == nil) {
                NSArray *array = [MTLJSONAdapter modelsOfClass:GTCheckPwdModel.class fromJSONArray:[response objectForKey:@"list"] error:nil];
                _checkPwdList = [NSMutableArray arrayWithArray:array];
            }
        }];
    }
    return self;
}

#pragma mark - 检查所有

- (void)checkAllDevicePwd
{
    [[GTHttpManager shareManager] GTDeviceQueryCheckPwdDeviceWithFinishBlock:^(id response, NSError *error) {
        if(error == nil) {
            NSArray *array = [MTLJSONAdapter modelsOfClass:GTCheckPwdModel.class fromJSONArray:[response objectForKey:@"list"] error:nil];
            _checkPwdList = [NSMutableArray arrayWithArray:array];
            [self showCheckPwd];
        }
    }];
}

- (void)showCheckPwd
{
    if(_checkPwdList.count > 0) {
        GTCheckPwdModel *model = [self.checkPwdList firstObject];
        __weak __typeof(self)weakSelf = self;
        
        [_parentViewController gt_showTypingControllerWithTitle:@"验证设备密码" placeholder:[NSString stringWithFormat:@"请输入%@的密码",model.deviceName] finishBlock:^(NSString *content) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf addDeviceWithModel:model newPwd:content finishBlock:^(id response, NSError *error) {
                if(!error){
                    [MBProgressHUD showText:@"密码验证成功" inView:weakSelf.parentViewController.view];
                }
                [weakSelf.checkPwdList removeObjectAtIndex:0];
                [weakSelf showCheckPwd];
            }];
        }];
    }
}
#pragma mark - 检查单个设备
- (BOOL)shouldShowPwdCheckWithDeviceNo:(NSString *)deviceNo
{
    __block BOOL shouldShow = NO;
    //sync
    [_checkPwdList enumerateObjectsUsingBlock:^(GTCheckPwdModel * _Nonnull pwdModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if([deviceNo isEqualToString:pwdModel.deviceNo]) {
            [self showCheckPwdWithPwdModel:pwdModel];
            shouldShow = YES;
            *stop = YES;
        }
    }];
    
    return shouldShow;
}

- (void)showCheckPwdWithPwdModel:(GTCheckPwdModel *)pwdModel
{
    __weak __typeof(self)weakSelf = self;
    
    [_parentViewController gt_showTypingControllerWithTitle:@"验证设备密码" placeholder:[NSString stringWithFormat:@"请输入%@的密码",pwdModel.deviceName] finishBlock:^(NSString *content) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf addDeviceWithModel:pwdModel newPwd:content finishBlock:^(id response, NSError *error) {
            if(!error){
                [weakSelf.checkPwdList removeObject:pwdModel];
                [MBProgressHUD showText:@"验证密码成功" inView:[UIView gt_keyWindow]];
            }
        }];
    }];
}

- (void)addDeviceWithModel:(GTCheckPwdModel *)model newPwd:(NSString *)newPwd finishBlock:(GTResultBlock)finishBlock
{
    [[GTHttpManager shareManager] GTDeviceAddWithDeviceNo:model.deviceNo deviceUserType:model.userType.stringValue devicePwd:newPwd finishBlock:finishBlock];
}

@end
