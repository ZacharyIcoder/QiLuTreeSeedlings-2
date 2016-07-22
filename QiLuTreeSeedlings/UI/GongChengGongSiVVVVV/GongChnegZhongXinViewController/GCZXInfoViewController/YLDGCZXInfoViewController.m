//
//  YLDGCZXInfoViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/6.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDGCZXInfoViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "YLDGCZXInfoTableViewCell.h"
#import "YLDGCZXTouxiangTableViewCell.h"
#import "RSKImageCropper.h"
#import "UIImageView+AFNetworking.h"
#import "YLDGCGSBianJiViewController.h"
@interface YLDGCZXInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,copy)NSString *url;
@property (nonatomic,weak)YLDGCZXTouxiangTableViewCell *touxiangCell;
@end

@implementation YLDGCZXInfoViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"公司信息";
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView=tableView;
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        YLDGCZXTouxiangTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDGCZXTouxiangTableViewCell"];
        if (!cell) {
            cell=[YLDGCZXTouxiangTableViewCell yldGCZXTouxiangTableViewCell];
              [cell.imagev setImageWithURL:[NSURL URLWithString:APPDELEGATE.GCGSModel.attachment] placeholderImage:[UIImage imageNamed:@"UserImage"]];
        }
        self.touxiangCell=cell;
        return cell;
    }else{
        YLDGCZXInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDGCZXInfoTableViewCell"];
        if (!cell) {
            cell=[YLDGCZXInfoTableViewCell yldGCZXInfoTableViewCell];
        }
        if (indexPath.row==1) {
            cell.titleLab.text=@"联系人";
            cell.NameLab.text=APPDELEGATE.GCGSModel.legalPerson;
            
        }
        if (indexPath.row==2) {
            cell.titleLab.text=@"电话";
            cell.NameLab.text=APPDELEGATE.GCGSModel.phone;
            
        }
        if (indexPath.row==3) {
            cell.titleLab.text=@"公司地址";
            cell.NameLab.text=APPDELEGATE.GCGSModel.address;
            
        }
        if (indexPath.row==4) {
            cell.titleLab.text=@"公司简介";
            cell.NameLab.text=APPDELEGATE.GCGSModel.brief;
            
        }
        return cell;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        [self addPicture];
        return;
    }else{
        YLDGCGSBianJiViewController *vc=[[YLDGCGSBianJiViewController alloc]initWithType:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
        CGSize newSize = {400,400};
        imageData =  [self imageWithImageSimple:image scaledToSize:newSize];
    }
    NSString *myStringImageFile = [imageData base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
    
    [HTTPCLIENT upDataImageIOS:myStringImageFile workstationUid:nil companyUid:APPDELEGATE.GCGSModel.uid type:@"2" saveTyep:@"3" Success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        } else if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
            [ToastView showTopToast:@"添加成功"];
            NSDictionary *result = responseObject[@"result"];
            
           // NSString * compressurl   = result[@"compressurl"];
            self.url         = result[@"url"];
            NSURL *url = [NSURL URLWithString:self.url];
            APPDELEGATE.GCGSModel.attachment=self.url;
            [self.touxiangCell.imagev setImageWithURL:url placeholderImage:[UIImage imageNamed:@"UserImage"]];
            //            [self.imageBtn setBackgroundImage:image forState:UIControlStateNormal];
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
