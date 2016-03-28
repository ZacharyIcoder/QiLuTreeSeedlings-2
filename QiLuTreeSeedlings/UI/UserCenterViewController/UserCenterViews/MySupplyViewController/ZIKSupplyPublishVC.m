//
//  ZIKSupplyPublishVC.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/28.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKSupplyPublishVC.h"
#import "UIDefines.h"
#import "ZHHttpTool.h"
#import "HttpClient.h"
#import "ZIKPickImageView.h"
#import "ZIKSideView.h"
#import "ZIKSelectView.h"
#import "SreeningViewCell.h"
#import "ZIKMySupplyCreateModel.h"
#import "JSONKit.h"
#import "ZIKSupplyPublishNextVC.h"
#define kMaxLength 20

@interface ZIKSupplyPublishVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,
UITextFieldDelegate,UIAlertViewDelegate,ZIKSelectViewUidDelegate>

@property (nonatomic, strong) UITableView      *supplyInfoTableView;
@property (nonatomic, weak  ) ZIKPickImageView *pickerImgView;
@property (nonatomic, strong) UIActionSheet    *myActionSheet;
@property (nonatomic, strong) NSMutableArray   *imageUrlMarr;
@property (nonatomic, strong) UIButton         *sureButton;
@property (nonatomic, strong) UITextField      *nameTextField;
@property (nonatomic, strong) ZIKSideView      *sideView;
@property (nonatomic, strong) NSMutableArray   *productTypeDataMArray;
@property (nonatomic, strong) NSArray          *dataAry;
@property (nonatomic, strong) NSMutableArray   *cellAry;
//@property (nonatomic, strong) UIView           *backScrollView;
@property (nonatomic,strong ) UIScrollView     *backScrollView;
@property (nonatomic,strong ) UITextField      *titleTextField;
@property (nonatomic,strong ) UIButton         *nameBtn;
@property (nonatomic,strong ) UITextField      *nowTextField;
@property (nonatomic,strong)  ZIKMySupplyCreateModel *supplyModel;
@property (nonatomic, strong) NSMutableArray *imageUrlsMarr;
@property (nonatomic, strong) NSMutableArray *imageCompressUrlsMarr;

@end

@implementation ZIKSupplyPublishVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"供应发布";
    [self initData];
    [self initUI];
}

- (void)initData {
    self.imageUrlMarr          = [NSMutableArray array];
    self.productTypeDataMArray = [NSMutableArray array];
    self.cellAry               = [NSMutableArray array];
    self.supplyModel           = [[ZIKMySupplyCreateModel alloc] init];
    self.imageUrlsMarr         = [NSMutableArray array];
    self.imageCompressUrlsMarr = [NSMutableArray array];
}

