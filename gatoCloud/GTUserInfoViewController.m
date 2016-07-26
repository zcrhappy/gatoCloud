//
//  GTUserInfoViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/15.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTUserInfoViewController.h"
#import "GTUserInfoCell.h"
#import "GTStartModel.h"
#import "LCActionSheet.h"
#import "GestureViewController.h"
#import "PCCircleView.h"
#import "GTDeviceManagerAuthorization.h"
#import <AVFoundation/AVFoundation.h>

NSString *kAvatar = @"头像";
NSString *kNoDisturb = @"功能消息免打扰";
NSString *kModifyGestureCode = @"修改手势密码";
NSString *kCheckVersion = @"版本检测";
NSString *kContactUs = @"联系我们";
NSString *kFeedback = @"反馈";
NSString *kQuitAccount = @"退出当前账号";

typedef NS_ENUM(NSInteger, GTPickPhotoVia)
{
    GTPickPhotoViaCamera = 0,
    GTPickPhotoViaAlbum = 1,
};

@interface GTUserInfoViewController()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CircleViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *listTable;
@property (nonatomic, strong) NSArray *rowArray;

@end

@implementation GTUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configSource];
    [self configUI];
}

- (void)configSource
{
    _rowArray = @[kAvatar, kNoDisturb, kModifyGestureCode, kCheckVersion, kContactUs, kFeedback, kQuitAccount];
    
}

- (void)configUI
{
    _listTable.tableFooterView = [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSString *title = [_rowArray objectAtIndex:row];
    
    GTUserInfoCell *cell = (GTUserInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"GTUserInfoCellIdentifier" forIndexPath:indexPath];
    
    if([title isEqualToString:kAvatar]) {
        NSString *avatarStr = [GTUserUtils userHeadImgURLString];
        [cell setupCellWithType:GTUserInfoCellTypeAvatar title:title subTitle:nil avatarStr:avatarStr];
    }
    else {
        [cell setupCellWithType:GTUserInfoCellTypeArrow title:title subTitle:nil avatarStr:nil];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = [indexPath row];
    NSString *title = [_rowArray objectAtIndex:row];
    
    
    if([title isEqualToString:kAvatar]) {
        LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"拍照",@"从手机相册选择"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
            [self pickPhotoWithButtonAtIndex:buttonIndex];
        }];
        [actionSheet show];
    }
    else if([title isEqualToString:kFeedback]) {
        [self performSegueWithIdentifier:@"pushToFeedbackSegue" sender:self];
    }
    else if([title isEqualToString:kContactUs]) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"联系我们" message:@"拨打电话:4006840078" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:cancle];
        
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
    else if ([title isEqualToString:kCheckVersion]) {
        [[GTHttpManager shareManager] GTAppCheckUpdateWithFinishBlock:^(id response, NSError *error) {
            GTStartModel *startModel = [MTLJSONAdapter modelOfClass:GTStartModel.class fromJSONDictionary:response error:nil];
            if([startModel.code isEqualToString:@"0"]) {
                [MBProgressHUD showText:@"您已经是最新版本" inView:self.view];
            }
            else {
                [MBProgressHUD showText:@"有新版本" inView:self.view];
            }
        }];
    }
    else if ([title isEqualToString:kModifyGestureCode]) {
        GestureViewController *gestureUnlockViewController = [[GestureViewController alloc] init];
        gestureUnlockViewController.type = GestureViewControllerTypeSetting;
        [self.navigationController pushViewController:gestureUnlockViewController animated:YES];
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSString *title = [_rowArray objectAtIndex:row];
    
    if([title isEqualToString:@"头像"]){
        return 88;
    }
    else {
        return 44;
    }
}

//回到当前页
- (IBAction)unwindToUserInfoViewController:(UIStoryboardSegue *)unwindSegue
{
    
}


- (IBAction)clickBack:(id)sender
{
//    [self performSegueWithIdentifier:@"backToMainViewSegue" sender:self];
}


#pragma mark - 相册相关 UIImage Picker Delegate
- (void)pickPhotoWithButtonAtIndex:(GTPickPhotoVia)viaIndex
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.navigationBar.tintColor  = [UIColor blackColor];
    picker.navigationBar.translucent = NO;
    picker.navigationBar.topItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    
    switch (viaIndex) {
        case GTPickPhotoViaCamera:
        {
            dispatch_block_t imagePickerBlock = ^{
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
                    [picker setAllowsEditing:YES];
                    
                } else {
                    
                }
                if (![[GTDeviceManagerAuthorization shareInstance] isCameraAccessable]) {
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"请在iPhone的“设置-隐私-相机”选项中，允许高拓访问你的相机”" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *doneButton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                    [controller addAction:doneButton];
                    
                    [self.navigationController presentViewController:controller animated:YES completion:nil];
                }
                else
                {
                    [self presentViewController:picker animated:YES completion:^{
                        
                    }];
                }
            };
            
            
            AVAuthorizationStatus cameraAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (cameraAuthStatus == AVAuthorizationStatusNotDetermined) {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        imagePickerBlock();
                    }
                }];
            }
            else
            {
                imagePickerBlock();
            }
            
            break;
        }
        case GTPickPhotoViaAlbum:
        {
            [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [picker setAllowsEditing:YES];
            [self presentViewController:picker animated:YES completion:^{
                if (![[GTDeviceManagerAuthorization shareInstance] isImageAlbumAccessable]) {
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"请在iPhone的“设置-隐私-照片”选项中，允许高拓访问你的手机相册" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *doneButton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                    [controller addAction:doneButton];
                    
                    [self.navigationController presentViewController:controller animated:YES completion:nil];
                }
            }];
            break;
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        UIImage * editImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
            UIImageOrientation imageOrientation=editImage.imageOrientation;
            UIImage *image = editImage;
            
            if(imageOrientation!=UIImageOrientationUp)
            {
                UIGraphicsBeginImageContext(editImage.size);
                [editImage drawInRect:CGRectMake(0, 0, editImage.size.width, editImage.size.height)];
                image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }

            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
  
            [[GTHttpManager shareManager] GTUploadAvatarWithData:imageData finishBlock:^(id response, NSError *error) {
                if(error == nil) {
                    [MBProgressHUD showText:@"修改头像成功" inView:self.view];
                    
                    NSString *head = [response objectForKey:@"headImg"];
                    [GTUserUtils saveHeadImgURLString:head];
                    [_listTable reloadData];
                }
            }];
            
            //保存本地
            //[self saveImage:scalesImage withName:[NSString stringWithFormat:@"%@_aVatarImage.jpg", [QIYIPaopaoUserDefaultsUtil getMyUid]]];
        }];
    }
}
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (NSString*)saveImage:(UIImage*)tempImage withName:(NSString*)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage, 0.1);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"path: %@", paths);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    NSLog(@"fullPath: %@", fullPathToFile);
    [imageData writeToFile:fullPathToFile atomically:YES];
    return fullPathToFile;
}


@end
