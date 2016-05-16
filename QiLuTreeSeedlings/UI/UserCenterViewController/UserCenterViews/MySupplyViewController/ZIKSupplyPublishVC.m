//
//  ZIKSupplyPublishVC.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/28.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKSupplyPublishVC.h"

#import "UIDefines.h"
#import "HttpClient.h"

#import "ZIKMySupplyCreateModel.h"

#import "WHC_PhotoListCell.h"
#import "WHC_PictureListVC.h"
#import "ZIKAddImageView.h"
#import "ZIKPickerBtn.h"
#import "BigImageViewShowView.h"
#import "ZIKSideView.h"
#import "ZIKSelectView.h"
#import "ZIKHintTableViewCell.h"
#import "FabutiaojiaCell.h"

#import "ZIKSupplyPublishNextVC.h"

#define kMaxLength 20

@interface ZIKSupplyPublishVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,
UITextFieldDelegate,UIAlertViewDelegate,ZIKSelectViewUidDelegate,WHC_ChoicePictureVCDelegate>

@property (nonatomic, strong) UITableView            *supplyInfoTableView;
@property (nonatomic, strong) ZIKAddImageView        *addImageView;
@property (nonatomic, strong) UIActionSheet          *myActionSheet;
@property (nonatomic, strong) UIButton               *sureButton;
@property (nonatomic, strong) UITextField            *nameTextField;
@property (nonatomic, strong) ZIKSideView            *sideView;
@property (nonatomic, strong) NSMutableArray         *productTypeDataMArray;
@property (nonatomic, strong) NSArray                *dataAry;
@property (nonatomic, strong) NSMutableArray         *cellAry;
@property (nonatomic, strong) UIScrollView           *backScrollView;
@property (nonatomic, strong) UITextField            *titleTextField;
@property (nonatomic, strong) UIButton               *nameBtn;
@property (nonatomic, strong) UITextField            *nowTextField;
@property (nonatomic, strong) ZIKMySupplyCreateModel *supplyModel;
@property (nonatomic, strong) SupplyDetialMode       *model;
@property (nonatomic, strong) NSArray                *nurseryAry;
@property (nonatomic, strong) NSDictionary           *baseDic;
@end

@implementation ZIKSupplyPublishVC
{
    UIView *_nameView;
    NSArray *_urlArr;
    ZIKHintTableViewCell *_hintView;
}