- (void)initUI {
    self.backScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-64)];
    [self.view addSubview:self.backScrollView];
    [self.backScrollView setBackgroundColor:BGColor];
    CGRect tempFrame  = CGRectMake(0,0, kWidth, 44);
    UIView *titleView = [[UIView alloc] initWithFrame:tempFrame];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 40, 44)];
    [titleView addSubview:titleLab];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    titleLab.text = @"标题";
    UITextField *titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(70, 0, kWidth-70, 44)];
    titleTextField.placeholder  = @"请输入标题(限制在20字以内)";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:titleTextField];
    self.titleTextField = titleTextField;
    UIImageView *titleLineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 43.5, kWidth-10, 0.5)];
    [titleLineView setBackgroundColor:kLineColor];
    [titleView addSubview:titleLineView];
    [titleView addSubview:titleTextField];
    titleTextField.delegate = self;
    titleTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.backScrollView addSubview:titleView];
    tempFrame.origin.y+=44.5;

    ZIKPickImageView* pickView = [[ZIKPickImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLineView.frame), Width, 100)];
    pickView.backgroundColor = [UIColor whiteColor];
    [self.backScrollView addSubview:pickView];
    self.pickerImgView = pickView;
    self.pickerImgView.takePhotoBlock = ^{
        [self openMenu];
    };

    UIView *nameView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(pickView.frame)+15, kWidth, 44)];
    [nameView setBackgroundColor:[UIColor whiteColor]];
    [self.backScrollView addSubview:nameView];

    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, 44)];
    nameLab.text = @"苗木名称";
    [nameView addSubview:nameLab];
    UITextField *nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, kWidth-100-60, 44)];
    nameTextField.placeholder = @"请输入名称";
    nameTextField.textColor = NavColor;
    nameTextField.delegate=self;
    self.nameTextField=nameTextField;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(nameChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nameTextField];
    [nameView addSubview:nameTextField];

    UIButton *nameBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-70, 9, 50, 25)];
    [nameView addSubview:nameBtn];
    [nameBtn addTarget:self action:@selector(nameBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [nameBtn setImage:[UIImage imageNamed:@"treeNameSure"] forState:UIControlStateNormal];
    [nameBtn setImage:[UIImage imageNamed:@"treeNameSure2"] forState:UIControlStateSelected];
    UIImageView *nameLineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 43.5, kWidth-10, 0.5)];
    [nameLineView setBackgroundColor:kLineColor];
    [nameView addSubview:nameLineView];


    self.nameBtn=nameBtn;

    UIButton *nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, kHeight-60, kWidth-80, 44)];
    [self.view addSubview:nextBtn];
    [nextBtn setBackgroundColor:NavColor];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UITapGestureRecognizer *tapgest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidingKey)];
    [self.backScrollView addGestureRecognizer:tapgest];
}

- (void)nameChange {
    self.nameBtn.selected = NO;
}

-(void)nextBtnAction:(UIButton *)sender
{
    if (self.titleTextField.text.length == 0 || self.titleTextField.text == nil) {
//        [ToastView showTopToast:@"请输入标题"];
//        return;
    }
    if (self.nameTextField.text.length == 0 || self.nameTextField.text == nil || self.nameBtn.selected == NO) {
//        [ToastView showTopToast:@"请先确定苗木名称"];
//        return;
    }
    if (self.pickerImgView.urlMArr.count<3) {
//        [ToastView showTopToast:@"请添加三张苗木图片"];
//        return;
    }
    self.supplyModel.title = self.titleTextField.text;
    self.supplyModel.name  = self.nameTextField.text;
    [self.pickerImgView.urlMArr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.imageUrlsMarr addObject:dic[@"url"]];
        [self.imageCompressUrlsMarr addObject:dic[@"compressurl"]];
    }];
    NSString *urlSring = [self.imageUrlsMarr JSONString];
    self.supplyModel.imageUrls = urlSring;
    self.supplyModel.imageCompressUrls = [self.imageCompressUrlsMarr JSONString];
    ZIKSupplyPublishNextVC *nextVC = [[ZIKSupplyPublishNextVC alloc] init];
    nextVC.supplyModel = self.supplyModel;
    [self.navigationController pushViewController:nextVC animated:YES];
    //NSLog(@"%@",urlSring);
//    if(!self.productUid)
//    {
//        [ToastView showTopToast:@"该苗木不存在"];
//        return;
//    }
//    if (!self.productName) {
//        [ToastView showTopToast:@"苗木名称不正确"];
//        return;
//    }
//    NSMutableArray *screenTijiaoAry=[NSMutableArray array];
//    for (int i=0; i<cellAry.count; i++) {
//        TreeSpecificationsModel *model=cellAry[i];
//        if (model.anwser.length>0) {
//            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:model.field,@"field",
//                               model.anwser,@"anwser"
//                               , nil];
//            [screenTijiaoAry addObject:dic];
//        }
//    }
//    buyFabuTijiaoViewController *buyfabuTJViewController=[[buyFabuTijiaoViewController alloc]initWithAry:screenTijiaoAry andTitle:self.titleTextField.text andProname:self.productName andProUid:self.productUid];
//    [self.navigationController pushViewController:buyfabuTJViewController animated:YES];
//    //NSLog(@"%@",screenTijiaoAry);

}

