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
#import "FabutiaojiaCell.h"
#import "ZIKMySupplyCreateModel.h"
#import "JSONKit.h"
#import "ZIKSupplyPublishNextVC.h"
#define kMaxLength 20

@interface ZIKSupplyPublishVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,
UITextFieldDelegate,UIAlertViewDelegate,ZIKSelectViewUidDelegate>

@property (nonatomic, strong) UITableView      *supplyInfoTableView;
@property (nonatomic, weak  ) ZIKPickImageView *pickerImgView;
@property (nonatomic, strong) UIActionSheet    *myActionSheet;
//@property (nonatomic, strong) NSMutableArray   *imageUrlMarr;
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
//@property (nonatomic, strong) NSMutableArray *imageUrlsMarr;
//@property (nonatomic, strong) NSMutableArray *imageCompressUrlsMarr;
@property (nonatomic,strong) SupplyDetialMode *model;
@property (nonatomic,strong) NSArray *nurseryAry;
@property (nonatomic,strong) NSDictionary *baseDic;
@end

@implementation ZIKSupplyPublishVC
-(id)initWithModel:(SupplyDetialMode*)model
{
    self=[super init];
    if (self) {
        self.model=model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"供应发布";
    [self initData];
    [self initUI];
}

- (void)initData {
//    self.imageUrlMarr          = [NSMutableArray array];
    self.productTypeDataMArray = [NSMutableArray array];
    self.cellAry               = [NSMutableArray array];
    self.supplyModel           = [[ZIKMySupplyCreateModel alloc] init];
//    self.imageUrlsMarr         = [NSMutableArray array];
//    self.imageCompressUrlsMarr = [NSMutableArray array];
}

- (void)initUI {
    self.backScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-64)];
    [self.view addSubview:self.backScrollView];
    [self.backScrollView setBackgroundColor:BGColor];
    CGRect tempFrame  = CGRectMake(0,0, kWidth, 44);
    UIView *titleView = [[UIView alloc] initWithFrame:tempFrame];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 40, 44)];
    [titleLab setFont:[UIFont systemFontOfSize:15]];
    [titleView addSubview:titleLab];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    titleLab.text = @"标题";
    UITextField *titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(70, 0, kWidth-70, 44)];
    [titleTextField setFont:[UIFont systemFontOfSize:15]];
    titleTextField.placeholder  = @"请输入标题(限制在20字以内)";
    titleTextField.textColor = [UIColor blackColor];
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
    tempFrame.origin.y += 44.5;

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
    [nameLab setFont:[UIFont systemFontOfSize:15]];
    nameLab.text = @"苗木名称";
    [nameView addSubview:nameLab];
    UITextField *nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, kWidth-100-60, 44)];
    nameTextField.placeholder = @"请输入名称";
    nameTextField.textColor = NavColor;
    nameTextField.delegate=self;
    [nameTextField setFont:[UIFont systemFontOfSize:15]];
    self.nameTextField=nameTextField;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(nameChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nameTextField];
    [nameView addSubview:nameTextField];

    UIButton *nameBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-70, 9, 50, 25)];
    [nameView addSubview:nameBtn];
    [nameBtn addTarget:self action:@selector(nameBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [nameBtn setImage:[UIImage imageNamed:@"treeNameSure"] forState:UIControlStateNormal];
    [nameBtn setImage:[UIImage imageNamed:@"treeNameSure2"] forState:UIControlStateSelected];
    UIImageView *nameLineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 43.5, kWidth-10, 0.5)];
    [nameLineView setBackgroundColor:kLineColor];
    [nameView addSubview:nameLineView];


    self.nameBtn = nameBtn;

    UIButton *nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, kHeight-60, kWidth-80, 44)];
    [self.view addSubview:nextBtn];
    [nextBtn setBackgroundColor:NavColor];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UITapGestureRecognizer *tapgest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidingKey)];
    [self.backScrollView addGestureRecognizer:tapgest];
    if (self.model) {
        self.titleTextField.text=self.model.title;
        self.nameTextField.text=self.model.productName;
        self.nameBtn.selected=YES;
        [HTTPCLIENT mySupplyUpdataWithUid:self.model.uid Success:^(id responseObject) {
            if ([[ responseObject objectForKey:@"success"] integerValue]) {
                NSDictionary *resultdic=[responseObject objectForKey:@"result"];
                NSDictionary *ProductSpecDIc=[resultdic objectForKey:@"ProductSpec"];
                NSArray *beanAry=[ProductSpecDIc objectForKey:@"bean"];

                //处理图片数组
                NSArray *imagesAry         = [resultdic objectForKey:@"images"];
                NSArray *imagesCompressAry = [resultdic objectForKey:@"imagesCompress"];
                NSArray *imagesDetailAry   = resultdic[@"imagesDetail"];
                NSMutableArray *imagesUrlMAry = [NSMutableArray arrayWithCapacity:2];
                for (int i = 0; i < imagesAry.count; i++) {

                    for (int j = 0; j < imagesCompressAry.count; j++) {

                        for (int k = 0; k < imagesDetailAry.count; k++) {
                            if (i == j && j == k) {
                                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
                                dic[@"url"]         = imagesAry[i];
                                dic[@"compressurl"] = imagesCompressAry[i];
                                dic[@"detailurl"]   = imagesDetailAry[i];
                                [imagesUrlMAry addObject:dic];
                            }
                        }
                    }
                };
                self.pickerImgView.urlMArr = imagesUrlMAry;
                //处理图片数组结束

                self.nurseryAry=[resultdic objectForKey:@"nurseryList"];
                self.baseDic=[resultdic objectForKey:@"baseMsg"];
                [self creatSCreeningCellsWithAnswerWithAry:beanAry];
            }else{
                [ToastView showTopToast:[ responseObject objectForKey:@"msg"]];
            }
           
        } failure:^(NSError *error) {
            
        }];
    }
}
-(void)creatSCreeningCellsWithAnswerWithAry:(NSArray *)specAry
{
    self.dataAry=[TreeSpecificationsModel creatTreeSpecificationsModelAryByAry:specAry];
    
    [self.backScrollView.subviews enumerateObjectsUsingBlock:^(UIView *myview, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([myview isKindOfClass:[FabutiaojiaCell class]]) {
            [myview removeFromSuperview];
        }
    }];
    CGFloat Y=205;
    for (int i=0; i<self.dataAry.count; i++) {
        TreeSpecificationsModel *model=self.dataAry[i];
        FabutiaojiaCell *cell;
        NSMutableString *answerStr=[NSMutableString string];
        for (int j=0; j<specAry.count; j++) {
            NSDictionary *specDic=specAry[j];
            
            if ([[specDic objectForKey:@"name"] isEqualToString:model.name]) {
                answerStr=[specDic objectForKey:@"value"];
            }
        }
        if ([answerStr isEqualToString:@"不限"]) {
            answerStr = [NSMutableString string];
        }
        
        cell=[[FabutiaojiaCell alloc]initWithFrame:CGRectMake(0, Y, kWidth, 50) AndModel:model andAnswer:answerStr];
        [_cellAry addObject:cell.model];
        Y=CGRectGetMaxY(cell.frame);
        // cell.delegate=self;
        [cell setBackgroundColor:[UIColor whiteColor]];
        [self.backScrollView addSubview:cell];
    }
    [self.backScrollView setContentSize:CGSizeMake(0, Y)];
    self.backScrollView.backgroundColor = [UIColor whiteColor];

}
- (void)nameChange {
    self.nameBtn.selected = NO;
}

