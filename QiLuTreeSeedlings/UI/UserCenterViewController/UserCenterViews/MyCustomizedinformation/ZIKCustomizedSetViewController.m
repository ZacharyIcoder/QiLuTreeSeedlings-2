//
//  ZIKCustomizedSetViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/31.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKCustomizedSetViewController.h"
#import "ZIKSideView.h"
#import "TreeSpecificationsModel.h"
#import "FabutiaojiaCell.h"
#define kMaxLength 20
#import "HttpClient.h"
#import "StringAttributeHelper.h"

#import "GuiGeView.h"
#import "YLDPickLocationView.h"
@interface ZIKCustomizedSetViewController ()<UITextFieldDelegate,ZIKSelectViewUidDelegate,GuiGeViewDelegate,YLDPickLocationDelegate>
{
    UIView *priceView;
    UILabel *priceLabel;
}
@property (nonatomic,strong ) UIScrollView       *backScrollView;
@property (nonatomic, strong) UITextField        *nameTextField;
@property (nonatomic,strong ) UIButton           *nameBtn;
@property (nonatomic, strong) NSArray            *dataAry;
@property (nonatomic, strong) NSMutableArray     *productTypeDataMArray;
@property (nonatomic, strong) ZIKSideView        *sideView;
@property (nonatomic, strong) NSString           *uid;//订制设置ID(添加时不传值，编辑时传值)
@property (nonatomic, strong) NSString           *productUid;//产品ID
@property (nonatomic, strong) NSString           *price;//定制价格
@property (nonatomic, strong) NSMutableArray     *cellAry;
@property (nonatomic, strong) NSArray            *specificationAttributes;
@property (nonatomic, strong) ZIKCustomizedModel *model;
@property (nonatomic, strong) NSDictionary       *baseMessageDic;


@property (nonatomic, strong) NSMutableArray *guige1Ary;
@property (nonatomic,strong)GuiGeView *guigeView;
@property (nonatomic,strong) UIButton *areaBtn;
@property (nonatomic,copy) NSString *AreaProvince;
@property (nonatomic,copy) NSString *AreaCity;
@property (nonatomic,copy) NSString *AreaTown;
@property (nonatomic,copy) NSString *AreaCounty;



@end

@implementation ZIKCustomizedSetViewController
@synthesize cellAry;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.model) {
        self.vcTitle = @"定制设置修改";
    }
    else {
        self.vcTitle = @"定制设置";
    }
    self.cellAry = [NSMutableArray array];
    self.guige1Ary = [NSMutableArray array];
    [self initUI];
}

-(id)initWithModel:(ZIKCustomizedModel *)model {
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)initUI {
    self.backScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-64)];
    [self.view addSubview:self.backScrollView];
    [self.backScrollView setBackgroundColor:BGColor];

    UIView *nameView = [[UIView alloc]initWithFrame:CGRectMake(0, 8, kWidth, 44*2)];
    [nameView setBackgroundColor:[UIColor whiteColor]];
    [self.backScrollView addSubview:nameView];

    UILabel *nameLab           = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, 44)];
    nameLab.text               = @"苗木名称";
    [nameView addSubview:nameLab];
    UITextField *nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, kWidth-100-60, 44)];
    nameTextField.placeholder  = @"请输入苗木名称";
    nameTextField.textColor    = NavColor;
    nameTextField.font = [UIFont systemFontOfSize:16.0f];
    nameTextField.delegate     = self;
    self.nameTextField         = nameTextField;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(nameChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nameTextField];
    [nameView addSubview:nameTextField];

    UILabel *addressLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 44, 80, 44)];
    addressLab.text = @"供货地";
    [nameView addSubview:addressLab];

    UIButton *cityBtn=[[UIButton alloc]initWithFrame:CGRectMake(100, 44, kWidth*0.6, 44)];
    [cityBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];

//    cityBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    cityBtn. contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;

