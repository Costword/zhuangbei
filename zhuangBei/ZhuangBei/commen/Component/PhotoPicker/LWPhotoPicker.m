
//
//  LWPhotoPicker.m
//  cs_weihai
//
//  Created by LWQ on 2019/8/15.
//  Copyright © 2019 LWQ. All rights reserved.
//

#import "LWPhotoPicker.h"

#import <UIKit/UIKit.h>

#import <AssetsLibrary/AssetsLibrary.h>
//#import <Photos/PhotosDefines.h>
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "PermissionKit.h"

@interface LWPhotoPicker ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,copy) PhotoOrAlbumImagePickerBlock photoBlock;   //-> 回掉
@property (nonatomic,strong) UIImagePickerController *picker; //-> 多媒体选择控制器

@property (nonatomic,assign) NSInteger sourceType;            //-> 媒体来源 （相册/相机）

@end


@implementation LWPhotoPicker

#pragma mark - 初始化
- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}


- (void)getPhotoAlbumOrTakeAPhotoWithController:(UIViewController *)controller photoBlock:(PhotoOrAlbumImagePickerBlock)photoBlock{
    self.photoBlock = photoBlock;
    self.viewController = controller;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAlbumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getAlertActionType:1];
    }];
    UIAlertAction *cemeraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getAlertActionType:2];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self getAlertActionType:0];
    }];
    [alertController addAction:photoAlbumAction];
    [alertController addAction:cancleAction];
    // 判断是否支持拍照
    [self imagePickerControlerIsAvailabelToCamera] ? [alertController addAction:cemeraAction]:nil;
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}



/**
 UIAlertController 点击事件 确定选择的媒体来源（相册/相机）
 
 @param type 点击的类型
 */
- (void)getAlertActionType:(NSInteger)type {
   __block NSInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (type == 1) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self creatUIImagePickerControllerWithAlertActionType:sourceType];
    }else if (type ==2){
        
        [PermissionKit checkCameraPermission:^(BOOL enable) {
            if (enable) {
                if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        sourceType = UIImagePickerControllerSourceTypeCamera;
                        [self creatUIImagePickerControllerWithAlertActionType:sourceType];
                    });
                }else{
                    NSLog(@"不支持拍照");
                }
            }
        }];
    }
    
}


/// 选择照片 通过c相册
/// @param allowsEditing 是否裁剪
- (void)photoPickerWithPhotoLibrary:(BOOL)allowsEditing photoBlock:(PhotoOrAlbumImagePickerBlock)photoBlock
{
    self.allowsEditing = allowsEditing;
    self.photoBlock = photoBlock;
    [self creatUIImagePickerControllerWithAlertActionType:UIImagePickerControllerSourceTypePhotoLibrary];
}

/// 选择照片 通过c相机
/// @param allowsEditing 是否裁剪
- (void)photoPickerWithCamera:(BOOL)allowsEditing photoBlock:(PhotoOrAlbumImagePickerBlock)photoBlock
{
    self.allowsEditing = allowsEditing;
    self.photoBlock = photoBlock;
    [self creatUIImagePickerControllerWithAlertActionType:UIImagePickerControllerSourceTypeCamera];
}

/**
 点击事件出发的方法
 
 @param type 媒体库来源 （相册/相机）
 */
- (void)creatUIImagePickerControllerWithAlertActionType:(NSInteger)type {
    self.sourceType = type;
    // 获取不同媒体类型下的授权类型
    NSInteger cameragranted = [self AVAuthorizationStatusIsGranted];
    // 如果确定未授权 cameragranted ==0 弹框提示；如果确定已经授权 cameragranted == 1；如果第一次触发授权 cameragranted == 2，这里不处理
    if (cameragranted == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请到设置-隐私-相机/相册中打开授权设置" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        }];
        [alertController addAction:comfirmAction];
        alertController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.viewController presentViewController:alertController animated:YES completion:nil];
    }else if (cameragranted == 1) {
        [self presentPickerViewController];
    }
}


// 判断硬件是否支持拍照
- (BOOL)imagePickerControlerIsAvailabelToCamera {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark - 照机/相册 授权判断
- (NSInteger)AVAuthorizationStatusIsGranted  {
    WEAKSELF(self);
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatusVedio = [AVCaptureDevice authorizationStatusForMediaType:mediaType];  // 相机授权
    PHAuthorizationStatus authStatusAlbm  = [PHPhotoLibrary authorizationStatus];                         // 相册授权
    NSInteger authStatus = self.sourceType == UIImagePickerControllerSourceTypePhotoLibrary ? authStatusAlbm:authStatusVedio;
    switch (authStatus) {
        case 0: { //第一次使用，则会弹出是否打开权限，如果用户第一次同意授权，直接执行再次调起
            if (self.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (status == PHAuthorizationStatusAuthorized) { //授权成功
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakself presentPickerViewController];
                        });
                    }
                }];
            }else{
                [AVCaptureDevice requestAccessForMediaType : AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) { //授权成功
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakself presentPickerViewController];
                        });
                        
                    }
                }];
            }
        }
            return 2;   //-> 不提示
        case 1: return 0; //-> 还未授权
        case 2: return 0; //-> 主动拒绝授权
        case 3: return 1; //-> 已授权
        default:return 0;
    }
}


/**
 如果第一次访问用户是否是授权，如果用户同意 直接再次执行
 */
-(void)presentPickerViewController{
//<<<<<<< HEAD
    self.picker = [[UIImagePickerController alloc] init];
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAlways];
    }
    self.picker.delegate = self;
    self.picker.allowsEditing = _allowsEditing;          //-> 是否允许选取的图片可以裁剪编辑
    self.picker.sourceType = self.sourceType; //-> 媒体来源（相册/相机）
    self.picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.viewController presentViewController:self.picker animated:YES completion:nil];
//=======
//
//    [PermissionKit checkCameraPermission:^(BOOL enable) {
//        if (enable) {
//            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
//                dispatch_async(dispatch_get_main_queue(), ^{
//                   self.picker = [[UIImagePickerController alloc] init];
//                   if (@available(iOS 11.0, *)){
//                       [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAlways];
//                   }
//                   self.picker.delegate = self;
//                    self.picker.allowsEditing = self->_allowsEditing;          //-> 是否允许选取的图片可以裁剪编辑
//                   self.picker.sourceType = self.sourceType; //-> 媒体来源（相册/相机）
//                   [self.viewController presentViewController:self.picker animated:YES completion:nil];
//                });
//            }else{
//                NSLog(@"不支持拍照");
//            }
//        }
//    }];
//>>>>>>> 60527c0b9794507484621887484245455ff640c7
}


#pragma mark - UIImagePickerControllerDelegate
// 点击完成按钮的选取图片的回掉
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // 获取编辑后的图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    // 如果裁剪的图片不符合标准 就会为空，直接使用原图
    image == nil    ?  image = [info objectForKey:UIImagePickerControllerOriginalImage] : nil;
    image = [image fixOrientation];
    self.photoBlock ?  self.photoBlock(image): nil;
    [picker dismissViewControllerAnimated:YES completion:^{
        // 这个部分代码 视情况而定
        if (@available(iOS 11.0, *)){
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    }];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        // 这个部分代码 视情况而定
        if (@available(iOS 11.0, *)){
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    }];
}

@end
