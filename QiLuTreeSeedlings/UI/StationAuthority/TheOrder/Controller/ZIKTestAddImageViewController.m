//
//  ZIKTestAddImageViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/14.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKTestAddImageViewController.h"
#import "ZIKAddPickerView.h"
#import "ZIKPickImageView.h"

#import "WHC_PhotoListCell.h"
#import "WHC_PictureListVC.h"
@interface ZIKTestAddImageViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,WHC_ChoicePictureVCDelegate>
//@property (nonatomic, strong) ZIKAddPickerView *pickerImgView;
@property (nonatomic, strong) UIActionSheet    *myActionSheet;
@property (nonatomic, weak  ) ZIKPickImageView *pickerImgView;


@end

@implementation ZIKTestAddImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.vcTitle = @"测试上传图片";
//
//    self.pickerImgView = [[ZIKPickImageView alloc] init];
//    self.pickerImgView.frame =  CGRectMake(20, 120, 80, 80);
//    self.pickerImgView.backgroundColor = [UIColor whiteColor];
//    self.pickerImgView.userInteractionEnabled = YES;
//    [self.view addSubview:self.pickerImgView];
//    //        [cell.contentView addSubview:self.addImageBGView];
//    __weak typeof(self) weakSelf = self;//解决循环引用的问题
//
//    self.pickerImgView.takePhotoBlock = ^{
//        [weakSelf openMenu];
//    };

    ZIKPickImageView *pickView = [[ZIKPickImageView alloc] initWithFrame:CGRectMake(0, 200, Width, 126)];
    //pickView.backgroundColor = [UIColor yellowColor];
    pickView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:pickView];
    self.pickerImgView = pickView;
    __weak typeof(self) weakSelf = self;
    self.pickerImgView.takePhotoBlock = ^{
        [weakSelf openMenu];
    };


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)openMenu
{
    //在这里呼出下方菜单按钮项
    self.myActionSheet = [[UIActionSheet alloc]
                          initWithTitle:nil
                          delegate:self
                          cancelButtonTitle:@"取消"
                          destructiveButtonTitle:nil
                          otherButtonTitles: @"拍摄新照片", @"从相册中选取",nil];

    [self.myActionSheet showInView:self.view];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.myActionSheet) {
        //呼出的菜单按钮点击后的响应
        if (buttonIndex == self.myActionSheet.cancelButtonIndex)
        {
            //取消
        }
        switch (buttonIndex)
        {
            case 0:  //打开照相机拍照
                [self takePhoto];
                break;

            case 1:  //打开本地相册
                [self LocalPhoto];
                break;
        }
    }else {

    }

}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        //        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    WHC_PictureListVC  * vc = [WHC_PictureListVC new];
    vc.delegate = self;
    vc.maxChoiceImageNumberumber = 3-self.pickerImgView.urlMArr.count;
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];

    //    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    picker.navigationBar.barTintColor = NavColor;
    //
    //    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    picker.delegate = self;
    //    //设置选择后的图片可被编辑
    //    //    picker.allowsEditing = YES;
    //    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - WHC_ChoicePictureVCDelegate
-(void)WHCChoicePictureVCdidSelectedPhotoArr:(NSArray *)photoArr {
    //- (void)WHCChoicePictureVC:(WHC_ChoicePictureVC *)choicePictureVC didSelectedPhotoArr:(NSArray *)photoArr{
    for ( UIImage *image in photoArr) {
        NSData* imageData = nil;
        imageData  = [self  imageData:image];
        //NSLog(@"%ld",imageData.length);
        //imageData = [self imageWithImageSimple:image scaledToSize:<#(CGSize)#>]

        NSString *myStringImageFile = [imageData base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
        //NSLog(@"%ld",myStringImageFile.length);
        __weak typeof(self) weakSelf = self;

        [HTTPCLIENT upDataImageIOS:myStringImageFile workstationUid:nil companyUid:nil type:@"3" saveTyep:@"1" Success:^(id responseObject) {
            CLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
                if (weakSelf.pickerImgView.photos.count == 3) {
                    return ;
                }
                [weakSelf.pickerImgView addImage:[UIImage imageWithData:imageData]  withUrl:responseObject[@"result"]];
                //                [weakSelf.pickerImgView addImage:[UIImage imageWithData:imageData]  withUrl:responseObject[@"result"]];
                //                [weakSelf.pickerImgView addImage:[UIImage imageWithData:imageData]  withUrl:responseObject[@"result"]];
                [ToastView showToast:@"图片上传成功" withOriginY:250 withSuperView:weakSelf.view];
            }
            else {
                //NSLog(@"图片上传失败");
                [ToastView showToast:@"上传图片失败" withOriginY:250 withSuperView:weakSelf.view];
                [UIColor darkGrayColor];
            }

        } failure:^(NSError *error) {
            ;
        }];
    }
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];

    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        __weak  UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData* imageData = nil;
        imageData  = [self imageData:image];
        //NSLog(@"%ld",imageData.length);
        __weak typeof(self) weakSelf = self;

        NSString *myStringImageFile = [imageData base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
        //NSLog(@"%ld",myStringImageFile.length);
        [HTTPCLIENT upDataImageIOS:myStringImageFile workstationUid:nil companyUid:nil type:@"3" saveTyep:@"1" Success:^(id responseObject) {
            CLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
                if (weakSelf.pickerImgView.photos.count == 3) {
                    return ;
                }
                [weakSelf.pickerImgView addImage:[UIImage imageWithData:imageData]  withUrl:responseObject[@"result"]];
                //                [weakSelf.pickerImgView addImage:[UIImage imageWithData:imageData]  withUrl:responseObject[@"result"]];
                //                [weakSelf.pickerImgView addImage:[UIImage imageWithData:imageData]  withUrl:responseObject[@"result"]];
                [ToastView showToast:@"图片上传成功" withOriginY:250 withSuperView:weakSelf.view];
            }
            else {
                //NSLog(@"图片上传失败");
                [ToastView showToast:@"上传图片失败" withOriginY:250 withSuperView:weakSelf.view];
                [UIColor darkGrayColor];
            }

        } failure:^(NSError *error) {
            ;
        }];

        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        [ToastView showTopToast:@"暂不支持此图片格式,请换张图片"];
    }

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(NSData *)imageData:(UIImage *)myimage
{
    __weak typeof(myimage) weakImage = myimage;
    NSData *data = UIImageJPEGRepresentation(weakImage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data = UIImageJPEGRepresentation(weakImage, 0.1);
        }
        else if (data.length>512*1024) {//0.5M-1M
            data = UIImageJPEGRepresentation(weakImage, 0.9);
        }
        else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(weakImage, 0.9);
        }
    }
    return data;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