//    cityBtn.backgroundColor = [UIColor grayColor];
    [cityBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
    [cityBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [cityBtn setTitle:@"请选择地区" forState:UIControlStateNormal];
    [nameView addSubview:cityBtn];
    [cityBtn addTarget:self action:@selector(cityBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.areaBtn=cityBtn;

    


    UIButton *nameBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-70, 9, 50, 25)];
    [nameView addSubview:nameBtn];
    [nameBtn addTarget:self action:@selector(nameBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [nameBtn setImage:[UIImage imageNamed:@"treeNameSure"] forState:UIControlStateNormal];
    [nameBtn setImage:[UIImage imageNamed:@"treeNameSure2"] forState:UIControlStateSelected];

    priceView = [[UIView alloc] init];
    priceView.backgroundColor = [UIColor whiteColor];
    priceView.frame = CGRectMake(0, CGRectGetMaxY(nameView.frame)+8, Width, 44);
    [self.backScrollView addSubview:priceView];

    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.frame = CGRectMake(15, 12, 20, 20);
    imageV.image = [UIImage imageNamed:@"注意"];
    [priceView addSubview:imageV];
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.frame = CGRectMake(15+20+2, 10, 160, 24);
    hintLabel.text = @"输入的越详细,匹配度越高";
    hintLabel.textColor = yellowButtonColor;
    hintLabel.font = [UIFont systemFontOfSize:14.0f];
    [priceView addSubview:hintLabel];
    priceLabel = [[UILabel alloc] init];
    priceLabel.frame = CGRectMake(Width-200, 0, 190, 44);
    priceLabel.textAlignment = NSTextAlignmentRight;
    [priceView addSubview:priceLabel];
     if (self.model) {
        priceView.hidden = NO;
        NSString *priceStr = [NSString stringWithFormat:@"价格 ¥%.2f/条",self.model.price.floatValue];
         // NSMutableString *
         FontAttribute *fullFont = [FontAttribute new];
         fullFont.font = [UIFont systemFontOfSize:15.0f];
         fullFont.effectRange  = NSMakeRange(0, priceStr.length);
         ForegroundColorAttribute *fullColor = [ForegroundColorAttribute new];
         fullColor.color = yellowButtonColor;
         fullColor.effectRange = NSMakeRange(0,priceStr.length);
         //局部设置
         FontAttribute *partFont = [FontAttribute new];
         partFont.font = [UIFont systemFontOfSize:15.0f];
         partFont.effectRange = NSMakeRange(0, 2);
         ForegroundColorAttribute *darkColor = [ForegroundColorAttribute new];
         darkColor.color = titleLabColor;
         darkColor.effectRange = NSMakeRange(0, 2);
         priceLabel.attributedText = [priceStr mutableAttributedStringWithStringAttributes:@[fullFont,partFont,fullColor,darkColor]];
    }
    else
    {
        priceView.hidden  = YES;
    }
    UIImageView *linView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 43, Width-20, 0.5)];
    [priceView addSubview:linView];
    [linView setBackgroundColor:kLineColor];


    self.nameBtn = nameBtn;

    UIButton *nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, kHeight-60, kWidth-80, 44)];
    [self.view addSubview:nextBtn];
    [nextBtn setBackgroundColor:NavColor];
    [nextBtn setTitle:@"确认完成" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    if (self.model) {
        self.nameTextField.text=self.model.productName;
        self.nameBtn.selected=YES;
        [self getEditingMessage];
    }

}



- (void)cityBtnAction:(UIButton *)button {
    YLDPickLocationView *pickerView=[[YLDPickLocationView alloc]initWithFrame:[UIScreen mainScreen].bounds CityLeve:CityLeveXian];
    pickerView.delegate=self;
    [pickerView showPickView];
    if (self.nameTextField) {
        [self.nameTextField resignFirstResponder];
    }

}

-(void)getEditingMessage
{
    [HTTPCLIENT getMyCustomsetEditingWithUid:self.model.customsetUid Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *dic = [[responseObject objectForKey:@"result"] objectForKey:@"ProductSpec"];
            self.productUid = [dic objectForKey:@"productUid"];
            NSArray *ary = [dic objectForKey:@"bean"];
            self.dataAry = ary;
            [self creatSCreeningCellsWithAnswerWithAry:ary];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {

    }];
}

