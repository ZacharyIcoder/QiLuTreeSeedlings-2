//
//  ZIKSupplyPublishViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/23.
//  Copyright © 2016年 中亿信息技术. All rights reserved.
//
#define NavColor        [UIColor colorWithRed:107/255.0f green:188/255.0f blue:85/255.0f alpha:1.0f]

#import "ZIKSupplyPublishViewController.h"
#import "ZIKSupplyPublishSingleTableViewCell.h"
#import "ZIKSupplyPublishPickImageViewTableViewCell.h"
#import "UIDefines.h"
#import "ZHHttpTool.h"
#import "HttpClient.h"
#import "ZIKSupplyPublishNameTableViewCell.h"
#import "ZIKGreenButton.h"
#import "ZIKSideView.h"

@interface ZIKSupplyPublishViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,
UITextFieldDelegate,UIAlertViewDelegate,ZIKSelectViewUidDelegate>
{
    UITextField *titleTextField;
}
@property (nonatomic, strong) UITableView      *supplyInfoTableView;
@property (nonatomic, weak  ) ZIKPickImageView *pickerImgView;
@property (nonatomic, strong) UIActionSheet    *myActionSheet;
@property (nonatomic, strong) NSMutableArray   *imageUrlMarr;
@property (nonatomic, strong) ZIKGreenButton   *sureButton;
@property (nonatomic, strong) UITextField      *nameTextField;
@property (nonatomic, strong) ZIKSideView      *sideView;
@property (nonatomic, strong) NSMutableArray   *productTypeDataMArray;
@end

@implementation ZIKSupplyPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"供应发布";
    [self initData];
    [self initUI];
}

- (void)initData {
    self.imageUrlMarr = [NSMutableArray array];
    self.productTypeDataMArray = [NSMutableArray array];
}

- (void)initUI {
    self.supplyInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Width, Height-64-60) style:UITableViewStylePlain];
    self.supplyInfoTableView.delegate   = self;
    self.supplyInfoTableView.dataSource = self;
    [self.view addSubview:self.supplyInfoTableView];
    [self setExtraCellLineHidden:self.supplyInfoTableView];
    
    UIButton *nextBtn = [[UIButton alloc] init];
    nextBtn.frame = CGRectMake(Width/2-50, Height-50, 100, 30);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 44;
        }
        else {
            return 130;
        }
    }
    else if (indexPath.section == 1) {
        return 44;
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;//self.supplyInfoMArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *kZIKMySupplyTableViewCellID = @"kZIKMySupplyTableViewCellID";
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                ZIKSupplyPublishSingleTableViewCell *S0R0Cell = [ZIKSupplyPublishSingleTableViewCell cellWithTableView:tableView];
                [S0R0Cell configureCell:nil];
                //S0R0Cell.titleLabel.text = @"标题";
                titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, 12, Width-100, 20)];
                titleTextField.textColor = [UIColor darkGrayColor];
                titleTextField.placeholder = @"请输入标题(限制在20字以内)";
                titleTextField.adjustsFontSizeToFitWidth = YES;
                [S0R0Cell addSubview:titleTextField];
                cell = S0R0Cell;
            }
            else {
                ZIKSupplyPublishPickImageViewTableViewCell *pickCell = [ZIKSupplyPublishPickImageViewTableViewCell cellWithTableView:tableView];
               // pickCell.backgroundColor = [UIColor yellowColor];
                ZIKPickImageView *pick = [[ZIKPickImageView alloc] initWithFrame:CGRectMake(0, 0, Width, 100)];
                [pickCell.contentView addSubview:pick];
                self.pickerImgView = pick;
                self.pickerImgView.takePhotoBlock = ^{
                    [self openMenu];
                };
                cell = pickCell;
            }
            
        }
            break;
        case 1: {
            ZIKSupplyPublishNameTableViewCell *nameCell = [ZIKSupplyPublishNameTableViewCell cellWithTableView:tableView];
            self.nameTextField = nameCell.nameTextField;
            self.sureButton = [[ZIKGreenButton alloc] initWithFrame:CGRectMake(Width-65, 10, 50, 22)];
            [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
            [self.sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [nameCell.contentView addSubview:self.sureButton];
            cell = nameCell;
        }
            break;
        case 2: {
            
        }
            break;
        default:
            break;
    }
//    ZIKMySupplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKMySupplyTableViewCellID];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKMySupplyTableViewCell" owner:self options:nil] lastObject];
//    }
//    [cell configureCell:self.supplyInfoMArr[indexPath.row]];
    return cell;
}

