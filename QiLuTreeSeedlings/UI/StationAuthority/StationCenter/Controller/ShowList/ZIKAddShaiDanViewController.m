//
//  ZIKAddShaiDanViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/5.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKAddShaiDanViewController.h"
#import "WHC_PhotoListCell.h"
#import "WHC_PictureListVC.h"
#import "ZIKFunction.h"
#import "HttpClient.h"
@interface ZIKAddShaiDanViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,WHC_ChoicePictureVCDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet BWTextView *contentBWTextView;
@property (weak, nonatomic) IBOutlet ZIKShaiDanPickImageView *pickImageView;

@property (nonatomic, strong) UIActionSheet    *myActionSheet;

@end

@implementation ZIKAddShaiDanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.vcTitle = @"新增晒单";
    self.leftBarBtnImgString = @"BackBtn";
    self.contentBWTextView.placeholder = @"请输入晒单内容";
    [self.pickImageView initUI];
    __weak typeof(self) weakSelf = self;//解决循环引用的问题

    self.pickImageView.takePhotoBlock = ^{
        [weakSelf openMenu];
    };
}


- (IBAction)sureButtonClick:(UIButton *)sender {
    __block NSString *urlSring      = @"";
    __block NSString *compressSring = @"";

    if (self.pickImageView.urlMArr.count>0) {
        [self.pickImageView.urlMArr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
            urlSring = [urlSring stringByAppendingString:[NSString stringWithFormat:@",%@",dic[@"url"]]];
            compressSring = [compressSring stringByAppendingString:[NSString stringWithFormat:@",%@",dic[@"compressurl"]]];
        }];
        if (self.pickImageView.urlMArr.count != 0) {
            urlSring         = [urlSring substringFromIndex:1];
            compressSring = [compressSring substringFromIndex:1];
        }
    }
    CLog(@"%@",compressSring);

    [HTTPCLIENT workstationShaiDanSaveWithUid:nil title:self.nameTextField.text content:self.contentBWTextView.text images:compressSring Success:^(id responseObject) {
        CLog(@"%@",responseObject);
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        } else if ([responseObject[@"success"] integerValue] == 1) {
            [ToastView showTopToast:@"上传成功"];
        }
    } failure:^(NSError *error) {
        ;
    }];

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
    vc.maxChoiceImageNumberumber = 10-self.pickImageView.urlMArr.count;
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
}

#pragma mark - WHC_ChoicePictureVCDelegate
-(void)WHCChoicePictureVCdidSelectedPhotoArr:(NSArray *)photoArr {
    //- (void)WHCChoicePictureVC:(WHC_ChoicePictureVC *)choicePictureVC didSelectedPhotoArr:(NSArray *)photoArr{
    for ( UIImage *image in photoArr) {
        NSData* imageData = nil;
        imageData  = [self  imageData:image];

        NSString *myStringImageFile = [imageData base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
        //NSLog(@"%ld",myStringImageFile.length);
        __weak typeof(self) weakSelf = self;

        [HTTPCLIENT upDataImageIOS:myStringImageFile workstationUid:nil companyUid:nil type:@"1" saveTyep:@"1" Success:^(id responseObject) {
            CLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
//                if (weakSelf.pickImageView.photos.count == 3) {
//                    return ;
//                }
                [weakSelf.pickImageView addImage:[UIImage imageWithData:imageData]  withUrl:responseObject[@"result"]];
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
            //CLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
//                if (weakSelf.pickImageView.photos.count == 3) {
//                    return ;
//                }
                [weakSelf.pickImageView addImage:[UIImage imageWithData:imageData]  withUrl:responseObject[@"result"]];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