-(void)creatSCreeningCellsWithAnswerWithAry:(NSArray *)guigeAry
{
    for (int i=0; i<guigeAry.count; i++) {
        NSDictionary *dic=guigeAry[i];
        if ([[dic objectForKey:@"level"] integerValue]==0) {
            GuiGeModel *guigeModel=[GuiGeModel creatGuiGeModelWithDic:dic];
            [self.guige1Ary addObject:guigeModel];
        }
        if ([[dic objectForKey:@"level"] integerValue]==1) {
            GuiGeModel *guigeModel=[GuiGeModel creatGuiGeModelWithDic:dic];
            //[selectAry addObject:guigeModel];
            for (int j=0; j<self.guige1Ary.count; j++) {
                GuiGeModel *guigeModel1=self.guige1Ary[j];
                for (int k=0 ; k<guigeModel1.propertyLists.count; k++) {
                    Propers *proper=guigeModel1.propertyLists[k];
                    if (proper.relation == guigeModel.uid) {
                        proper.guanlianModel=guigeModel;
                    }
                }
            }
        }
    }
//    _hintView.hidden = NO;
//    CGFloat Y = CGRectGetMaxY(_hintView.frame) ;


    GuiGeView *guigeView=[[GuiGeView alloc]initWithValueAry:self.guige1Ary andFrame:CGRectMake(0, 44+44+8+8+44, kWidth, 0)];
    [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(guigeView.frame))];
    guigeView.delegate=self;
    self.guigeView=guigeView;
    [self.backScrollView addSubview:guigeView];
    
}

//-(void)creatSCreeningCellsWithAnswerWithAry:(NSArray *)specAry
//{
//    self.dataAry=[TreeSpecificationsModel creatTreeSpecificationsModelAryByAry:self.dataAry];
//
//    [self.backScrollView.subviews enumerateObjectsUsingBlock:^(UIView *myview, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([myview isKindOfClass:[FabutiaojiaCell class]]) {
//            [myview removeFromSuperview];
//        }
//    }];
//    CGFloat Y = 44+44+8+8;
//    for (int i=0; i<self.dataAry.count; i++) {
//        TreeSpecificationsModel *model=self.dataAry[i];
//        FabutiaojiaCell *cell;
//        NSMutableString *answerStr=[NSMutableString string];
//        for (int j=0; j<specAry.count; j++) {
//            NSDictionary *specDic=specAry[j];
//
//            if ([[specDic objectForKey:@"name"] isEqualToString:model.name]) {
//                answerStr=[specDic objectForKey:@"value"];
//            }
//        }
//        if ([answerStr isEqualToString:@"不限"]) {
//            answerStr = [NSMutableString string];
//        }
//
//        cell=[[FabutiaojiaCell alloc]initWithFrame:CGRectMake(0, Y, kWidth, 50) AndModel:model andAnswer:answerStr];
//        [cellAry addObject:cell.model];
//        Y=CGRectGetMaxY(cell.frame);
//        // cell.delegate=self;
//        [cell setBackgroundColor:[UIColor whiteColor]];
//        [self.backScrollView addSubview:cell];
//        [self.backScrollView setContentSize:CGSizeMake(0, Y)];
//    }
//
//}

- (void)nameChange {
    self.nameBtn.selected = NO;
}

