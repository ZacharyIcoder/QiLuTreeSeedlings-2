    //
//  YLDShopBaseInfoViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/26.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDShopBaseInfoViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "YLDGCZXInfoTableViewCell.h"
#import "YLDGCZXTouxiangTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "YLDShopNameViewController.h"
#import "RSKImageCropper.h"
#import "YLDShopJianJieViewController.h"
#import "YLDShopPresonViewController.h"
#import "YLDShopPhoneViewController.h"
#import "LYDShopAddressViewController.h"
@interface YLDShopBaseInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)YLDGCZXTouxiangTableViewCell *touxiangCell;
@property (nonatomic,copy) NSDictionary *dic;
@end

@implementation YLDShopBaseInfoViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [HTTPCLIENT getMyShopBaseMessageSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            self.dic=[[responseObject objectForKey:@"result"] objectForKey:@"shopinfo"];
            [self.tableView reloadData];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"基本信息";
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    tableView.delegate=self;
    tableView.dataSource=self;
    [tableView setBackgroundColor:BGColor];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView=tableView;
    [self.view addSubview:tableView];
    ShowActionV();
    // Do any additional setup after loading the view.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        [self addPicture];
    }
    if (indexPath.row==1) {
        YLDShopNameViewController *vc=[[YLDShopNameViewController alloc]initWithMessage:[self.dic objectForKey:@"shopName"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==2) {
        
        YLDShopJianJieViewController *vc=[[YLDShopJianJieViewController alloc]initWithMessage:[self.dic objectForKey:@"brief"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==3) {
        
        YLDShopPresonViewController *vc=[[YLDShopPresonViewController alloc]initWithMessage:[self.dic objectForKey:@"chargelPerson"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==4) {
        
        YLDShopPhoneViewController *vc=[[YLDShopPhoneViewController alloc]initWithMessage:[self.dic objectForKey:@"phone"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==5) {
        LYDShopAddressViewController *vc=[[LYDShopAddressViewController alloc]initWithshopProvince:[self.dic objectForKey:@"shopProvince"] withshopCity:[self.dic objectForKey:@"shopCity"] withshopCounty:[self.dic objectForKey:@"shopCounty"] withshopAddress:[self.dic objectForKey:@"shopAddress"] WithareaAddress:[self.dic objectForKey:@"areaAddress"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2) {
        return 60;
    }
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
     
    
        
        YLDGCZXTouxiangTableViewCell *  cell=[YLDGCZXTouxiangTableViewCell yldGCZXTouxiangTableViewCell];

        cell.titleLab.text=@"店铺头像";
        NSString *urlStr=[self.dic objectForKey:@"shopHeadUrl"];
        if (urlStr.length>0) {
               [cell.imagev setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"Store.png"]];
        }else{
            [cell.imagev setImage:[UIImage imageNamed:@"Store.png"]];
        }
   
        self.touxiangCell=cell;
        return cell;
    }else{
        YLDGCZXInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDGCZXInfoTableViewCell"];
        if (!cell) {
            cell=[YLDGCZXInfoTableViewCell yldGCZXInfoTableViewCell];
        }
        if (indexPath.row==1) {
            cell.titleLab.text=@"店铺名称";
            cell.NameLab.text=[self.dic objectForKey:@"shopName"];
            
        }
        if (indexPath.row==2) {
            cell.titleLab.text=@"店铺简介";
            cell.NameLab.text=[self.dic objectForKey:@"brief"];
            
        }
        if (indexPath.row==3) {
            cell.titleLab.text=@"联系人";
            cell.NameLab.text=[self.dic objectForKey:@"chargelPerson"];
//            cell.NameLab.text=APPDELEGATE.GCGSModel.address;
            
        }
        if (indexPath.row==4) {
            cell.titleLab.text=@"联系方式";
           cell.NameLab.text=[self.dic objectForKey:@"phone"];
            
        }
        if (indexPath.row==5) {
            cell.titleLab.text=@"所在地";
            NSString *are1=[self.dic objectForKey:@"areaAddress"];
            NSString *are2=[self.dic objectForKey:@"shopAddress"];

            if (are1.length>0) {
                cell.NameLab.text=[NSString stringWithFormat:@"%@%@",are1,are2];
            }
            
        }
        if (indexPath.row==5) {
            cell.lineV.hidden=YES;
        }else
        {
            cell.lineV.hidden=NO;
            if (indexPath.row==2) {
                CGRect frame=cell.lineV.frame;
                frame.size.height=10;
                frame.origin.x=0;
                frame.size.width=kWidth;
                cell.lineV.frame=frame;
                [cell.lineV setBackgroundColor:BGColor];
                
            }
        }
        return cell;
    }
    
}
#pragma mark - 图片添加
//头像点击事件
- (void)addPicture
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"修改店铺头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄新照片",@"从相册选取", nil];
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
    
    [self requestUploadHeadImage:croppedImage];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chooseUserPictureChange:(UIImage*)image
{
    //UIImage *photo = [UIImage imageNamed:@"photo"];
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeSquare];
    
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
        CGSize newSize = {150,150};
        imageData =  [self imageWithImageSimple:image scaledToSize:newSize];
    }
    NSString *myStringImageFile = [imageData base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
    
    [HTTPCLIENT upDataImageIOS:myStringImageFile workstationUid:nil companyUid:nil type:nil saveTyep:@"4" Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            
            NSString *backUrl=[[responseObject objectForKey:@"result"] objectForKey:@"compressurl"];
            
            [self.touxiangCell.imagev setImageWithURL:[NSURL URLWithString:backUrl] placeholderImage:[UIImage imageNamed:@"Store.png"]];
            [ToastView showTopToast:@"上传成功"];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
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
