//
//  ZIKCustomizedSetViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/31.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKCustomizedSetViewController.h"

@interface ZIKCustomizedSetViewController ()<UITextFieldDelegate>
@property (nonatomic,strong ) UIScrollView     *backScrollView;
@property (nonatomic, strong) UITextField      *nameTextField;
@property (nonatomic,strong ) UIButton         *nameBtn;
@property (nonatomic, strong) NSArray          *dataAry;

@end

@implementation ZIKCustomizedSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"定制设置";
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
    UIImageView *nameLineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 43.5, kWidth-10, 0.5)];
    [nameLineView setBackgroundColor:kLineColor];
    [nameView addSubview:nameLineView];


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
        [HTTPCLIENT getMmAttributeWith:self.nameTextField.text WithType:@"1" Success:^(id responseObject) {
            // NSLog(@"%@",responseObject);
            if ([responseObject[@"msg"] isEqualToString:@"该苗木不存在"]) {
                [ToastView showTopToast:@"该苗木不存在"];
                //[self requestProductType]aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
            }
            else {
                NSDictionary *dic = [responseObject objectForKey:@"result"];
                self.dataAry = [dic objectForKey:@"list"];
                button.selected = YES;
                //[self creatScreeningCells];
            }
        } failure:^(NSError *error) {
            //NSLog(@"%@",error);
        }];

    }

}

#pragma  mark - 确认完成按钮点击事件
- (void)nextBtnAction:(UIButton *)button {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