#pragma mark - 确定按钮点击事件
-(void)nameBtnAction:(UIButton *)button
{
    if ([ZIKFunction xfunc_check_strEmpty:self.nameTextField.text]) {
        [ToastView showTopToast:@"请先输入苗木名称"];
        return;
    }
    else {
        [self.nameTextField resignFirstResponder];
        [HTTPCLIENT getMmAttributeWith:self.nameTextField.text WithType:@"2" Success:^(id responseObject) {
            // NSLog(@"%@",responseObject);
            if ([responseObject[@"msg"] isEqualToString:@"该苗木不存在"]) {
                [ToastView showTopToast:@"该苗木不存在"];
                [self requestProductType];
            }
            else {
                NSDictionary *dic = [responseObject objectForKey:@"result"];
                self.dataAry = [dic objectForKey:@"list"];
                self.price = [dic objectForKey:@"price"];
                priceView.hidden = NO;
//                priceLabel.text = [NSString stringWithFormat:@"¥%.2f/条",self.price.floatValue];
                NSString *priceStr = [NSString stringWithFormat:@"价格 ¥%.2f/条",self.price.floatValue];
                // NSMutableString *
                FontAttribute *fullFont = [FontAttribute new];
                fullFont.font = [UIFont systemFontOfSize:15.0f];
                fullFont.effectRange  = NSMakeRange(0, priceStr.length);
                ForegroundColorAttribute *fullColor = [ForegroundColorAttribute new];
                fullColor.color = yellowButtonColor;
                fullColor.effectRange = NSMakeRange(0,priceStr.length);
                //局部设置
                FontAttribute *partFont = [FontAttribute new];
                partFont.font = [UIFont systemFontOfSize:15.0f];
                partFont.effectRange = NSMakeRange(0, 2);
                ForegroundColorAttribute *darkColor = [ForegroundColorAttribute new];
                darkColor.color = titleLabColor;
                darkColor.effectRange = NSMakeRange(0, 2);
                priceLabel.attributedText = [priceStr mutableAttributedStringWithStringAttributes:@[fullFont,partFont,fullColor,darkColor]];

                self.productUid = [dic objectForKey:@"productUid"];
                button.selected = YES;
                NSArray *guigeAry=[dic objectForKey:@"list"];
                // NSMutableArray *selectAry=[NSMutableArray array];
                for (int i=0; i<guigeAry.count; i++) {
                    NSDictionary *dic=guigeAry[i];
                    if ([[dic objectForKey:@"level"] integerValue]==0) {
                        GuiGeModel *guigeModel=[GuiGeModel creatGuiGeModelWithDic:dic];
                        [self.guige1Ary addObject:guigeModel];
                    }
                    if ([[dic objectForKey:@"level"] integerValue]==1) {
                        GuiGeModel *guigeModel=[GuiGeModel creatGuiGeModelWithDic:dic];
                        //[selectAry addObject:guigeModel];
                        for (int j=0; j<self.guige1Ary.count; j++) {
                            GuiGeModel *guigeModel1=self.guige1Ary[j];
                            for (int k=0 ; k<guigeModel1.propertyLists.count; k++) {
                                Propers *proper=guigeModel1.propertyLists[k];
                                if (proper.relation == guigeModel.uid) {
                                    proper.guanlianModel=guigeModel;
                                }
                            }
                        }
                    }
                }

                [self creatScreeningCells];
            }
        } failure:^(NSError *error) {
            //NSLog(@"%@",error);
        }];

    }

}

-(void)creatScreeningCells
{
//    self.dataAry = [TreeSpecificationsModel creatTreeSpecificationsModelAryByAry:self.dataAry];
//    //    NSLog(@"%@",ary);
    CGFloat Y = 44+8+44+8+44;
//
//    [self.backScrollView.subviews enumerateObjectsUsingBlock:^(UIView *myview, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([myview isKindOfClass:[FabutiaojiaCell class]]) {
//            [myview removeFromSuperview];
//        }
//    }];
//
//    for (int i=0; i < self.dataAry.count; i++) {
//        FabutiaojiaCell *cell = [[FabutiaojiaCell alloc] initWithFrame:CGRectMake(0, Y, kWidth, 44) AndModel:self.dataAry[i] andAnswer:nil];
//        cell.backgroundColor = [UIColor whiteColor];
//        [cellAry addObject:cell.model];
//        Y = CGRectGetMaxY(cell.frame);
//        [self.backScrollView addSubview:cell];
//    }
//    [self.backScrollView setContentSize:CGSizeMake(0, Y)];
//    //self.backScrollView.backgroundColor = [UIColor whiteColor];
//
//    button.selected=YES;
//    NSDictionary *dic=[responseObject objectForKey:@"result"];
//    self.productUid=[dic objectForKey:@"productUid"];
//    NSArray *guigeAry=[dic objectForKey:@"list"];
//    // NSMutableArray *selectAry=[NSMutableArray array];
//    for (int i=0; i<guigeAry.count; i++) {
//        NSDictionary *dic=guigeAry[i];
//        if ([[dic objectForKey:@"level"] integerValue]==0) {
//            GuiGeModel *guigeModel=[GuiGeModel creatGuiGeModelWithDic:dic];
//            [self.guige1Ary addObject:guigeModel];
//        }
//        if ([[dic objectForKey:@"level"] integerValue]==1) {
//            GuiGeModel *guigeModel=[GuiGeModel creatGuiGeModelWithDic:dic];
//            //[selectAry addObject:guigeModel];
//            for (int j=0; j<self.guige1Ary.count; j++) {
//                GuiGeModel *guigeModel1=self.guige1Ary[j];
//                for (int k=0 ; k<guigeModel1.propertyLists.count; k++) {
//                    Propers *proper=guigeModel1.propertyLists[k];
//                    if (proper.relation == guigeModel.uid) {
//                        proper.guanlianModel=guigeModel;
//                    }
//                }
//            }
//        }
//    }
//    _hintView.hidden = NO;
//    CGFloat Y = CGRectGetMaxY(_hintView.frame) ;

    GuiGeView *guigeView=[[GuiGeView alloc]initWithAry:self.guige1Ary andFrame:CGRectMake(0, Y, kWidth, 0)];
    [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(guigeView.frame))];
    guigeView.delegate=self;
    self.guigeView=guigeView;
    [self.backScrollView addSubview:guigeView];

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

        }
    } failure:^(NSError *error) {
        //NSLog(@"%@",error);
    }];
}

