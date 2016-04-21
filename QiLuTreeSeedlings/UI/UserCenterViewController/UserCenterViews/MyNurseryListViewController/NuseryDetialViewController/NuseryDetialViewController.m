//
//  NuseryDetialViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/26.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "NuseryDetialViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "PickerLocation.h"
#import "NurseryModel.h"
#import "GetCityDao.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
@interface NuseryDetialViewController ()<PickerLocationDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UIScrollView *backScrollView;
@property (nonatomic,strong) UITextField *nuseryNameField;
@property (nonatomic,strong) UITextField *nuseryAddressField;
@property (nonatomic,strong) UITextField *changePersonField;
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) UITextField *bierfTextField;
@property (nonatomic,strong) UIButton *areaBtn;
@property (nonatomic,strong) NurseryModel *model;
@property (nonatomic,strong) PickerLocation *pickerLocation;
@property (nonatomic,weak) UITextField * nowTextField;
@property (nonatomic,weak) UIButton *upDataBtn;
@property (nonatomic,copy) NSString *AreaProvince;
@property (nonatomic,copy) NSString *AreaCity;
@property (nonatomic,copy) NSString *AreaCounty;
@end

@implementation NuseryDetialViewController
@synthesize model;
-(id)initWuid:(NSString *)uid
{
    self=[super init];

    if (self) {
        model.uid=uid;
        [HTTPCLIENT nurseryDetialWithUid:uid Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSDictionary *dic=[responseObject objectForKey:@"result"];
                model=[NurseryModel creaNursweryModelByDic:dic];
                [self setMessage];
            }else
            {
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];

    }
    return self;
}
@synthesize nuseryNameField,nuseryAddressField,changePersonField,phoneTextField,bierfTextField,areaBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *navView=[self makeNavView];
    [self.view addSubview:navView];
    self.backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-64)];
    [self.backScrollView setBackgroundColor:BGColor];
    [self.view addSubview:self.backScrollView];
    [self.view setBackgroundColor:BGColor];
    // Do any additional setup after loading the view.
    CGRect tempFrame=CGRectMake(0, 0, kWidth, 50);
    nuseryNameField = [self makeViewWtihName:@"苗圃基地" alert:@"请输入基地名称" unit:@"" withFrame:tempFrame];
    tempFrame.origin.y+=50;
    
    areaBtn=[self makeViewWtihName:@"地区" alert:@"请选择地区" withFrame:tempFrame];
    [areaBtn addTarget:self action:@selector(pickLocationAction) forControlEvents:UIControlEventTouchUpInside];
    tempFrame.origin.y+=50;
    nuseryAddressField=[self makeViewWtihName:@"详细地址" alert:@"请输入详细地址" unit:@"" withFrame:tempFrame];
    
    tempFrame.origin.y+=50;
    changePersonField = [self makeViewWtihName:@"负责人" alert:@"请输入负责人姓名" unit:@"" withFrame:tempFrame];
    tempFrame.origin.y+=50;
    phoneTextField = [self makeViewWtihName:@"电话" alert:@"请输入电话" unit:@"" withFrame:tempFrame];
    tempFrame.origin.y+=50;
    bierfTextField=[self makeViewWtihName:@"简介" alert:@"请填写简介" unit:@"" withFrame:tempFrame];
    [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(tempFrame))];
    
    UIButton *nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, kHeight-64, kWidth-80, 44)];
    [nextBtn setBackgroundColor:NavColor];
    [nextBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    self.upDataBtn = nextBtn;
    [nextBtn addTarget:self action:@selector(updaBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
   
}

-(void)updaBtnAction:(UIButton *)sender
{   NSString *nuserName=self.nuseryNameField.text;
    NSString *nuserAddress=self.nuseryAddressField.text;
    NSString *changePerson=self.changePersonField.text;
    NSString *phone=self.phoneTextField.text;
    NSString *birefStr=self.bierfTextField.text;
    if (nuserName.length==0) {
        [ToastView showTopToast:@"请输入苗圃名称"];
        return;
    }
    if (changePerson.length==0) {
        [ToastView showTopToast:@"请输入负责人"];
        return;
    }
    if (phone.length==0) {
        [ToastView showTopToast:@"请输入联系方式"];
        return;
    }
    if (nuserAddress.length==0) {
        [ToastView showTopToast:@"请输入苗圃地址"];
        return;
    }
    if (birefStr.length==0) {
        [ToastView showTopToast:@"请输入苗圃简介"];
        return;
    }
    if (self.AreaProvince.length==0) {
        [ToastView showTopToast:@"请选择苗圃所在地"];
        return;
    }
    [HTTPCLIENT saveNuresryWithUid:model.uid WithNurseryName:nuserName WithnurseryAreaProvince:self.AreaProvince WithnurseryAreaCity:self.AreaCity WithnurseryAreaCounty:self.AreaCounty WithnurseryAreaTown:@"" WithnurseryAddress:nuserAddress WithchargelPerson:changePerson WithPhone:phone Withbrief:birefStr Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"添加成功，即将返回"];
            [self performSelector:@selector(backBtnAction:) withObject:nil afterDelay:0.3];
        }else
        {
             [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)setMessage
{
    self.nuseryNameField.text=model.nurseryName;
    self.nuseryAddressField.text=model.nurseryAddress;
    self.phoneTextField.text=model.phone;
    self.bierfTextField.text=model.brief;
    self.changePersonField.text=model.chargelPerson;
    self.AreaProvince =model.nurseryAreaProvince;
    self.AreaCity=model.nurseryAreaCity;
    self.AreaCounty=model.nurseryAreaCounty;
    NSMutableString *areaStr=[[NSMutableString alloc]init];
    GetCityDao *citydao=[GetCityDao new];
    [citydao openDataBase];
    NSString *str1=[citydao getCityNameByCityUid:model.nurseryAreaProvince];
    [areaStr appendFormat:@"%@",str1];
    NSString *str2=[citydao getCityNameByCityUid:model.nurseryAreaCity];
    if (str2) {
        [areaStr appendFormat:@"%@",str2];
    }
    NSString *str3=[citydao getCityNameByCityUid:model.nurseryAreaCounty];
    if (str3) {
        [areaStr appendFormat:@"%@",str3];
    }
    [citydao closeDataBase];
    [self.areaBtn setTitle:areaStr forState:UIControlStateNormal];
}
-(void)pickLocationAction
{
    if (!self.pickerLocation) {
        self.pickerLocation=[[PickerLocation alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.pickerLocation.locationDelegate=self;
    }
    if (self.nowTextField) {
        [self.nowTextField resignFirstResponder];
    }
    [self.pickerLocation showInView];
}
-(void)selectedLocationInfo:(Province *)location
{
    NSMutableString *namestr=[NSMutableString new];
    if (location.code) {
        [namestr appendString:location.provinceName];
        self.AreaProvince=location.code;
    }else
    {
        self.AreaProvince=nil;
    }
    
    if (location.selectedCity.code) {
        [namestr appendString:location.selectedCity.cityName];
        self.AreaCity=location.selectedCity.code;
    }else
    {
        self.AreaCity=nil;
        
    }
    if (location.selectedCity.selectedTowns.code) {
        [namestr appendString:location.selectedCity.selectedTowns.TownName];
        self.AreaCounty=location.selectedCity.selectedTowns.code;
    }else
    {
        self.AreaCounty=nil;
    }
    if (namestr.length>0) {
        [self.areaBtn setTitle:namestr forState:UIControlStateNormal];
        [self.areaBtn.titleLabel sizeToFit];
    }else{
        [self.areaBtn setTitle:@"不限" forState:UIControlStateNormal];
        [self.areaBtn.titleLabel sizeToFit];
        
    }
}
-(UIView *)makeNavView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, 64)];
    [view setBackgroundColor:NavColor];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
   [backBtn setEnlargeEdgeWithTop:10 right:25 bottom:0 left:3];
    [view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-80,26, 160, 30)];
    [titleLab setTextColor:[UIColor whiteColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setText:@"我的苗圃"];
    [titleLab setFont:[UIFont systemFontOfSize:21]];
    [view addSubview:titleLab];
//    UIButton *collectionBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-40, 26, 30, 30)];
//    // self.collectionBtn = collectionBtn;
//    [collectionBtn setImage:[UIImage imageNamed:@"myNuserAdd"] forState:UIControlStateNormal];
//    [collectionBtn addTarget:self action:@selector(tianjiaBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:collectionBtn];
    
    return view;
}
-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITextField *)makeViewWtihName:(NSString *)name alert:(NSString *)alert unit:(NSString *)unit withFrame:(CGRect)frame
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, kWidth*0.3, 44)];
    nameLab.text=name;
    [nameLab setFont:[UIFont systemFontOfSize:14]];
    [view setBackgroundColor:[UIColor whiteColor]];
    [nameLab setTextColor:titleLabColor];
    [view addSubview:nameLab];
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth*0.35, 0, kWidth*0.4, 44)];
    [textField setFont:[UIFont systemFontOfSize:14]];
    textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    textField.placeholder=alert;
    textField.delegate=self;
    [textField setTextColor:detialLabColor];
    [view addSubview:textField];
    UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 43.5, kWidth-20, 0.5)];
    [lineView setBackgroundColor:kLineColor];
    [view addSubview:lineView];
    [self.backScrollView addSubview:view];
    [view setBackgroundColor:[UIColor whiteColor]];
    return textField;
}

-(UIButton *)makeViewWtihName:(NSString *)name alert:(NSString *)alert  withFrame:(CGRect)frame
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, kWidth*0.3, 44)];
    nameLab.text=name;
    [nameLab setTextColor:titleLabColor];
    [nameLab setFont:[UIFont systemFontOfSize:14]];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:nameLab];
    UIButton *Btn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*0.35, 0, kWidth*0.4, 44)];
    [Btn setTitle:alert forState:UIControlStateNormal];
    [Btn setTitleColor:detialLabColor forState:UIControlStateNormal];
    [Btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:Btn];
    UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 43.5, kWidth-20, 0.5)];
    [lineView setBackgroundColor:kLineColor];
    [view addSubview:lineView];
    [self.backScrollView addSubview:view];
    [view setBackgroundColor:[UIColor whiteColor]];
    return Btn;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.nowTextField=textField;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