- (void)sureButtonClick {
    NSLog(@"确定按钮点击");
    NSLog(@"%@",self.nameTextField.text);
    if (self.nameTextField.text == nil || self.nameTextField.text.length == 0) {
        NSLog(@"请输入苗木名称");
    }
    else {
        [HTTPCLIENT getMmAttributeWith:self.nameTextField.text WithType:@"1" Success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            if ([responseObject[@"msg"] isEqualToString:@"该苗木不存在"]) {
                [self requestProductType];
                
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}

- (void)requestProductType {
    [HTTPCLIENT getTypeInfoSuccess:^(id responseObject) {
//        NSLog(@"%@",responseObject);
//        NSLog(@"%@",responseObject[@"success"]);
        if ([[responseObject objectForKey:@"success"] integerValue] == 1 ) {
            NSArray *typeListArray = [[responseObject objectForKey:@"result"] objectForKey:@"typeList"];
            if (typeListArray.count == 0) {
                NSLog(@"暂时没有产品信息!!!");
            }
            else if (typeListArray.count > 0) {
                self.productTypeDataMArray = (NSMutableArray *)typeListArray;
                [self showSideView];
            }
        }
        else if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)showSideView {
    [self.nameTextField resignFirstResponder];
    if (!self.sideView) {
        self.sideView = [[ZIKSideView alloc] initWithFrame:CGRectMake(Width, 0, Width, Height)];
    }
    self.sideView.pleaseSelectLabel.text = @"请选择苗木";
    self.sideView.selectView.uidDelegate = self;
//    self.selectView = self.sideView.selectView;
//    self.selectView.delegate = self;
    self.sideView.dataArray = self.productTypeDataMArray;
    self.sideView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:.3 animations:^{
        self.sideView.frame = CGRectMake(0, 0, Width, Height);
    }];
    [self.view addSubview:self.sideView];
}

- (void)didSelectorUid:(NSString *)selectId title:(NSString *)selectTitle {
    NSLog(@"%@",selectTitle);
    self.nameTextField.text = selectTitle;
    [self.sideView removeSideViewAction];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.navigationBar.barTintColor = NavColor;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    //    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        NSData *iconData = UIImagePNGRepresentation(image);//UIImageJPEGRepresentation(image, 0.1);
        //[self saveImage:image WithName:@"kong"];
        //2016-3-22
        HttpClient *httpClient  = [HttpClient sharedClient];
        [httpClient upDataImageIOS:image Success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSLog(@"%@",responseObject[@"success"]);
                NSLog(@"%@",responseObject[@"msg"]);
                [self.pickerImgView addImage:image withUrl:responseObject[@"result"]];
                //self.pickerImgView.photos
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            NSLog(@"上传图片失败");
        }];
//        [httpClient upDataImage:image Success:^(id responseObject) {
//           // NSLog(@"上传成功");
//             [self.pickerImgView addImage:image];
//            //NSDictionary *dic=[responseObject objectForKey:@"success"];
//           //NSLog(@"%@",dic);
//            NSLog(@"%@",responseObject);
//           // NSLog(@"%@",responseObject[@"msg"]);
//            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",string);
//            //NSLog(@"%@",responseObject)
//        } failure:^(NSError *error) {
//            NSLog(@"%@",error.description);
//            NSLog(@"%@",error);
//        }];
        
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置TableView空行分割线隐藏
// 设置TableView空行分割线隐藏
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark 保存图片到document
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}

#pragma mark 从文档目录下获取Documents路径
- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

-(void)backBtnAction:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要退出编辑？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert show];
    alert.tag = 300;
    alert.delegate = self;
    
    //[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",(long)buttonIndex);
    if(alertView.tag == 300)//是否退出编辑
    {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.nameTextField resignFirstResponder];
}

@end