#pragma mark - 下一步按钮点击事件
-(void)nextBtnAction:(UIButton *)sender
{
    if (self.titleTextField.text.length == 0 || self.titleTextField.text == nil) {
        [ToastView showTopToast:@"请输入标题"];
        return;
    }
    if (self.nameTextField.text.length == 0 || self.nameTextField.text == nil || self.nameBtn.selected == NO) {
        [ToastView showTopToast:@"请先确定苗木名称"];
        return;
    }
//    if (self.pickerImgView.urlMArr.count<3) {
//        [ToastView showTopToast:@"请添加三张苗木图片"];
//        return;
//    }
    self.supplyModel.title = self.titleTextField.text;
    self.supplyModel.name  = self.nameTextField.text;

    __block NSString *urlSring      = @"";
    __block NSString *compressSring = @"";
    [self.pickerImgView.urlMArr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        urlSring = [urlSring stringByAppendingString:[NSString stringWithFormat:@",%@",dic[@"url"]]];
        compressSring = [compressSring stringByAppendingString:[NSString stringWithFormat:@",%@",dic[@"compressurl"]]];
    }];
    if (self.pickerImgView.urlMArr.count != 0) {
        self.supplyModel.imageUrls = [urlSring substringFromIndex:1];
        self.supplyModel.imageCompressUrls = [compressSring substringFromIndex:1];
    }

    NSMutableArray *screenTijiaoAry = [NSMutableArray array];
    for (int i = 0; i < _cellAry.count; i++) {
        TreeSpecificationsModel *model = _cellAry[i];
        if (model.anwser.length>0) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:model.field,@"field",
                                 model.anwser,@"anwser"
                                 , nil];
            [screenTijiaoAry addObject:dic];
        }
    }
    self.supplyModel.specificationAttributes = [NSArray arrayWithObject:screenTijiaoAry];
    ZIKSupplyPublishNextVC *nextVC = [[ZIKSupplyPublishNextVC alloc] initWithNurseryList:self.nurseryAry WithbaseMsg:self.baseDic];
    nextVC.supplyModel = self.supplyModel;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)nameBtnAction:(UIButton *)button {
   // NSLog(@"确定按钮点击");
    if (button.selected) {
        return;
    }
    //NSLog(@"%@",self.nameTextField.text);
    if (self.nameTextField.text == nil || self.nameTextField.text.length == 0) {
        //NSLog(@"请输入苗木名称");
        [ToastView showToast:@"请输入苗木名称"
                 withOriginY:66.0f
               withSuperView:APPDELEGATE.window];
        return;
    }
    else {
        [HTTPCLIENT getMmAttributeWith:self.nameTextField.text WithType:@"1" Success:^(id responseObject) {
           // NSLog(@"%@",responseObject);
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
            //NSLog(@"%@",error);
        }];
    }

}