-(id)initWithModel:(SupplyDetialMode*)model
{
    self = [super init];
    if (self) {
        self.model = model;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (_urlArr.count > 0 ) {
        if (!self.addImageView.saveHaveImageMarr) {
            self.addImageView.saveHaveImageMarr  = (NSMutableArray *)_urlArr;
        }
     }
}

- (void)initData {
    self.productTypeDataMArray = [NSMutableArray array];
    self.cellAry               = [NSMutableArray array];
    self.supplyModel           = [[ZIKMySupplyCreateModel alloc] init];
}

- (void)initUI {
    self.backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-64)];
    [self.view addSubview:self.backScrollView];
    [self.backScrollView setBackgroundColor:BGColor];

    UIView *myveiw1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 10)];
    myveiw1.backgroundColor = BGColor;
    [self.backScrollView addSubview:myveiw1];

    CGRect tempFrame  = CGRectMake(0,10, kWidth, 44);
    UIView *titleView = [[UIView alloc] initWithFrame:tempFrame];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 40, 44)];
    [titleLab setFont:[UIFont systemFontOfSize:15]];
    [titleView addSubview:titleLab];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    titleLab.text = @"标题";
    UITextField *titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(70, 0, kWidth-70, 44)];
    [titleTextField setFont:[UIFont systemFontOfSize:15]];
    titleTextField.placeholder  = @"请输入标题(限制在20字以内)";
    titleTextField.textColor = titleLabColor;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:titleTextField];
    self.titleTextField = titleTextField;
    UIView *titleLineView = [[UIView alloc]initWithFrame:CGRectMake(15, titleView.frame.size.height-1, kWidth-30, 1)];
    [titleLineView setBackgroundColor:BGColor];
    [titleView addSubview:titleLineView];
    [titleView addSubview:titleTextField];
    titleTextField.delegate = self;
    titleTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.backScrollView addSubview:titleView];
    tempFrame.origin.y += 44.5;
    
    ZIKAddImageView *pickView = [[ZIKAddImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), Width, (Width-60)/3 + 45)];
    pickView.backgroundColor = [UIColor whiteColor];

    [self.backScrollView addSubview:pickView];
    self.addImageView = pickView;
    __weak typeof(self) weakSelf = self;
    self.addImageView.lookPhotoBlock = ^(){//展示照片
        BigImageViewShowView *showView = [[BigImageViewShowView alloc] initWithImageAry:weakSelf.addImageView.imageArr];
        [weakSelf.view addSubview:showView];
        [showView showWithIndex:0];
        };
     self.addImageView.takePhotoBlock = ^{//添加照片
        [weakSelf openMenu];
    };

    _nameView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(pickView.frame), kWidth, 54)];
    [_nameView setBackgroundColor:[UIColor whiteColor]];

    [self.backScrollView addSubview:_nameView];

    UIView *myveiw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 10)];
    myveiw.backgroundColor = BGColor;
    [_nameView addSubview:myveiw];

    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 80, 44)];
    [nameLab setFont:[UIFont systemFontOfSize:15]];
    nameLab.text = @"苗木名称";
    [_nameView addSubview:nameLab];
    UITextField *nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, nameLab.frame.origin.y, kWidth-100-60, nameLab.frame.size.height)];
    nameTextField.placeholder = @"请输入名称";
    nameTextField.textColor = NavColor;
    nameTextField.delegate = self;
    [nameTextField setFont:[UIFont systemFontOfSize:15]];
    self.nameTextField = nameTextField;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(nameChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nameTextField];
    [_nameView addSubview:nameTextField];

    UIButton *nameBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-70, 9+10, 50, 25)];
    [_nameView addSubview:nameBtn];
    [nameBtn addTarget:self action:@selector(nameBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [nameBtn setImage:[UIImage imageNamed:@"treeNameSure"] forState:UIControlStateNormal];
    [nameBtn setImage:[UIImage imageNamed:@"treeNameSure2"] forState:UIControlStateSelected];
    UIImageView *nameLineView = [[UIImageView alloc]initWithFrame:CGRectMake(10, _nameView.frame.size.height-1, kWidth-10, 0.5)];
    [nameLineView setBackgroundColor:kLineColor];

    self.nameBtn = nameBtn;

    ZIKHintTableViewCell *hintView = [[[NSBundle mainBundle] loadNibNamed:@"ZIKHintTableViewCell" owner:self options:nil] lastObject];
    hintView.frame = CGRectMake(0, CGRectGetMaxY(_nameView.frame)-5, Width, HINT_VIEW_HEIGHT);
    hintView.hintStr = @"输入的越详细,匹配度越高";
    hintView.hidden = YES;
    hintView.contentView.backgroundColor = BGColor;
    [self.backScrollView addSubview:hintView];
    _hintView = hintView;

    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, kHeight-60, kWidth-80, 44)];
    [self.view addSubview:nextBtn];
    [nextBtn setBackgroundColor:NavColor];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidingKey)];
    [self.backScrollView addGestureRecognizer:tapgest];
    if (self.model) {
        self.titleTextField.text = self.model.title;
        self.nameTextField.text  = self.model.productName;
        self.nameBtn.selected    = YES;
        //__weak typeof(self) weakSelf = self;
        [HTTPCLIENT mySupplyUpdataWithUid:self.model.uid Success:^(id responseObject) {
            if ([[ responseObject objectForKey:@"success"] integerValue]) {
                NSDictionary *resultdic       = [responseObject objectForKey:@"result"];
                NSDictionary *ProductSpecDIc  = [resultdic objectForKey:@"ProductSpec"];
                NSArray *beanAry              = [ProductSpecDIc objectForKey:@"bean"];

                //处理图片数组
                NSArray *imagesAry            = [resultdic objectForKey:@"images"];
                NSArray *imagesCompressAry    = [resultdic objectForKey:@"imagesCompress"];
                NSArray *imagesDetailAry      = resultdic[@"imagesDetail"];
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
                weakSelf.addImageView.urlMArr = imagesUrlMAry;
                //处理图片数组结束

                weakSelf.nurseryAry            = [resultdic objectForKey:@"nurseryList"];
                weakSelf.baseDic               = [resultdic objectForKey:@"baseMsg"];
                [weakSelf creatSCreeningCellsWithAnswerWithAry:beanAry];
            }else{
                [ToastView showTopToast:[ responseObject objectForKey:@"msg"]];
            }
           
        } failure:^(NSError *error) {
            
        }];
    }
}