- (void)nameBtnAction:(UIButton *)button {
    NSLog(@"确定按钮点击");
    if (button.selected) {
        return;
    }
    NSLog(@"%@",self.nameTextField.text);
    if (self.nameTextField.text == nil || self.nameTextField.text.length == 0) {
        NSLog(@"请输入苗木名称");
        [ToastView showToast:@"请输入苗木名称"
                 withOriginY:66.0f
               withSuperView:APPDELEGATE.window];
        return;
    }
    else {
        [HTTPCLIENT getMmAttributeWith:self.nameTextField.text WithType:@"1" Success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            if ([responseObject[@"msg"] isEqualToString:@"该苗木不存在"]) {
                [self requestProductType];
            }
            else {
                NSDictionary *dic = [responseObject objectForKey:@"result"];
                self.dataAry = [dic objectForKey:@"list"];
                button.selected = YES;
                [self creatScreeningCells];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }

}

-(void)creatScreeningCells
{
    self.dataAry = [TreeSpecificationsModel creatTreeSpecificationsModelAryByAry:self.dataAry];
    //    NSLog(@"%@",ary);
    CGFloat Y = 205;

    [self.backScrollView.subviews enumerateObjectsUsingBlock:^(UIView *myview, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([myview isKindOfClass:[SreeningViewCell class]]) {
            [myview removeFromSuperview];
        }
    }];
    
    for (int i=0; i<self.dataAry.count; i++) {
        SreeningViewCell *cell = [[SreeningViewCell alloc] initWithFrame:CGRectMake(0, Y, 0.8*kWidth, 44) AndModel:self.dataAry[i]];
        //cell.backgroundColor = [UIColor whiteColor];
        [_cellAry addObject:cell.model];
        Y = CGRectGetMaxY(cell.frame);
        [self.backScrollView addSubview:cell];
    }
    [self.backScrollView setContentSize:CGSizeMake(0, Y)];
    self.backScrollView.backgroundColor = [UIColor whiteColor];
}

- (void)requestProductType {
    [HTTPCLIENT getTypeInfoSuccess:^(id responseObject) {
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
        //NSLog(@"%@",error);
    }];
}

- (void)showSideView {
    //[self.nameTextField resignFirstResponder];
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

- (void)textFieldChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;

    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                NSLog(@"最多%d个字符!!!",kMaxLength);
                //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%d个字符",kMaxLength] view:nil];
                textField.text = [toBeString substringToIndex:kMaxLength];
                return;
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{

        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxLength) {
            //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%ld个字符",(long)kMaxLength] view:nil];
             NSLog(@"最多%d个字符!!!",kMaxLength);
            textField.text = [toBeString substringToIndex:kMaxLength];
            return;
        }
    }
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

-(void)cellBeginEditing:(UITextField *)field
{
    self.nowTextField=field;
}
-(void)cellEndEditing
{
    if (self.backScrollView.frame.size.height==kHeight-44-44) {
        return;
    }
//    CGRect frame=self.backScrollView.frame;
//    frame.size.height=kHeight-44-44;
//    self.backScrollView.frame=frame;
}
-(void)cellKeyHight:(CGFloat)hight
{
    if (self.backScrollView.frame.size.height==kHeight-hight-44-44) {
        return;
    }
//    CGRect frame=self.backScrollView.frame;
//    frame.size.height=kHeight-hight-44-44;
//    self.backScrollView.frame=frame;
}
-(void)hidingKey
{
    if (self.nowTextField) {
        [self.nowTextField resignFirstResponder];
    }
    if (self.backScrollView.frame.size.height==kHeight-44-44) {
        return;
    }
//    CGRect frame=self.backScrollView.frame;
//    frame.size.height=kHeight-44-44;
//    self.backScrollView.frame=frame;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hidingKey];
}

@end
