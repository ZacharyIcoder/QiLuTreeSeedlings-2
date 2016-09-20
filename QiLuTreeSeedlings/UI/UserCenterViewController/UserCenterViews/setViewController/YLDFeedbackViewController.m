//
//  YLDFeedbackViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/5.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDFeedbackViewController.h"
#import "YLDRangeTextField.h"
#import "YLDRangeTextView.h"
#import "RSKImageCropper.h"
#import "UIButton+AFNetworking.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
@interface YLDFeedbackViewController ()<UIActionSheetDelegate,RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,weak) YLDRangeTextField *titleField;
@property (nonatomic,weak) YLDRangeTextView *messageField;
@property (nonatomic,weak) UIButton *imageBtn;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,weak) UIButton *deleteBtn;
@end

@implementation YLDFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"意见反馈";
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    [self.view addSubview:scrollView];
    [scrollView setBackgroundColor:BGColor];
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 10, kWidth, 180)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [scrollView addSubview:view1];
    UILabel *titleLabb=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 70, 30)];
    [titleLabb setTextColor:DarkTitleColor];
    [view1 addSubview:titleLabb];
    [titleLabb setTextAlignment:NSTextAlignmentRight];
    [titleLabb setFont:[UIFont systemFontOfSize:15]];
    [titleLabb setText:@"标题"];
    YLDRangeTextField *titleField=[[YLDRangeTextField alloc]initWithFrame:CGRectMake(110, 10, kWidth-130, 30)];
    titleField.rangeNumber=100;
    titleField.placeholder=@"请输入标题";
    self.titleField=titleField;
    [titleField setFont:[UIFont systemFontOfSize:15]];
    [titleField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [view1 addSubview:titleField];
    UIImageView *lineV1=[[UIImageView alloc]initWithFrame:CGRectMake(10, 50, kWidth-20, 0.5)];
    [lineV1 setBackgroundColor:kLineColor];
    [view1 addSubview:lineV1];
    UILabel *messageLabb=[[UILabel alloc]initWithFrame:CGRectMake(20, 60, 70, 30)];
    [messageLabb setTextColor:DarkTitleColor];
    [view1 addSubview:messageLabb];
    [messageLabb setTextAlignment:NSTextAlignmentRight];
    [messageLabb setFont:[UIFont systemFontOfSize:15]];
    [messageLabb setText:@"反馈内容"];
    YLDRangeTextView *messageTextView=[[YLDRangeTextView alloc]initWithFrame:CGRectMake(106, 59, kWidth-130, 100)];
    messageTextView.placeholder=@"请输入内容";
    messageTextView.rangeNumber=3000;
    [messageTextView setFont:[UIFont systemFontOfSize:15]];
    self.messageField=messageTextView;
    [view1 addSubview:messageTextView];
    
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0, 200, kWidth, 100)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [scrollView addSubview:view2];
    UILabel *imgLabb=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 70, 30)];
    [imgLabb setTextColor:DarkTitleColor];
    [view2 addSubview:imgLabb];
    [imgLabb setTextAlignment:NSTextAlignmentRight];
    [imgLabb setFont:[UIFont systemFontOfSize:15]];
    [imgLabb setText:@"图片"];
    UIButton *iamgeBtn=[[UIButton alloc]initWithFrame:CGRectMake(120, 10, 70, 80)];
    [iamgeBtn addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];
    [iamgeBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
    [view2 addSubview:iamgeBtn];
    self.imageBtn = iamgeBtn;
    UIButton *deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(50, 5, 15, 15)];
    [deleteBtn setImage:[UIImage imageNamed:@"delectLiteBtn"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    self.deleteBtn=deleteBtn;
    deleteBtn.hidden=YES;
    [iamgeBtn addSubview:deleteBtn];
    
    UIButton *tijiaoBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2-110, 380, 220, 40)];
    [tijiaoBtn setBackgroundColor:NavColor];
    [tijiaoBtn setTitle:@"反馈" forState:UIControlStateNormal];
    [tijiaoBtn addTarget:self action:@selector(tijiaoBtnAcion) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:tijiaoBtn];
    [scrollView setContentSize:CGSizeMake(0, 410)];
    // Do any additional setup after loading the view.
}
-(void)tijiaoBtnAcion
{
    if (self.titleField.text.length<=0) {
        
        [ToastView showTopToast:@"请输入标题"];
        return;
    }
    if (self.messageField.text.length<=0) {
        
        [ToastView showTopToast:@"请输入内容"];
        return;
    }
    [HTTPCLIENT yijianfankuiWithcontent:self.messageField.text Withpic:self.url WithTitle:self.titleField.text Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]==1) {
            [ToastView showTopToast:@"提交成功，即将返回上一页"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)deleteBtnAction
{
    [self.imageBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
    self.url=nil;
    self.deleteBtn.hidden=YES;
}
#pragma mark - 图片添加
//头像点击事件
- (void)addPicture
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        
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
    }
//    else if (buttonIndex == 0) {
//        
//        //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
//        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
//        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
//            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        }
//        //sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
//        //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
//        //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
//        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
//        picker.delegate = self;
//        picker.allowsEditing = YES;//设置可编辑
//        picker.sourceType = sourceType;
//        [self presentViewController:picker animated:YES completion:^{
//            
//        }];
//        //[self presentModalViewController:picker animated:YES];//进入照相界面
//    }
//    
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
    
    [self requestUploadHeadImage:croppedImage];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chooseUserPictureChange:(UIImage*)image
{
    //UIImage *photo = [UIImage imageNamed:@"photo"];
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCustom cropSize:CGSizeMake(kWidth, 1.2*kWidth)];
//    imageCropVC.cropMode = RSKImageCropModeSquare;
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:YES];
}
#pragma mark - 请求上传图片
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
        CGSize newSize = {400,600};
        imageData =  [self imageWithImageSimple:image scaledToSize:newSize];
    }
    NSString *myStringImageFile = [imageData base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
    
    [HTTPCLIENT upDataImageIOS:myStringImageFile workstationUid:nil companyUid:APPDELEGATE.GCGSModel.uid type:@"3" saveTyep:@"1" Success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        } else if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
            [ToastView showTopToast:@"添加成功"];
            NSDictionary *result = responseObject[@"result"];
            
             NSString * compressurl   = result[@"compressurl"];
            [self.imageBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:compressurl] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
            self.url         = result[@"url"];
            self.deleteBtn.hidden=NO;

        }
        
        
    } failure:^(NSError *error) {
        ;
    }];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
