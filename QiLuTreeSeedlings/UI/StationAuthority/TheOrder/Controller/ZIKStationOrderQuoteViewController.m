//
//  ZIKStationOrderQuoteViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/25.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationOrderQuoteViewController.h"
#import "BWTextView.h"
#import "ZIKQuoteTextField.h"
#import "ZIKFunction.h"
#import "RSKImageCropper.h"
#import "UIImageView+AFNetworking.h"
#import "StringAttributeHelper.h"
#import "ZIKHintTableViewCell.h"
@interface ZIKStationOrderQuoteViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIActionSheetDelegate,RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *quoteTableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) BWTextView *contentTextView;

@end

@implementation ZIKStationOrderQuoteViewController
{
    UILabel *detailLabel;
    ZIKQuoteTextField *priceTextField;

        //UIImageView    *_globalHeadImageView; //个人头像
        UIImage        *_globalHeadImage;
        UIImageView    *cellHeadImageView;
        UILabel        *cellNameLabel;
        UILabel        *cellPhoneLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.vcTitle = @"报价";
    self.titleArray = @[@[@"苗木名称",@"苗木数量",@"报价要求",@"规格要求"],@[@"报价价格",@"可供数量",@"苗圃地址",@"报价说明"],@[@"苗木图片"]];
    self.quoteTableView.delegate   = self;
    self.quoteTableView.dataSource = self;
    
   [ZIKFunction setExtraCellLineHidden:self.quoteTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array  = self.titleArray[section];
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 30;
    }
    return 0.01f;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 36;
    }
    if (indexPath.section == 1 && indexPath.row == 3) {
        return 70;
    }
    if (indexPath.section == 2) {
        return 120;
    }
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString *tableViewCellId = @"cellID";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellId];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tableViewCellId];
        if (indexPath.section == 0) {
            detailLabel = [[UILabel alloc] init];
            [cell addSubview:detailLabel];
        } else if (indexPath.section == 1 && (indexPath.row == 0 || indexPath.row == 1)) {
            priceTextField = [[ZIKQuoteTextField alloc] init];
            [cell addSubview:priceTextField];
        } else if (indexPath.section == 1 && indexPath.row == 3) {
            _contentTextView = [[BWTextView alloc] init];
            _contentTextView.placeholder = @"请输入50字以内说明...";
            _contentTextView.font = [UIFont systemFontOfSize:15.0f];
            _contentTextView.layer.masksToBounds = YES;
            _contentTextView.layer.cornerRadius = 6.0f;
            _contentTextView.layer.borderWidth = 1;
            _contentTextView.layer.borderColor = [kLineColor CGColor];
            [cell addSubview:_contentTextView];
        }
        if (!cellHeadImageView) {
            cellHeadImageView = [[UIImageView alloc] init];
        }

    }
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    if (indexPath.section == 0) {
        cell.textLabel.textColor = detialLabColor;

        detailLabel.frame = CGRectMake(100, 3, kWidth-120, 30);
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.textColor = DarkTitleColor;
        detailLabel.font = [UIFont systemFontOfSize:15.0f];
        if (indexPath.row == 0) {
            detailLabel.text = self.name;
        } else if (indexPath.row == 1) {
            detailLabel.text = self.count;
        } else if (indexPath.row == 2) {
            detailLabel.text = self.quoteRequirement;
        } else if (indexPath.row == 3) {
            detailLabel.text = self.standardRequirement;
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        

    } else if (indexPath.section == 1) {
        cell.textLabel.textColor = DarkTitleColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

        priceTextField.frame = CGRectMake(100, 5, kWidth-120-40, 34);
        if (indexPath.row == 0) {
            priceTextField.placeholder = @"请输入单价";
            UILabel *yuan = [self labelWithText:@"元  *"];
            [cell addSubview:yuan];
        } else if (indexPath.row == 1) {
            UILabel *ke         = [self labelWithText:@"棵  *"];
            [cell addSubview:ke];
            priceTextField.placeholder = @"请输入数量";
        } else if (indexPath.row == 2) {
            UILabel *arrowLabel = [self labelWithText:@"      *"];
            UIButton *addressButton = [[UIButton alloc] init];
            addressButton.frame = priceTextField.frame;
            addressButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            [addressButton setTitle:@"请选择地址" forState:UIControlStateNormal];
            [addressButton setTitleColor:NavColor forState:UIControlStateNormal];
            [addressButton addTarget:self action:@selector(selectAddress) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:addressButton];
            [cell addSubview:arrowLabel];
        } else if (indexPath.row == 3) {
            _contentTextView.frame = CGRectMake(100, 5, kWidth-120-20, 60);
        }
    } else if (indexPath.section == 2)  {
        cell.textLabel.textColor = DarkTitleColor;
        cellHeadImageView.frame = CGRectMake(100, 10, 100, 100);
        cellHeadImageView.image = [UIImage imageNamed:@"添加图片"];
        cellHeadImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPicture)];
        [cellHeadImageView addGestureRecognizer:tapGR];
        [cell addSubview:cellHeadImageView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView *footerView = [[UIView alloc] init];
        footerView.frame = CGRectMake(0, 0, kWidth, 30);
        footerView.backgroundColor = BGColor;
        ZIKHintTableViewCell *hintCell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKHintTableViewCell" owner:self options:nil] lastObject];
        hintCell.frame = CGRectMake(0, 0, kWidth, 30);
        [footerView addSubview:hintCell];
        hintCell.backgroundColor = BGColor;
        hintCell.contentView.backgroundColor = BGColor;
        hintCell.hintStr = @"注：输入框后有*的为必填项";
        return footerView;

    }
    return nil;
}

