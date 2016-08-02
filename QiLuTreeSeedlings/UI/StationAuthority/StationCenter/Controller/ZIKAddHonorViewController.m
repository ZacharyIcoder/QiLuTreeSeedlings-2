//
//  ZIKAddHonorViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/4.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKAddHonorViewController.h"
#import "RSKImageCropper.h"
#import "UIButton+AFNetworking.h"
#import "YLDPickTimeView.h"
#import "ZIKFunction.h"
@interface ZIKAddHonorViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,YLDPickTimeDelegate>
@property (weak, nonatomic) IBOutlet UITextField *honorNameTextField;
//@property (weak, nonatomic) IBOutlet UITextField *honorTimeTextField;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@property (weak, nonatomic) IBOutlet UIButton *honorTimeButton;

@property (nonatomic, strong) NSString *honorCompressUrl;
@property (nonatomic, strong) NSString *honorDetailUrl;
@property (nonatomic, strong) NSString *honorUrl;

@property (nonatomic,copy) NSString *timeStr;

@end

@implementation ZIKAddHonorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.vcTitle = @"添加荣誉";
    [self.honorNameTextField setValue:detialLabColor forKeyPath:@"_placeholderLabel.textColor"];
    if (self.uid) {
        [HTTPCLIENT stationHonorDetailWithUid:_uid Success:^(id responseObject) {
            if ([responseObject[@"success"] integerValue] == 0) {
                [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
                return ;
            }
            NSDictionary *resultDic      = responseObject[@"result"];
            NSDictionary *honorDic       = resultDic[@"honor"];
            self.uid                     = honorDic[@"uid"];
            self.workstationUid          = honorDic[@"workstationUid"];
//            self.honorTimeTextField.text = honorDic[@"acqueTime"];
            [self.honorTimeButton setTitle:honorDic[@"acqueTime"] forState:UIControlStateNormal];
            self.honorNameTextField.text = honorDic[@"name"];
            self.honorCompressUrl        = honorDic[@"image"];
            NSURL *url = [NSURL URLWithString:self.honorCompressUrl];
            [self.addImageButton setBackgroundImageForState:UIControlStateNormal withURL:url placeholderImage:[UIImage imageNamed:@"MoRentu"]];
        } failure:^(NSError *error) {
            ;
        }];
    }
}
- (IBAction)honorButtonClick:(UIButton *)sender {
    
    YLDPickTimeView *pickTimeView = [[YLDPickTimeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    pickTimeView.delegate = self;
    pickTimeView.pickerView.maximumDate = [NSDate new];
    pickTimeView.pickerView.minimumDate = nil;
    [pickTimeView showInView];
    [self.honorNameTextField resignFirstResponder];
 }

-(void)timeDate:(NSDate *)selectDate andTimeStr:(NSString *)timeStr
{
    self.timeStr = timeStr;
    [self.honorTimeButton setTitleColor:detialLabColor forState:UIControlStateNormal];
    [self.honorTimeButton setTitle:timeStr forState:UIControlStateNormal];
}

- (IBAction)sureButtonClick:(UIButton *)sender {
    [self.honorNameTextField resignFirstResponder];
//    [self.honorTimeTextField resignFirstResponder];

    NSString *name = nil;
    NSString *time = nil;
    name = self.honorNameTextField.text;
//    time = self.honorTimeTextField.text;
    time = self.honorTimeButton.titleLabel.text;

    if ([ZIKFunction xfunc_check_strEmpty:name]) {
        [ToastView showTopToast:@"请输入荣誉名称"];
        return;
    }
    if ([ZIKFunction xfunc_check_strEmpty:time] || [time isEqualToString:@"请选择获取时间"]) {
        [ToastView showTopToast:@"请选择获取时间"];
        return;
    }
    if ([ZIKFunction xfunc_check_strEmpty:_honorCompressUrl]) {
        [ToastView showTopToast:@"请添加荣誉图片"];
        return;
    }
    NSString *uid = nil;
    if (self.uid) {
        uid = self.uid;
    }
    [HTTPCLIENT stationHonorCreateWithUid:uid workstationUid:_workstationUid name:name acquisitionTime:time image:_honorCompressUrl Success:^(id responseObject) {
        //CLog(@"result:%@",responseObject);
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        }
        [ToastView showTopToast:@"添加成功"];
        [self.navigationController popViewControllerAnimated:YES];

    } failure:^(NSError *error) {
        ;
    }];
}

- (IBAction)addImageButttonClick {
    [self.honorNameTextField resignFirstResponder];
//    [self.honorTimeTextField resignFirstResponder];
    [self addPicture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 添加荣誉图片事件
//添加荣誉图片事件
- (void)addPicture
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"添加荣誉图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄新照片",@"从相册选取", nil];
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
    }else if (buttonIndex == 0) {

        //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
         UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{

        }];
    }

}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //修改图片
    [self chooseUserPictureChange:image];
}

