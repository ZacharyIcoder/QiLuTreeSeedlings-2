//
//  buyFabuTijiaoViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/18.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "buyFabuTijiaoViewController.h"
#import "UIDefines.h"
#import "PickerShowView.h"
#import "PickerLocation.h"
@interface buyFabuTijiaoViewController ()<PickeShowDelegate>
@property (nonatomic,strong)NSArray *screeingAry;
@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic,strong)NSString *proname;
@property (nonatomic,strong)NSString *prouid;
@property (nonatomic,strong)UITextField *countTextField;
@property (nonatomic,strong)UITextField *priceTextField;
@property (nonatomic,strong)PickerShowView *ecttivePickerView;
@end

@implementation buyFabuTijiaoViewController
-(id)initWithAry:(NSArray *)ary andTitle:(NSString *)title andProname:(NSString *)proname andProUid:(NSString *)proUid
{
    self=[super init];
    if (self) {
        self.screeingAry=ary;
        self.titleStr=title;
        self.proname=proname;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     UIView *navView =[self makeNavView];
    [self.view addSubview:navView];
    CGRect tempFrame=CGRectMake(0, 64, kWidth, 50);
    UITextField *countTextField=[self mackViewWtihName:@"数量" alert:@"请输入数量" unit:@"棵" withFrame:tempFrame];
    self.countTextField=countTextField;
    tempFrame.origin.y+=50;
    UITextField *priceTextField=[self mackViewWtihName:@"价格" alert:@"请输入单价" unit:@"元" withFrame:tempFrame];
    self.priceTextField=priceTextField;
    tempFrame.origin.y+=50;
    UIView *ecttiveView=[[UIView alloc]initWithFrame:tempFrame];
    [ecttiveView setBackgroundColor:[UIColor whiteColor]];
    UILabel *ecttNameLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 70, 50)];
    [ecttiveView addSubview:ecttNameLab];
    [self.view addSubview:ecttiveView];
    [ecttNameLab setText:@"有效期"];
    UIButton *ecttiveBtn=[[UIButton alloc]initWithFrame:CGRectMake(120, 0, kWidth-200, 50)];
    [ecttiveView addSubview:ecttiveBtn];
    [ecttiveBtn setTitle:@"不限" forState:UIControlStateNormal];
    [ecttiveBtn addTarget:self action:@selector(ecttiveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
-(void)ecttiveBtnAction
{
    if (!self.ecttivePickerView) {
        self.ecttivePickerView=[[PickerShowView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.ecttivePickerView resetPickerData:@[@"长期",@"一个月",@"三个月",@"半年",@"一年"]];
        self.ecttivePickerView.delegate=self;
    }
    [self.ecttivePickerView showInView];
}
-(UITextField *)mackViewWtihName:(NSString *)name alert:(NSString *)alert unit:(NSString *)unit withFrame:(CGRect)frame
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, kWidth*0.3, 44)];
    nameLab.text=name;
    [view setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:nameLab];
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth*0.35, 0, kWidth*0.6, 44)];
    textField.placeholder=alert;
    [view addSubview:textField];
    UILabel *unitLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-60, 0, 50, 44)];
    [unitLab setTextAlignment:NSTextAlignmentRight];
    [unitLab setText:unit];
    [view addSubview:unitLab];
    UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 43.5, kWidth-10, 0.5)];
    [lineView setBackgroundColor:kLineColor];
    [view addSubview:lineView];
    //[self.backScrollView addSubview:view];
    [self.view addSubview:view];
    return textField;
}
-(UIView *)makeNavView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, 64)];
    [view setBackgroundColor:NavColor];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-80,26, 160, 30)];
    [titleLab setTextColor:[UIColor whiteColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setText:@"发布求购信息"];
    [titleLab setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:titleLab];
    return view;
}
-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)selectNum:(NSInteger)select
{
    NSLog(@"%ld",select+1);
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