-(void)creatSCreeningCellsWithAnswerWithAry:(NSArray *)specAry
{
    self.dataAry = [TreeSpecificationsModel creatTreeSpecificationsModelAryByAry:specAry];
    
    [self.backScrollView.subviews enumerateObjectsUsingBlock:^(UIView *myview, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([myview isKindOfClass:[FabutiaojiaCell class]]) {
            [myview removeFromSuperview];
        }
    }];
    _hintView.hidden = NO;
    CGFloat Y = CGRectGetMaxY(_hintView.frame);
    for (int i = 0; i < self.dataAry.count; i++) {
        TreeSpecificationsModel *model = self.dataAry[i];
        FabutiaojiaCell *cell;
        NSMutableString *answerStr = [NSMutableString string];
        for (int j = 0; j < specAry.count; j++) {
            NSDictionary *specDic = specAry[j];
            
            if ([[specDic objectForKey:@"name"] isEqualToString:model.name]) {
                answerStr = [specDic objectForKey:@"value"];
            }
        }
        if ([answerStr isEqualToString:@"不限"]) {
            answerStr = [NSMutableString string];
        }
        
        cell = [[FabutiaojiaCell alloc] initWithFrame:CGRectMake(0, Y, kWidth, 50) AndModel:model andAnswer:answerStr];
        [_cellAry addObject:cell.model];
        Y = CGRectGetMaxY(cell.frame);
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
    if (self.addImageView.urlMArr.count<3) {
        [ToastView showTopToast:@"请添加三张苗木图片"];
        return;
    }
    self.supplyModel.title = self.titleTextField.text;
    self.supplyModel.name  = self.nameTextField.text;

    __block NSString *urlSring      = @"";
    __block NSString *compressSring = @"";
    [self.addImageView.urlMArr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        urlSring = [urlSring stringByAppendingString:[NSString stringWithFormat:@",%@",dic[@"url"]]];
        compressSring = [compressSring stringByAppendingString:[NSString stringWithFormat:@",%@",dic[@"compressurl"]]];
    }];
    if (self.addImageView.urlMArr.count != 0) {
        self.supplyModel.imageUrls         = [urlSring substringFromIndex:1];
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
    _urlArr = self.addImageView.urlMArr;
    if (self.addImageView.haveImageMArr.count > 0) {
        [self.addImageView.haveImageMArr enumerateObjectsUsingBlock:^(ZIKPickerBtn *btn, NSUInteger idx, BOOL * _Nonnull stop) {
            [btn removeFromSuperview];
        }];
        [self.addImageView.haveImageMArr removeAllObjects];
    }


    ZIKSupplyPublishNextVC *nextVC = [[ZIKSupplyPublishNextVC alloc] initWithNurseryList:self.nurseryAry WithbaseMsg:self.baseDic];
    //nextVC.pickerImgView = self.addImageView;
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
        [ToastView showToast:@"请输入苗木名称"
                 withOriginY:66.0f
               withSuperView:APPDELEGATE.window];
        return;
    }
    else {
        [HTTPCLIENT getMmAttributeWith:self.nameTextField.text WithType:@"1" Success:^(id responseObject) {
           // NSLog(@"%@",responseObject);
            if ([responseObject[@"msg"] isEqualToString:@"该苗木不存在"]) {
                [ToastView showTopToast:@"该苗木不存在"];
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
    _hintView.hidden = NO;
    CGFloat Y = CGRectGetMaxY(_hintView.frame) ;

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
                //NSLog(@"暂时没有产品信息!!!");
                [ToastView showToast:@"暂时没有产品信息" withOriginY:Width/3 withSuperView:self.view];
            }
            else if (typeListArray.count > 0) {
                self.productTypeDataMArray = (NSMutableArray *)typeListArray;
                [self showSideView];
            }
        }
        else if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
               [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:Width/3 withSuperView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)showSideView {
    [self.titleTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];

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
    //NSLog(@"%@",selectTitle);
    self.nameTextField.text = selectTitle;
    //self.supplyModel.name = selectTitle;
    self.supplyModel.productUid = selectId;
    [self.sideView removeSideViewAction];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self nameBtnAction:self.nameBtn];
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
               // NSLog(@"最多%d个字符!!!",kMaxLength);
                [ToastView showToast:[NSString stringWithFormat:@"最多%d个字符",kMaxLength] withOriginY:250 withSuperView:self.view];
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
             //NSLog(@"最多%d个字符!!!",kMaxLength);
            [ToastView showToast:[NSString stringWithFormat:@"最多%d个字符",kMaxLength] withOriginY:250 withSuperView:self.view];
            textField.text = [toBeString substringToIndex:kMaxLength];
            return;
        }
    }
}