- (IBAction)sureButtonClick:(UIButton *)sender {
}

- (void)selectAddress {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UILabel *)labelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(kWidth-40, 10, 40, 24);
    label.textColor = DarkTitleColor;
    FontAttribute *fullFont = [FontAttribute new];
    fullFont.font = [UIFont systemFontOfSize:15.0f];
    fullFont.effectRange  = NSMakeRange(0, text.length);
    ForegroundColorAttribute *fullColor = [ForegroundColorAttribute new];
    fullColor.color = DarkTitleColor;
    fullColor.effectRange = NSMakeRange(0,text.length);
    FontAttribute *partFont = [FontAttribute new];
    partFont.font = [UIFont systemFontOfSize:15.0f];
    partFont.effectRange = NSMakeRange(text.length-1,1);
    ForegroundColorAttribute *huangColor = [ForegroundColorAttribute new];
    huangColor.color = yellowButtonColor;
    huangColor.effectRange = NSMakeRange(text.length-1, 1);

    label.attributedText = [text mutableAttributedStringWithStringAttributes:@[fullFont,partFont,fullColor,huangColor]];
    return label;
}

#pragma mark - 添加图片事件
//添加图片事件
- (void)addPicture
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"添加苗木图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄新照片",@"从相册选取", nil];
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
//    [HTTPCLIENT upDataUserImageWithToken:nil WithAccessID:nil WithClientID:nil WithClientSecret:nil WithDeviceID:nil WithUserIamge:image Success:^(id responseObject) {
//        //NSLog(@"%@",responseObject);
//        if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
//            [ToastView showTopToast:@"上传成功"];
            _globalHeadImage = image;
            cellHeadImageView.image = _globalHeadImage;
            //[self.myTalbeView reloadData];
//            APPDELEGATE.userModel.headUrl = responseObject[@"url"];
//        }
//        else {
//            //NSLog(@"%@",responseObject[@"msg"]);
//            [ToastView showTopToast:responseObject[@"msg"]];
//        }
//    } failure:^(NSError *error) {
//        //NSLog(@"%@",error);
//    }];
}

@end
