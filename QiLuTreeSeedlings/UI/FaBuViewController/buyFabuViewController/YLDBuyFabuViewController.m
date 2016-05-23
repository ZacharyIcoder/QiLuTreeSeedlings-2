//
//  YLDBuyFabuViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/23.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDBuyFabuViewController.h"
#import "UIDefines.h"
#import "PickerShowView.h"
@interface YLDBuyFabuViewController ()<PickeShowDelegate>
@property (nonatomic,strong)UITextField *birefField;
@property (nonatomic,strong)UIButton *ectiveBtn;
@property (nonatomic)NSInteger ecttiv;
@property (nonatomic,strong)UIButton *areaBtn;
@property (nonatomic,strong)UITextField *countTextField;
@property (nonatomic,strong)UITextField *priceTextField;
@property (nonatomic,strong)PickerShowView *ecttivePickerView;
@property (nonatomic,strong)UIView *otherInfoView;
@end

@implementation YLDBuyFabuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        UIView *otherView=[[UIView alloc]initWithFrame:CGRectMake(0, 15, kWidth, 250)];
        //self.otherInfoView=otherView;
    
        CGRect  tempFrame=CGRectMake(0, 0, kWidth, 50);
        UITextField *countTextField=[self mackViewWtihName:@"数量" alert:@"请输入数量" unit:@"棵" withFrame:tempFrame];
        self.countTextField=countTextField;
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:countTextField];
        countTextField.keyboardType=UIKeyboardTypeNumberPad;
        tempFrame.origin.y+=50;
        UITextField *priceTextField=[self mackViewWtihName:@"价格" alert:@"请输入单价" unit:@"元" withFrame:tempFrame];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:priceTextField];
        self.priceTextField=priceTextField;
        priceTextField.keyboardType=UIKeyboardTypeDecimalPad;
        tempFrame.origin.y+=50;
        UIView *ecttiveView=[[UIView alloc]initWithFrame:tempFrame];
        [ecttiveView setBackgroundColor:[UIColor whiteColor]];
        UILabel *ecttNameLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 70, 50)];
        [ecttiveView addSubview:ecttNameLab];
        UIImageView *lineImagV=[[UIImageView alloc]initWithFrame:CGRectMake(15, 49.5, kWidth-30, 0.5)];
        [lineImagV setBackgroundColor:kLineColor];
        [ecttiveView addSubview:lineImagV];
        [otherView addSubview:ecttiveView];
        [ecttNameLab setText:@"有效期"];
        [ecttNameLab setTextColor:titleLabColor];
        [ecttNameLab setFont:[UIFont systemFontOfSize:15]];
        UIButton *ecttiveBtn=[[UIButton alloc]initWithFrame:CGRectMake(120, 0, kWidth-200, 50)];
        [ecttiveView addSubview:ecttiveBtn];
        [ecttiveBtn setTitle:@"请选择" forState:UIControlStateNormal];
        [ecttiveBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
        self.ectiveBtn=ecttiveBtn;
        [ecttiveBtn addTarget:self action:@selector(ecttiveBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [ecttiveBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        tempFrame.origin.y+=50;
        UIView *areaView=[[UIView alloc]initWithFrame:tempFrame];
        [areaView setBackgroundColor:[UIColor whiteColor]];
        UIImageView *lineImagV2=[[UIImageView alloc]initWithFrame:CGRectMake(15, 49.5, kWidth-30, 0.5)];
        [lineImagV2 setBackgroundColor:kLineColor];
        [areaView addSubview:lineImagV2];
        UILabel *areaLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 70, 50)];
        areaLab.text=@"用苗地";
        [areaLab setTextColor:titleLabColor];
        [areaLab setFont:[UIFont systemFontOfSize:15]];
        [areaView addSubview:areaLab];
        UIButton *areaBtn=[[UIButton alloc]initWithFrame:CGRectMake(100, 0, kWidth-150, 50)];
        [areaBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [areaBtn setTitle:@"请选择用苗地" forState:UIControlStateNormal];
        [areaBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
        [areaView addSubview:areaBtn];
        self.areaBtn=areaBtn;
        [areaBtn addTarget:self action:@selector(areBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [otherView addSubview:areaView];
        tempFrame.origin.y+=50;
    
        UITextField *birefField=[self mackViewWtihName:@"备注" alert:@"请输入备注信息" unit:@"" withFrame:tempFrame];
        self.birefField=birefField;
        birefField.tag=1111;
        
        
        [self.view addSubview:otherView];
        //[self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(otherView.frame))];
    // Do any additional setup after loading the view.
}
-(void)ecttiveBtnAction
{
    if (!self.ecttivePickerView) {
        self.ecttivePickerView=[[PickerShowView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.ecttivePickerView resetPickerData:@[@"一天",@"三天",@"五天",@"一周",@"半个月",@"一个月",@"三个月",@"半年",@"一年",@"长期"]];
        self.ecttivePickerView.delegate=self;
    }
    [self.ecttivePickerView showInView];
}
-(UITextField *)mackViewWtihName:(NSString *)name alert:(NSString *)alert unit:(NSString *)unit withFrame:(CGRect)frame
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, kWidth*0.3, 50)];
    [nameLab setFont:[UIFont systemFontOfSize:15]];
    nameLab.text=name;
    [nameLab setTextColor:titleLabColor];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:nameLab];
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth*0.35, 0, kWidth*0.6, 40)];
    textField.placeholder=alert;
    textField.delegate=self;
    [textField setTextColor:detialLabColor];
    [textField setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:textField];
    UILabel *unitLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-60, 0, 50, 50)];
    [unitLab setFont:[UIFont systemFontOfSize:15]];
    [unitLab setTextAlignment:NSTextAlignmentRight];
    [unitLab setText:unit];
    [unitLab setTextColor:detialLabColor];
    [view addSubview:unitLab];
    UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 49.5, kWidth-20, 0.5)];
    [lineView setBackgroundColor:kLineColor];
    [view addSubview:lineView];
    [self.otherInfoView addSubview:view];
    return textField;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)selectInfo:(NSString *)select
{
    [self.ectiveBtn setTitle:select forState:UIControlStateNormal];
}
-(void)selectNum:(NSInteger)select
{
    switch (select) {
        case 0:
            self.ecttiv=6;
            break;
        case 1:
            self.ecttiv=7;
            break;
        case 2:
            self.ecttiv=8;
            break;
        case 3:
            self.ecttiv=9;
            break;
        case 4:
            self.ecttiv=10;
            break;
        case 5:
            self.ecttiv=2;
            break;
        case 6:
            self.ecttiv=3;
            break;
        case 7:
            self.ecttiv=4;
            break;
        case 8:
            self.ecttiv=5;
            break;
        case 9:
            self.ecttiv=10;
            break;
        default:
            self.ecttiv=0;
            break;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