-(void)openMenu
{
    [self.titleTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];

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
        //NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    WHC_PictureListVC  * vc = [WHC_PictureListVC new];
    vc.delegate = self;
    vc.maxChoiceImageNumberumber = 3-self.addImageView.urlMArr.count;
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
}

#pragma mark - WHC_ChoicePictureVCDelegate
- (void)WHCChoicePictureVCdidSelectedPhotoArr:(NSArray *)photoArr{
    for (__weak UIImage *image in photoArr) {
        ShowActionV();
        HttpClient *httpClient  = [HttpClient sharedClient];
      __block  NSData* imageData = nil;

        imageData  = [self  imageData:image];

      __block  NSString *myStringImageFile = [imageData base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
         __weak typeof(self) weakSelf = self;
        [httpClient upDataImageIOS:myStringImageFile Success:^(id responseObject) {
            myStringImageFile = nil;
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                 if ([[responseObject objectForKey:@"success"] integerValue] == 1) {

//                    [weakSelf setPhotoToPath:imageData isName:@"imageData"];
//
//                    [weakSelf.addImageView addImage:[weakSelf getPhotoFromName:@"imageData"] withUrl:responseObject[@"result"]];
//                    imageData = nil;
                    [weakSelf.addImageView addImage:[UIImage imageWithData:imageData]  withUrl:responseObject[@"result"]];
                    [ToastView showToast:@"图片上传成功" withOriginY:250 withSuperView:weakSelf.view];
                    RemoveActionV();
                    
                }
                else {
                    //NSLog(@"图片上传失败");
                    [ToastView showToast:@"上传图片失败" withOriginY:250 withSuperView:weakSelf.view];
                    [UIColor darkGrayColor];
                    RemoveActionV();
                }

                //self.pickerImgView.photos
            }
        } failure:^(NSError *error) {

            RemoveActionV();
            [ToastView showToast:@"上传图片失败" withOriginY:250 withSuperView:self.view];
        }];
    }
    //NSLog(@"3333");
 }

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];

    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
      __weak  UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        ShowActionV();
        HttpClient *httpClient  = [HttpClient sharedClient];
        NSData* imageData = nil;
        imageData  = [self imageData:image];
        //NSLog(@"%ld",imageData.length);

        NSString *myStringImageFile = [imageData base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
        //NSLog(@"%ld",myStringImageFile.length);

        [httpClient upDataImageIOS:myStringImageFile Success:^(id responseObject) {
             RemoveActionV();
            if ([responseObject isKindOfClass:[NSDictionary class]]) {

                if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
                    [self.addImageView addImage:[UIImage imageWithData:imageData]  withUrl:responseObject[@"result"]];
                    [ToastView showToast:@"图片上传成功" withOriginY:200 withSuperView:self.view];
                }
                else {
                    //NSLog(@"图片上传失败");
                    [ToastView showToast:@"上传图片失败" withOriginY:200 withSuperView:self.view];
                    [UIColor darkGrayColor];
                }

             }
        } failure:^(NSError *error) {

            [ToastView showToast:@"上传图片失败" withOriginY:200 withSuperView:self.view];
        }];
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
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"%ld",(long)buttonIndex);
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
}

-(void)cellKeyHight:(CGFloat)hight
{
    if (self.backScrollView.frame.size.height==kHeight-hight-44-44) {
        return;
    }
}

-(void)hidingKey
{
    if (self.nowTextField) {
        [self.nowTextField resignFirstResponder];
    }
    if (self.backScrollView.frame.size.height==kHeight-44-44) {
        return;
    }
}

-(NSData *)imageData:(UIImage *)myimage
{
    __weak typeof(myimage) weakImage = myimage;
    NSData *data = UIImageJPEGRepresentation(weakImage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data = UIImageJPEGRepresentation(weakImage, 0.1);
        }
        else if (data.length>512*1024) {//0.5M-1M
            data = UIImageJPEGRepresentation(weakImage, 0.9);
        }
        else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(weakImage, 0.9);
        }
    }
    return data;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.titleTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
}
@end