-(void)creatScreeningCells
{
    self.dataAry = [TreeSpecificationsModel creatTreeSpecificationsModelAryByAry:self.dataAry];
    //    NSLog(@"%@",ary);
    CGFloat Y = 205;

    [self.backScrollView.subviews enumerateObjectsUsingBlock:^(UIView *myview, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([myview isKindOfClass:[FabutiaojiaCell class]]) {
            [myview removeFromSuperview];
        }
    }];
    
    for (int i=0; i < self.dataAry.count; i++) {
        FabutiaojiaCell *cell = [[FabutiaojiaCell alloc] initWithFrame:CGRectMake(0, Y, kWidth, 44) AndModel:self.dataAry[i] andAnswer:nil];
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
                [ToastView showToast:@"暂时没有产品信息" withOriginY:Width/3 withSuperView:self.view];
            }
            else if (typeListArray.count > 0) {
                self.productTypeDataMArray = (NSMutableArray *)typeListArray;
                [self showSideView];
            }
        }
        else if ([[responseObject objectForKey:@"success"] integerValue] == 0) {

        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)showSideView {
     [[UIApplication sharedApplication] setStatusBarHidden:YES];
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
//- (BOOL)prefersStatusBarHidden
//{
//    return YES; // 返回NO表示要显示，返回YES将hiden
//}
#pragma mark - 实现选择苗木协议
- (void)didSelectorUid:(NSString *)selectId title:(NSString *)selectTitle {
    NSLog(@"%@",selectTitle);
    self.nameTextField.text = selectTitle;
    //self.supplyModel.name = selectTitle;
    self.supplyModel.productUid = selectId;
    [self.sideView removeSideViewAction];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
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
                if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
                    [self.pickerImgView addImage:image withUrl:responseObject[@"result"]];
                }
                else {
                    NSLog(@"图片上传失败");
                    [UIColor darkGrayColor];
                }

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
