//
//  ZIKUserInfoSetViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKUserInfoSetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ZIKUserNameSetViewController.h"
#import "ZIKPasswordSetViewController.h"
#import "ZIKMyQRCodeViewController.h"
#import "RSKImageCropper.h"
@interface ZIKUserInfoSetViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIActionSheetDelegate,RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    //UIImageView    *_globalHeadImageView; //个人头像
    UIImage        *_globalHeadImage;
    UIImageView    *cellHeadImageView;
    UILabel        *cellNameLabel;
    UILabel        *cellPhoneLabel;
}
@property (nonatomic, strong) NSArray     *titlesArray;
@property (nonatomic, strong) UITableView *myTalbeView;

@end

@implementation ZIKUserInfoSetViewController
@synthesize myTalbeView;
@synthesize titlesArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"个人信息";
    [self initData];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (myTalbeView) {
        [myTalbeView reloadData];
    }
}

- (void)initData {
    titlesArray = @[@[@"我的头像",@"姓名",@"密码",@"我的二维码"],@[@"手机号"]];
}

- (void)initUI {
    myTalbeView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStylePlain];
    myTalbeView.delegate = self;
    myTalbeView.dataSource = self;
    [self.view addSubview:myTalbeView];
    [ZIKFunction setExtraCellLineHidden:myTalbeView];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (!cellNameLabel) {
            cellNameLabel = [[UILabel alloc] init];
        }
        if (!cellHeadImageView) {
            cellHeadImageView = [[UIImageView alloc] init];
        }
        if (!cellPhoneLabel) {
            cellPhoneLabel = [[UILabel alloc] init];
        }
    }
    cell.textLabel.text = titlesArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                cellHeadImageView.frame = CGRectMake(kWidth-75, 7, 30, 30);
                cellHeadImageView.layer.cornerRadius = 15.0f;
                cellHeadImageView.clipsToBounds = YES;
                if (_globalHeadImage) {
                    cellHeadImageView.image = _globalHeadImage;
                }
                else if (![ZIKFunction xfunc_check_strEmpty:APPDELEGATE.userModel.headUrl]) {
                    [cellHeadImageView setImageWithURL:[NSURL URLWithString:APPDELEGATE.userModel.headUrl] placeholderImage:[UIImage imageNamed:@"UserImageV"]];
                }
                else {
                    cellHeadImageView.image = [UIImage imageNamed:@"UserImageV"];
                }
                [cell addSubview:cellHeadImageView];
            }
                break;
            case 1: {
                cellNameLabel.frame = CGRectMake(55, 7, kWidth-55-30, 30);
                cellNameLabel.text = APPDELEGATE.userModel.name;
                cellNameLabel.textAlignment = NSTextAlignmentRight;
                [cell addSubview:cellNameLabel];
            }
                break;
            case 2: {

            }
                break;
            case 3: {
            }
                break;
            default:
                break;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    }
    else if (indexPath.section == 1) {
        cellPhoneLabel.frame = CGRectMake(55, 7, kWidth-55-15, 30);
        cellPhoneLabel.text = APPDELEGATE.userModel.phone;
        cellPhoneLabel.textAlignment = NSTextAlignmentRight;
        [cell addSubview:cellPhoneLabel];
        cell.accessoryType = UITableViewCellAccessoryNone; //不显示最右边的箭头

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                [self addPicture];
            }
                break;
            case 1: {
                ZIKUserNameSetViewController *nameVC = [[ZIKUserNameSetViewController alloc] init];
                [self.navigationController pushViewController:nameVC animated:YES];
            }
                break;
            case 2: {
                ZIKPasswordSetViewController *passwordVC = [[ZIKPasswordSetViewController alloc] init];
                [self.navigationController pushViewController:passwordVC animated:YES];
            }
                break;
            case 3: {
                ZIKMyQRCodeViewController *QRcodeVC = [[ZIKMyQRCodeViewController alloc] init];
                [self.navigationController pushViewController:QRcodeVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 1) {
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
            [ToastView showTopToast:@"上传成功"];
            _globalHeadImage = image;
            cellHeadImageView.image = _globalHeadImage;
            //[self.myTalbeView reloadData];
            APPDELEGATE.userModel.headUrl = responseObject[@"url"];
        }
        else {
            //NSLog(@"%@",responseObject[@"msg"]);
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


@end