#pragma mark - RSKImageCropViewControllerDelegate
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;

}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage
{
    [self requestUploadHeadImage:croppedImage];
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
  }

- (void)chooseUserPictureChange:(UIImage*)image
{
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCircle];
    imageCropVC.cropMode = RSKImageCropModeSquare;
    imageCropVC.delegate = self;
    imageCropVC.navigationController.navigationBar.hidden = YES;
    [self.navigationController pushViewController:imageCropVC animated:YES];
}

#pragma mark - 请求上传头像
- (void)requestUploadHeadImage:(UIImage *)image {
    NSData* imageData;
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(image)) {
        //返回为png图像。
        imageData = UIImagePNGRepresentation(image);
    }else {
        //返回为JPEG图像。
        imageData = UIImageJPEGRepresentation(image, 0.0001);
    }
    if (imageData.length>=1024*1024) {
        if (image.size.width>916 && image.size.height>681) {
            CGSize newSize = {916,681};
            imageData =  [self imageWithImageSimple:image scaledToSize:newSize];

        } else {
            CGFloat mywidth = image.size.width/2;
            CGFloat myheight = image.size.height/2;
            CGSize newSize = {mywidth,myheight};
            imageData =  [self imageWithImageSimple:image scaledToSize:newSize];
        }
    }
    NSString *myStringImageFile = [imageData base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];

    [HTTPCLIENT upDataImageIOS:myStringImageFile workstationUid:nil companyUid:nil type:@"3" saveTyep:@"1" Success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        } else if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
            NSDictionary *result = responseObject[@"result"];
            self.honorCompressUrl = result[@"compressurl"];
            self.honorDetailUrl   = result[@"detailurl"];
            self.honorUrl         = result[@"url"];
            [self.addImageButton setBackgroundImage:image forState:UIControlStateNormal];
        }


    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
//    NSData* imageData;
//    //判断图片是不是png格式的文件
//    if (UIImagePNGRepresentation(image)) {
//        //返回为png图像。
//        imageData = UIImagePNGRepresentation(image);
//    }else {
//        //返回为JPEG图像。
//        imageData = UIImageJPEGRepresentation(image, 0.0001);
//    }
//    if (imageData.length>=1024*1024) {
//        CGSize newSize = {600,600};
//        imageData =  [self imageWithImageSimple:image scaledToSize:newSize];
//    }
//    NSString *myStringImageFile = [imageData base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
//
//
//    [HTTPCLIENT upDataImageIOS:myStringImageFile workstationUid:nil companyUid:nil type:@"3" saveTyep:@"1" Success:^(id responseObject) {
//        //        CLog(@"%@",responseObject);
//        if ([responseObject[@"success"] integerValue] == 0) {
//            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
//            return ;
//        } else if ([responseObject[@"success"] integerValue] == 1) {
//                        NSDictionary *result = responseObject[@"result"];
//                        self.honorCompressUrl = result[@"compressurl"];
//                        self.honorDetailUrl   = result[@"detailurl"];
//                        self.honorUrl         = result[@"url"];
//                        [self.addImageButton setBackgroundImage:image forState:UIControlStateNormal];
//
//        }
//    } failure:^(NSError *error) {
//        ;
//    }];


}

-(NSData*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();

    // End the context
    UIGraphicsEndImageContext(); 
    // Return the new image.

    return UIImagePNGRepresentation(newImage);
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.honorNameTextField resignFirstResponder];
//    [self.honorTimeTextField resignFirstResponder];
}
@end
