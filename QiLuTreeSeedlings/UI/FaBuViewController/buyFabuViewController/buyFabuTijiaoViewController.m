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
#import "ToastView.h"
#import "HttpClient.h"
@interface buyFabuTijiaoViewController ()<PickeShowDelegate,PickerLocationDelegate,UITextFieldDelegate>
@property (nonatomic,strong)NSArray *screeingAry;
@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic,strong)NSString *proname;
@property (nonatomic,strong)NSString *prouid;
@property (nonatomic,strong)UITextField *countTextField;
@property (nonatomic,strong)UITextField *priceTextField;
@property (nonatomic,strong)PickerShowView *ecttivePickerView;
@property (nonatomic,strong)PickerLocation *areaPickerView;
@property (nonatomic)NSInteger ecttiv;
@property (nonatomic,strong)UIButton *areaBtn;
@property (nonatomic,copy)NSString *AreaProvince;
@property (nonatomic,copy)NSString *AreaCity;
@property (nonatomic,copy)NSString *AreaCounty;
@property (nonatomic,strong)UITextField *birefField;
@property (nonatomic,strong)UITextField *nowTextField;
@end

@implementation buyFabuTijiaoViewController
-(id)initWithAry:(NSArray *)ary andTitle:(NSString *)title andProname:(NSString *)proname andProUid:(NSString *)proUid
{
    self=[super init];
    if (self) {
        self.screeingAry=ary;
        self.titleStr=title;
        self.proname=proname;
        self.ecttiv=1;
        self.prouid=proUid;
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
    UIImageView *lineImagV=[[UIImageView alloc]initWithFrame:CGRectMake(15, 49.5, kWidth-30, 0.5)];
    [lineImagV setBackgroundColor:kLineColor];
    [ecttiveView addSubview:lineImagV];
    [self.view addSubview:ecttiveView];
    [ecttNameLab setText:@"有效期"];
    UIButton *ecttiveBtn=[[UIButton alloc]initWithFrame:CGRectMake(120, 0, kWidth-200, 50)];
    [ecttiveView addSubview:ecttiveBtn];
    [ecttiveBtn setTitle:@"不限" forState:UIControlStateNormal];
    [ecttiveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ecttiveBtn addTarget:self action:@selector(ecttiveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    tempFrame.origin.y+=50;
    UIView *areaView=[[UIView alloc]initWithFrame:tempFrame];
    [areaView setBackgroundColor:[UIColor whiteColor]];
    UIImageView *lineImagV2=[[UIImageView alloc]initWithFrame:CGRectMake(15, 49.5, kWidth-30, 0.5)];
    [lineImagV2 setBackgroundColor:kLineColor];
    [areaView addSubview:lineImagV2];
    UILabel *areaLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 70, 50)];
    areaLab.text=@"用苗地";
    [areaView addSubview:areaLab];
    UIButton *areaBtn=[[UIButton alloc]initWithFrame:CGRectMake(100, 0, kWidth-150, 50)];
    [areaBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [areaBtn setTitle:@"请选择用苗地" forState:UIControlStateNormal];
    [areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [areaView addSubview:areaBtn];
    self.areaBtn=areaBtn;
    [areaBtn addTarget:self action:@selector(areBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:areaView];
    tempFrame.origin.y+=50;
    
    UITextField *birefField=[self mackViewWtihName:@"备注" alert:@"请输入备注信息" unit:@"" withFrame:tempFrame];
    self.birefField=birefField;
    birefField.tag=1111;
    
    UIButton *tijiaoBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, kHeight-60, kWidth-80,44)];
    [tijiaoBtn setBackgroundColor:NavColor];
    [tijiaoBtn addTarget:self action:@selector(tijiaoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [tijiaoBtn setTitle:@"提交" forState:UIControlStateNormal];

    [self.view addSubview:tijiaoBtn];
}
-(void)tijiaoBtnAction:(UIButton *)sender
{
    NSString *countStr=self.countTextField.text;
    NSString *priceStr=self.priceTextField.text;
    NSString *birefStr=self.birefField.text;
    if (countStr.length==0) {
        [ToastView showTopToast:@"请填写求购数量"];
        return;
    }
    if (self.AreaProvince.length==0) {
        [ToastView showTopToast:@"请选择用苗城市"];
        return;
    }
    [HTTPCLIENT fabuBuyMessageWithUid:@"" Withtitle:self.titleStr WithName:self.proname WithProductUid:self.prouid WithCount:countStr WithPrice:priceStr WithEffectiveTime:[NSString stringWithFormat:@"%ld",self.ecttiv] WithRemark:birefStr WithUsedProvince:self.AreaProvince WithUsedCity:self.AreaCity WithUsedCounty:self.AreaCounty WithAry:self.screeingAry Success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"发布成功，即将返回首页"];
            [self performSelector:@selector(backRootView) withObject:nil afterDelay:1];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)backRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.nowTextField=textField;
    if (kHeight<=480) {
        if (textField.tag==1111) {
            CGRect frame=textField.frame;
            frame.origin.y-=50;
            textField.frame=frame;
        }
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.nowTextField=nil;
    if (kHeight<=480) {
        if (textField.tag==1111) {
            CGRect frame=textField.frame;
            frame.origin.y+=50;
            textField.frame=frame;
        }
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.nowTextField) {
        [self.nowTextField resignFirstResponder];
    }
}
-(void)areBtnAction:(UIButton *)sender
{
    if (!self.areaPickerView) {
        self.areaPickerView=[[PickerLocation alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.areaPickerView.locationDelegate=self;
    }
    [self.areaPickerView showInView];
}
- (void)selectedLocationInfo:(Province *)location
{
    NSMutableString *namestr=[NSMutableString new];
    if (location.provinceID) {
        [namestr appendString:location.provinceName];
        self.AreaProvince=location.provinceID;
    }
    
    if (location.selectedCity.cityID) {
        [namestr appendString:location.selectedCity.cityName];
        self.AreaCity=location.selectedCity.cityID;
    }
    if (location.selectedCity.selectedTowns.TownID) {
        [namestr appendString:location.selectedCity.selectedTowns.TownName];
        self.AreaCounty=location.selectedCity.selectedTowns.TownID;
    }
    if (namestr.length>0) {
        [self.areaBtn setTitle:namestr forState:UIControlStateNormal];
        [self.areaBtn.titleLabel sizeToFit];
    }
    

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
    textField.delegate=self;
    [view addSubview:textField];
    UILabel *unitLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-60, 0, 50, 44)];
    [unitLab setTextAlignment:NSTextAlignmentRight];
    [unitLab setText:unit];
    [view addSubview:unitLab];
    UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 43.5, kWidth-10, 0.5)];
    [lineView setBackgroundColor:kLineColor];
    [view addSubview:lineView];
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
    self.ecttiv=select+1;
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
