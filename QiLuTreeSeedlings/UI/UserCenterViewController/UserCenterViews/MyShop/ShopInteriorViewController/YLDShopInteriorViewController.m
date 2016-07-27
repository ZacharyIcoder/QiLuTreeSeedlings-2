//
//  YLDShopInteriorViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/26.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDShopInteriorViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "UIImageView+AFNetworking.h"
#import "ZIKGongyingWeihuViewController.h"//供应列表维护
#import "ZIKQiugouWeihuViewController.h"//求购列表维护
#import "YLDShopBaseInfoViewController.h"
#import "RSKImageCropper.h"
@interface YLDShopInteriorViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSDictionary *dic;
@property (nonatomic,weak) UIImageView *imageVV;
@end

@implementation YLDShopInteriorViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [HTTPCLIENT getShopInoterMessageSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            self.dic=[responseObject objectForKey:@"result"];
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
    self.vcTitle=@"店铺装修";
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    tableView.delegate=self;
    tableView.dataSource=self;
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
        YLDShopBaseInfoViewController *vc=[[YLDShopBaseInfoViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==1) {
        [self addPicture];
    }
    if (indexPath.row == 2) {
        ZIKGongyingWeihuViewController *gywhVC = [[ZIKGongyingWeihuViewController alloc] initWithNibName:@"ZIKGongyingWeihuViewController" bundle:nil];
        [self.navigationController pushViewController:gywhVC animated:YES];
    }
    if (indexPath.row == 3) {
        ZIKQiugouWeihuViewController *qgwhVC = [[ZIKQiugouWeihuViewController alloc] initWithNibName:@"ZIKQiugouWeihuViewController" bundle:nil];
        [self.navigationController pushViewController:qgwhVC animated:YES];
    }
   
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"UITableViewCell%ld",indexPath.row]];
    
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NSString stringWithFormat:@"UITableViewCell%ld",indexPath.row]];
        CGRect frame=cell.frame;
        frame.size.height=50;
        cell.frame=frame;
        UIView *lineImagV=[[UIView alloc]initWithFrame:CGRectMake(10, 49.5, kWidth-20, 0.5)];
        [lineImagV setBackgroundColor:kLineColor];
        [cell addSubview:lineImagV];
        cell.textLabel.textColor=DarkTitleColor;
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        cell.detailTextLabel.textColor=detialLabColor;
         [cell.detailTextLabel setFont:[UIFont systemFontOfSize:16]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row==1) {
            UIImageView *zhaopaiImageV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-200, 10, 165, 30)];
            self.imageVV=zhaopaiImageV;
            zhaopaiImageV.tag=100;
            [cell.contentView addSubview:zhaopaiImageV];
        }
    }
    if (indexPath.row==0) {
        cell.textLabel.text=@"基本信息";
    }
    if (indexPath.row==1) {
        cell.textLabel.text=@"店铺招牌";
        NSString *backUrl=[self.dic objectForKey:@"background"];
           UIImageView *iamgeV=[cell.contentView viewWithTag:100];
        
        if (backUrl.length>0) {
         
            [iamgeV setImageWithURL:[NSURL URLWithString:backUrl] placeholderImage:[UIImage imageNamed:@"SHOPBACKVIEW"]];
        }else{
           [iamgeV setImage:[UIImage imageNamed:@"SHOPBACKVIEW"]];
        }
    }
    if (indexPath.row==2) {
//        cell.
        cell.textLabel.text=@"推荐供应管理";
        if (self.dic) {
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%ld/10",[[self.dic objectForKey:@"supplyCount"] integerValue]];
        }else{
            cell.detailTextLabel.text=@"0/10";
        }
    }
    if (indexPath.row==3) {
        cell.textLabel.text=@"推荐求购管理";
        if (self.dic) {
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%ld/10",[[self.dic objectForKey:@"buyCount"] integerValue]];
        }else{
            cell.detailTextLabel.text=@"0/10";
        }
    }
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 图片添加
//头像点击事件
- (void)addPicture
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"修改店铺背景" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄新照片",@"从相册选取", nil];
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
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCustom cropSize:CGSizeMake(kWidth, 100)];

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
        CGSize newSize = {kWidth,200};
        imageData =  [self imageWithImageSimple:image scaledToSize:newSize];
    }
    NSString *myStringImageFile = [imageData base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
    
    [HTTPCLIENT upDataImageIOS:myStringImageFile workstationUid:nil companyUid:nil type:nil saveTyep:@"5" Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            
                    NSString *backUrl=[[responseObject objectForKey:@"result"] objectForKey:@"compressurl"];
            
            [self.imageVV setImageWithURL:[NSURL URLWithString:backUrl] placeholderImage:[UIImage imageNamed:@"SHOPBACKVIEW"]];
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




@end
