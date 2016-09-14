//
//  YLDJPGYSInfoViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/13.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDJPGYSInfoViewController.h"
#import "HttpClient.h"
#import "UIDefines.h"
#import "YLDGCZXInfoTableViewCell.h"
#import "YLDGCZXTouxiangTableViewCell.h"
#import "RSKImageCropper.h"
#import "UIImageView+AFNetworking.h"
#import "YLDGCGSBianJiViewController.h"
@interface YLDJPGYSInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,copy) NSDictionary *dic;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,copy)NSString *url;
@property (nonatomic,weak)YLDGCZXTouxiangTableViewCell *touxiangCell;
@end

@implementation YLDJPGYSInfoViewController
-(id)initWithDic:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.dic=dic;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"金牌信息";
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
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==3) {
        if (APPDELEGATE.userModel.brief.length>0) {
          CGFloat height = [self getHeightWithContent:APPDELEGATE.userModel.brief width:200 font:16];
            if (height>21) {
                return height+30;
            }
        }
    }
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        YLDGCZXTouxiangTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDGCZXTouxiangTableViewCell"];
        if (!cell) {
            cell=[YLDGCZXTouxiangTableViewCell yldGCZXTouxiangTableViewCell];
         
        }
           [cell.imagev setImageWithURL:[NSURL URLWithString:APPDELEGATE.userModel.headUrl] placeholderImage:[UIImage imageNamed:@"UserImage"]];
        self.touxiangCell=cell;
        return cell;
    }else{
        YLDGCZXInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDGCZXInfoTableViewCell"];
        if (!cell) {
            cell=[YLDGCZXInfoTableViewCell yldGCZXInfoTableViewCell];
        }
        if (indexPath.row==1) {
            cell.titleLab.text=@"联系人";
            cell.NameLab.text=APPDELEGATE.userModel.name;
            
        }
        if (indexPath.row==2) {
            cell.titleLab.text=@"电话";
            cell.NameLab.text=APPDELEGATE.userModel.phone;
            cell.accessoryType=UITableViewCellAccessoryNone;
            
        }
        if (indexPath.row==3) {
            cell.titleLab.text=@"自我介绍";
            cell.NameLab.text=APPDELEGATE.userModel.brief;
            cell.lineV.hidden=YES;
            CGFloat height = [self getHeightWithContent:APPDELEGATE.userModel.brief width:200 font:16];
            
            CGRect frame=cell.frame;
            if (height>21) {
                cell.NameLab.textAlignment=NSTextAlignmentLeft;
                frame.size.height=height+30;
            }else{
                cell.NameLab.textAlignment=NSTextAlignmentRight;
              frame.size.height=50;
            }
            cell.frame=frame;
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
    }else if(indexPath.row==1){
        YLDGCGSBianJiViewController *vc=[[YLDGCGSBianJiViewController alloc]initWithType:indexPath.row+10 andStr:APPDELEGATE.userModel.name];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row==3){
        YLDGCGSBianJiViewController *vc=[[YLDGCGSBianJiViewController alloc]initWithType:indexPath.row+10 andStr:APPDELEGATE.userModel.brief];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//获取字符串的高度
-(CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.height;
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
    [HTTPCLIENT upDataUserImageWithToken:nil WithAccessID:nil WithClientID:nil WithClientSecret:nil WithDeviceID:nil WithUserIamge:image Success:^(id responseObject) {
        //NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
            [ToastView showTopToast:@"上传成功"];
            self.touxiangCell.imagev.image=image;
            //[self.myTalbeView reloadData];
            [APPDELEGATE reloadUserInfoSuccess:^(id responseObject) {
                
            } failure:^(NSError *error) {
                
            }];
        }
        else {
            NSLog(@"%@",responseObject[@"msg"]);
            [ToastView showTopToast:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        //NSLog(@"%@",error);
    }];
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
