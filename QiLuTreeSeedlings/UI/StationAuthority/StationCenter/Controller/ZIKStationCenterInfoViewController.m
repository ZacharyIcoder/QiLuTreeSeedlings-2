//
//  ZIKStationCenterInfoViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/23.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationCenterInfoViewController.h"
#import "ZIKStationChangeInfoViewController.h"
#import "YYModel.h"//类型转换
#import "RSKImageCropper.h"
#import "UIImageView+AFNetworking.h"

@interface ZIKStationCenterInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIActionSheetDelegate,RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    UIImage        *_globalHeadImage;
    UIImageView    *cellHeadImageView;
    UILabel        *cellNameLabel;
    UILabel        *cellPhoneLabel;
}
@property (nonatomic, strong) NSArray     *titlesArray;
@property (nonatomic, strong) UITableView *myTableView;
@end
/**/

@implementation ZIKStationCenterInfoViewController
@synthesize titlesArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"站长信息";
    titlesArray = @[@"我的头像",@"姓名",@"电话",@"自我介绍"];

    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, 44*4) style:UITableViewStylePlain];
    tableview.dataSource = self;
    tableview.delegate   = self;
    [self.view addSubview:tableview];
    tableview.scrollEnabled = NO;
    self.myTableView = tableview;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self requestData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *infoCellId = @"infoCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:infoCellId];
        if (!cellHeadImageView) {
            cellHeadImageView = [[UIImageView alloc] init];
        }

    }
    cell.textLabel.text = titlesArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.textColor = DarkTitleColor;
    if (indexPath.row == 0) {
        cellHeadImageView.frame = CGRectMake(kWidth-75, 7, 30, 30);
        cellHeadImageView.layer.cornerRadius = 15.0f;
        cellHeadImageView.clipsToBounds = YES;
        if (_globalHeadImage) {
            cellHeadImageView.image = _globalHeadImage;
        }
        else if (![ZIKFunction xfunc_check_strEmpty:self.masterModel.workstationPic]) {
            [cellHeadImageView setImageWithURL:[NSURL URLWithString:self.masterModel.workstationPic] placeholderImage:[UIImage imageNamed:@"UserImageV"]];
        }
        else {
            cellHeadImageView.image = [UIImage imageNamed:@"UserImageV"];
        }
        [cell addSubview:cellHeadImageView];
    }
    if (indexPath.row == 1) {
        cell.detailTextLabel.text = self.masterModel.chargelPerson;
    } else if (indexPath.row == 2) {
        cell.detailTextLabel.text = self.masterModel.phone;
    } else if (indexPath.row == 3) {
        cell.detailTextLabel.text = self.masterModel.brief;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self addPicture];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    ZIKStationChangeInfoViewController *changeInfoVC = [[ZIKStationChangeInfoViewController alloc] initWithNibName:@"ZIKStationChangeInfoViewController" bundle:nil];
    NSString *placeholderStr = [NSString stringWithFormat:@"请输入%@",titlesArray[indexPath.row]];
    changeInfoVC.titleString = titlesArray[indexPath.row];
    changeInfoVC.placeholderString = placeholderStr;
    [self.navigationController pushViewController:changeInfoVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 请求数据
- (void)requestData {
    [HTTPCLIENT stationMasterSuccess:^(id responseObject) {
        CLog(@"%@",responseObject);
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        }
        if (self.masterModel) {
            self.masterModel = nil;
        }
        NSDictionary *result = responseObject[@"result"];
        NSDictionary *masterInfo = result[@"masterInfo"];
        self.masterModel = [MasterInfoModel yy_modelWithDictionary:masterInfo];
        [self.myTableView reloadData];

    } failure:^(NSError *error) {
        ;
    }];
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
    [self.navigationController pushViewController:imageCropVC animated:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
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
        CGSize newSize = {600,600};
        imageData =  [self imageWithImageSimple:image scaledToSize:newSize];
    }
    NSString *myStringImageFile = [imageData base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];


    [HTTPCLIENT upDataImageIOS:myStringImageFile workstationUid:_masterModel.uid companyUid:nil type:@"2" saveTyep:@"2" Success:^(id responseObject) {
//        CLog(@"%@",responseObject);
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        } else if ([responseObject[@"success"] integerValue] == 1) {
            _globalHeadImage = image;
            cellHeadImageView.image = _globalHeadImage;

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

@end
