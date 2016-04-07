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
@interface ZIKCustomizedSetViewController ()<UITextFieldDelegate,ZIKSelectViewUidDelegate>
{
    UIView *priceView;
    UILabel *priceLabel;
}
@property (nonatomic,strong ) UIScrollView     *backScrollView;
@property (nonatomic, strong) UITextField      *nameTextField;
@property (nonatomic,strong ) UIButton         *nameBtn;
@property (nonatomic, strong) NSArray          *dataAry;
@property (nonatomic, strong) NSMutableArray   *productTypeDataMArray;
@property (nonatomic, strong) ZIKSideView      *sideView;
@property (nonatomic, strong) NSString         *uid;//订制设置ID(添加时不传值，编辑时传值)
@property (nonatomic, strong) NSString         *productUid;//产品ID
@property (nonatomic, strong) NSString         *price;//定制价格
@property (nonatomic, strong) NSMutableArray   *cellAry;
@property (nonatomic, strong) NSArray          *specificationAttributes;

@end

@implementation ZIKCustomizedSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"定制设置";
    self.cellAry = [NSMutableArray array];
    [self initUI];
}

- (void)initUI {
    self.backScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-64)];
    [self.view addSubview:self.backScrollView];
    [self.backScrollView setBackgroundColor:BGColor];

    UIView *nameView = [[UIView alloc]initWithFrame:CGRectMake(0, 8, kWidth, 44)];
    [nameView setBackgroundColor:[UIColor whiteColor]];
    [self.backScrollView addSubview:nameView];

    UILabel *nameLab           = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, 44)];
    nameLab.text               = @"苗木名称";
    [nameView addSubview:nameLab];
    UITextField *nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, kWidth-100-60, 44)];
    nameTextField.placeholder  = @"请输入苗木名称";
    nameTextField.textColor    = NavColor;
    nameTextField.delegate     = self;
    self.nameTextField         = nameTextField;
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
    UIImageView *nameLineView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 43.5, kWidth-10, 0.5)];
    [nameLineView setBackgroundColor:kLineColor];
    [nameView addSubview:nameLineView];

    priceView = [[UIView alloc] init];
    priceView.frame = CGRectMake(0, CGRectGetMaxY(nameView.frame)+8, Width, 44);
    [self.backScrollView addSubview:priceView];
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.frame = CGRectMake(15, 10, 160, 24);
    hintLabel.text = @"规格越准确,求购越精准!";
    hintLabel.textColor = [UIColor darkGrayColor];
    hintLabel.font = [UIFont systemFontOfSize:14.0f];
    [priceView addSubview:hintLabel];
    priceLabel = [[UILabel alloc] init];
    priceLabel.frame = CGRectMake(Width-200, 0, Width-190, 44);
    priceLabel.textAlignment = NSTextAlignmentRight;
    [priceView addSubview:priceLabel];
    priceView.hidden  = YES;
    UIImageView *linView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 43, Width-20, 0.5)];
    [priceView addSubview:linView];
    [linView setBackgroundColor:kLineColor];


    self.nameBtn = nameBtn;

    UIButton *nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, kHeight-60, kWidth-80, 44)];
    [self.view addSubview:nextBtn];
    [nextBtn setBackgroundColor:NavColor];
    [nextBtn setTitle:@"确认完成" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    UITapGestureRecognizer *tapgest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidingKey)];
//    [self.backScrollView addGestureRecognizer:tapgest];
}

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
                priceLabel.text = [NSString stringWithFormat:@"¥%@/条",self.price];
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
    CGFloat Y = 44+8+44+8;

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
    NSLog(@"%@",selectTitle);
    self.nameTextField.text = selectTitle;
    //self.supplyModel.name = selectTitle;
    //self.supplyModel.productUid = selectId;
    self.productUid = selectId;
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

#pragma  mark - 确认完成按钮点击事件
- (void)nextBtnAction:(UIButton *)button {
    NSMutableArray *screenTijiaoAry=[NSMutableArray array];
    for (int i = 0; i < _cellAry.count; i++) {
        TreeSpecificationsModel *model = _cellAry[i];
        if (model.anwser.length>0) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:model.field,@"field",
                                 model.anwser,@"anwser"
                                 , nil];
            [screenTijiaoAry addObject:dic];
        }
    }
    self.specificationAttributes = [NSArray arrayWithObject:screenTijiaoAry];

   [HTTPCLIENT saveMyCustomizedInfo:nil productUid:self.productUid withSpecificationAttributes:self.specificationAttributes Success:^(id responseObject) {
       if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
           [ToastView showTopToast:@"发布成功"];
           [self.navigationController popViewControllerAnimated:YES];
//           for(UIViewController *controller in self.navigationController.viewControllers) {
//               if([controller isKindOfClass:[ZIKMySupplyViewController class]]){
//                   ZIKMySupplyViewController *owr = (ZIKMySupplyViewController *)controller;
//                   [self.navigationController popToViewController:owr animated:YES];
//               }
//           }
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

@end