- (void)showSideView {
    //[self.nameTextField resignFirstResponder];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //self.prefersStatusBarHidden = YES;
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
   // NSLog(@"%@",selectTitle);
    self.nameTextField.text = selectTitle;
    //self.supplyModel.name = selectTitle;
    //self.supplyModel.productUid = selectId;
    self.productUid = selectId;
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
                //NSLog(@"最多%d个字符!!!",kMaxLength);
                //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%d个字符",kMaxLength] view:nil];
                [ToastView showToast:[NSString stringWithFormat:@"最多%d个字符",kMaxLength] withOriginY:250 withSuperView:self.view];
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

#pragma  mark - 确认完成按钮点击事件
- (void)nextBtnAction:(UIButton *)button {
    if (!self.nameBtn.selected) {
        [ToastView showToast:@"请确认苗木名称" withOriginY:250 withSuperView:self.view];
        return;
    }

    NSMutableArray *screenTijiaoAry=[NSMutableArray array];
    for (int i = 0; i < cellAry.count; i++) {
        TreeSpecificationsModel *model = cellAry[i];
        if (model.anwser.length>0) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:model.field,@"field",
                                 model.anwser,@"anwser"
                                 , nil];
            [screenTijiaoAry addObject:dic];
        }
    }
    self.specificationAttributes = [NSArray arrayWithObject:screenTijiaoAry];

   [HTTPCLIENT saveMyCustomizedInfo:self.model.customsetUid productUid:self.productUid withSpecificationAttributes:self.specificationAttributes Success:^(id responseObject) {
       if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
           if (self.model) {
               [ToastView showTopToast:@"修改成功"];
           }
           else {
           [ToastView showTopToast:@"发布成功"];
           }
           [self.navigationController popViewControllerAnimated:YES];
       }
       else {
           //NSLog(@"%@",responseObject[@"msg"]);
           [ToastView showTopToast:responseObject[@"msg"]];
       }


   } failure:^(NSError *error) {

   }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)reloadViewWithFrame:(CGRect)frame
{
    [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(frame))];
}

-(void)selectSheng:(CityModel *)sheng shi:(CityModel *)shi xian:(CityModel *)xian zhen:(CityModel *)zhen
{
    NSMutableString *namestr=[NSMutableString new];
    if (sheng.code) {
        [namestr appendString:sheng.cityName];
        self.AreaProvince=sheng.code;
    }else
    {
        self.AreaProvince=nil;
    }

    if (shi.code) {
        [namestr appendString:shi.cityName];
        self.AreaCity=shi.code;
    }else
    {
        self.AreaCity=nil;

    }
//    if (xian.code) {
//        [namestr appendString:xian.cityName];
//        self.AreaCounty=xian.code;
//    }else
//    {
//        self.AreaCounty=nil;
//    }
    if (namestr.length>0) {
        [self.areaBtn setTitle:namestr forState:UIControlStateNormal];
        [self.areaBtn.titleLabel sizeToFit];
    }else{
        [self.areaBtn setTitle:@"不限" forState:UIControlStateNormal];
        [self.areaBtn.titleLabel sizeToFit];

    }

}


@end
