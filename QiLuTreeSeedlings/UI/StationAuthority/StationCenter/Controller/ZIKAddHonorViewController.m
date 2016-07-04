//
//  ZIKAddHonorViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/4.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKAddHonorViewController.h"
#import "RSKImageCropper.h"

@interface ZIKAddHonorViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *honorNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *honorTimeTextField;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;

@end

@implementation ZIKAddHonorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.vcTitle = @"添加荣誉";
}

- (IBAction)sureButtonClick:(UIButton *)sender {

    NSString *name = nil;
    NSString *time = nil;
    name = self.honorNameTextField.text;
    time = self.honorTimeTextField.text;

    [HTTPCLIENT stationHonorCreateWithUid:nil workstationUid:nil name:name acquisitionTime:time image:nil Success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        }


    } failure:^(NSError *error) {
        ;
    }];
}

- (IBAction)addImageButttonClick {
    [self addPicture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 头像点击事件
//头像点击事件
- (void)addPicture
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"修改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄新照片",@"从相册选取", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 1) {

        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = NO;
        [self presentViewController:pickerImage animated:YES completion:^{

        }];
        //[self presentModalViewController:pickerImage animated:YES];
    }else if (buttonIndex == 0) {

        //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        //sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
        //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
        //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{

        }];
        //[self presentModalViewController:picker animated:YES];//进入照相界面
    }

}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //修改图片
    [self chooseUserPictureChange:image];
}

#pragma mark - RSKImageCropViewControllerDelegate
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage
{
    //_globalHeadImage = croppedImage;
    //NSData *temData = UIImageJPEGRepresentation(_globalHeadImage, 0.00001);
    //NSData *temData = UIImagePNGRepresentation(_globalHeadImage);
    [self requestUploadHeadImage:croppedImage];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chooseUserPictureChange:(UIImage*)image
{
    //UIImage *photo = [UIImage imageNamed:@"photo"];
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCircle];
    imageCropVC.cropMode = RSKImageCropModeSquare;
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:YES];
}

#pragma mark - 请求上传头像
- (void)requestUploadHeadImage:(UIImage *)image {
//    [HTTPCLIENT upDataUserImageWithToken:nil WithAccessID:nil WithClientID:nil WithClientSecret:nil WithDeviceID:nil WithUserIamge:image Success:^(id responseObject) {
//        //NSLog(@"%@",responseObject);
//        if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
//            [ToastView showTopToast:@"上传成功"];
//            _globalHeadImage = image;
//            cellHeadImageView.image = _globalHeadImage;
//            //[self.myTalbeView reloadData];
//            APPDELEGATE.userModel.headUrl = responseObject[@"url"];
//        }
//        else {
//            //NSLog(@"%@",responseObject[@"msg"]);
//            [ToastView showTopToast:responseObject[@"msg"]];
//        }
//    } failure:^(NSError *error) {
//        //NSLog(@"%@",error);
//    }];

    [HTTPCLIENT upDataImageIOS:nil workstationUid:nil type:@"3" Success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        } else if ([[responseObject objectForKey:@"success"] integerValue] == 1) {

        }


    } failure:^(NSError *error) {
        ;
    }];
}


@end
