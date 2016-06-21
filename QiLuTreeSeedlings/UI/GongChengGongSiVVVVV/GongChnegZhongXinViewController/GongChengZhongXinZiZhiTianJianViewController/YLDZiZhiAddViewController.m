//
//  YLDZiZhiAddViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDZiZhiAddViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "YLDPickTimeView.h"
#import "UIButton+AFNetworking.h"
#import "RSKImageCropper.h"
@interface YLDZiZhiAddViewController ()<UINavigationControllerDelegate,UIActionSheetDelegate,RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate,YLDPickTimeDelegate>
@property (nonatomic,weak)UIScrollView *backScrollView;
@property (nonatomic,weak) UITextField *nameTextField;
@property (nonatomic,weak) UITextField *rankTextField;
@property (nonatomic,weak) UITextField *organizationalField;
@property (nonatomic,copy) NSString *timeStr;
@property (nonatomic,weak) UIButton *timeBtn;
@property (nonatomic,weak) UIButton *imageBtn;
@end

@implementation YLDZiZhiAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"资质添加";
    UIScrollView *backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    [backScrollView setBackgroundColor:BGColor];
    self.backScrollView=backScrollView;
    [self.view addSubview:backScrollView];
    CGRect tempFrame=CGRectMake(0, 5, kWidth, 50);
    self.nameTextField=[self makeViewWithName:@"资质名称" alert:@"请输入资质名称" unit:@"" withFrame:tempFrame];
    tempFrame.origin.y+=50;
    self.timeBtn=[self danxuanViewWithName:@"获取时间" alortStr:@"请选择获取时间" andFrame:tempFrame];
    [self.timeBtn addTarget:self action:@selector(timeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    tempFrame.origin.y+=50;
    self.rankTextField=[self makeViewWithName:@"资质等级" alert:@"请输入资质等级" unit:@"" withFrame:tempFrame];
    tempFrame.origin.y+=50;
    self.organizationalField=[self makeViewWithName:@"发证机关" alert:@"请输入发证机关" unit:@"" withFrame:tempFrame];
    tempFrame.origin.y+=55;
    tempFrame.size.height=110;
    UIView *phoneView=[[UIView alloc]initWithFrame:tempFrame];
    [phoneView setBackgroundColor:[UIColor whiteColor]];
    [self.backScrollView addSubview:phoneView];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, kWidth*0.3, 44)];
    nameLab.text=@"荣誉图片";
    [nameLab setTextColor:DarkTitleColor];
    [nameLab setFont:[UIFont systemFontOfSize:15]];
    
    [phoneView addSubview:nameLab];
    UIButton *imageBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*0.35, 10, 85, 90)];
    [phoneView addSubview:imageBtn];
    [imageBtn addTarget:self action:@selector(imageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.imageBtn=imageBtn;
    [imageBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
    tempFrame.origin.y+=130;
    tempFrame.size.height=45;
    tempFrame.origin.x=40;
    tempFrame.size.width=kWidth-80;
    UIButton *sureBtn=[[UIButton alloc]initWithFrame:tempFrame];
    [sureBtn setBackgroundColor:NavColor];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget: self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backScrollView addSubview:sureBtn];
    [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(tempFrame))];
    // Do any additional setup after loading the view.
}
-(void)sureBtnAction
{
    
}
-(void)imageBtnAction:(UIButton *)sender
{
    [self addPicture];
}
-(UITextField *)makeViewWithName:(NSString *)name alert:(NSString *)alert unit:(NSString *)unit withFrame:(CGRect)frame
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, kWidth*0.3, frame.size.height)];
    nameLab.text=name;
    [nameLab setTextColor:DarkTitleColor];
    [nameLab setFont:[UIFont systemFontOfSize:15]];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:nameLab];
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth*0.35, 0, kWidth*0.53, 44)];
    [textField setFont:[UIFont systemFontOfSize:15]];
    textField.clearButtonMode=UITextFieldViewModeWhileEditing;
//    if ([name isEqualToString:@"电话"]) {
//        textField.keyboardType=UIKeyboardTypePhonePad;
//    }
//    if ([name isEqualToString:@"企业名称"]||[name isEqualToString:@"企业地址"]||[name isEqualToString:@"地区"]||[name isEqualToString:@"法人代表"]||[name isEqualToString:@"电话"]) {
//        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-40, 0,10 , frame.size.height)];
//        [lab setTextColor:yellowButtonColor];
//        [lab setText:@"*"];
//        [view addSubview:lab];
//    }
    textField.placeholder=alert;
    [view addSubview:textField];
    [textField setTextColor:detialLabColor];
    UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 49.5, kWidth-20, 0.5)];
    [lineView setBackgroundColor:kLineColor];
    [view addSubview:lineView];
    [self.backScrollView addSubview:view];
    [view setBackgroundColor:[UIColor whiteColor]];
    return textField;
}

-(UIButton *)danxuanViewWithName:(NSString *)nameStr alortStr:(NSString *)alortStr andFrame:(CGRect)frame
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 90, frame.size.height)];
    [nameLab setText:nameStr];
    [view addSubview:nameLab];
    [nameLab setTextColor:DarkTitleColor];
    [nameLab setFont:[UIFont systemFontOfSize:15]];
    UIButton *pickBtn=[[UIButton alloc]initWithFrame:CGRectMake(110, 0, 160/320.f*kWidth, frame.size.height)];
    pickBtn.center=CGPointMake(frame.size.width/2+10,frame.size.height/2);
    [pickBtn setEnlargeEdgeWithTop:7 right:100 bottom:7 left:80];
    [pickBtn setTitle:alortStr forState:UIControlStateNormal];
    [pickBtn setTitleColor:titleLabColor forState:UIControlStateNormal];
    [pickBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    UIImageView *lineImagV=[[UIImageView alloc]initWithFrame:CGRectMake(10,frame.size.height-0.5, kWidth-20, 0.5)];
    [lineImagV setBackgroundColor:kLineColor];
    [view addSubview:lineImagV];
//    UIImageView *imageVVV=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-42.5, 15, 15, 15)];
//    [imageVVV setImage:[UIImage imageNamed:@"xiala2"]];
//    [view addSubview:imageVVV];
    
    [view addSubview:pickBtn];
    [self.backScrollView addSubview:view];
    return pickBtn;
}
-(void)timeBtnAction:(UIButton *)sender
{
    YLDPickTimeView *pickTimeView=[[YLDPickTimeView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    pickTimeView.delegate=self;
    [pickTimeView showInView];
    
}
-(void)timeDate:(NSDate *)selectDate andTimeStr:(NSString *)timeStr
{
    self.timeStr=timeStr;
    [self.timeBtn setTitle:timeStr forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 图片添加
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
   // [self requestUploadHeadImage:croppedImage];
    [self.imageBtn setImage:croppedImage forState:UIControlStateNormal];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
