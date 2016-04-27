//
//  CompanyViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/21.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "CompanyViewController.h"
#import "BusinessMesageModel.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "GetCityDao.h"
#import "PickerLocation.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
@interface CompanyViewController ()<PickerLocationDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UIScrollView *backScrollView;
@property (nonatomic,strong) UITextField *companyNameField;
@property (nonatomic,strong) UITextField *companyAddressField;
@property (nonatomic,copy) NSString *AreaProvince;
@property (nonatomic,copy) NSString *AreaCity;
@property (nonatomic,copy) NSString *AreaTown;
@property (nonatomic,copy) NSString *AreaCounty;
@property (nonatomic,strong) UITextField *legalPersonField;
@property (nonatomic,strong) UITextField *phoneField;
@property (nonatomic,strong) UITextField *zipcodeField;
@property (nonatomic,strong) UITextField *briefField;
@property (nonatomic,strong) PickerLocation *pickCityView;
@property (nonatomic,strong) UIButton *areaBtn;
@property (nonatomic,weak) UITextField *nowTextField;
@property (nonatomic,strong) UIButton *upDataBtn;
@property (nonatomic,strong) UIButton *editingBtn;
@property (nonatomic,strong) UILabel *warnLab;
@end

@implementation CompanyViewController
@synthesize backScrollView,companyNameField,companyAddressField,AreaCity,AreaCounty,AreaProvince,AreaTown,legalPersonField,phoneField,zipcodeField,briefField,pickCityView,upDataBtn,editingBtn;
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    pickCityView=[[PickerLocation alloc]initWithFrame:[UIScreen mainScreen].bounds];
    pickCityView.locationDelegate=self;
    self.backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, kWidth, kHeight-64-44)];
    [self.backScrollView setBackgroundColor:BGColor];
    [self.view setBackgroundColor:BGColor];
    [self.view setBackgroundColor:BGColor];
    [self.view addSubview:self.backScrollView];
    UIView *navView=[self makeNavView];
    [self.view addSubview:navView];
    
    CGRect tempFrame=CGRectMake(0, 6, kWidth, 44);
    companyNameField=[self mackViewWtihName:@"企业名称" alert:@"请输入企业名称" unit:@"" withFrame:tempFrame];
    companyNameField.delegate=self;
    tempFrame.origin.y+=44;
    companyAddressField=[self mackViewWtihName:@"企业地址" alert:@"请输入企业地址" unit:@"" withFrame:tempFrame];
    companyAddressField.delegate=self;
    tempFrame.origin.y+=44;
    UIView *cityView=[[UIView alloc]initWithFrame:tempFrame];
    UILabel *cityNameLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, kWidth*0.3, 44)];
    [cityView addSubview:cityNameLab];
    cityNameLab.text=@"地区";
    [cityNameLab setTextColor:titleLabColor];
    [cityNameLab setFont:[UIFont systemFontOfSize:14]];
    UIButton *cityBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*0.25, 0, kWidth*0.6, 44)];
    [cityBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [cityBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
    [cityBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cityBtn setTitle:@"请选择公司所在城市" forState:UIControlStateNormal];
    [cityView addSubview:cityBtn];
    [cityBtn addTarget:self action:@selector(cityBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.areaBtn=cityBtn;
    [cityView setBackgroundColor:[UIColor whiteColor]];
    UIImageView *lineImageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 43.5, kWidth-10, 0.5)];
    [lineImageV setBackgroundColor:kLineColor];
    [cityView addSubview:lineImageV];
    [self.backScrollView addSubview:cityView];
    tempFrame.origin.y+=44;
    legalPersonField=[self mackViewWtihName:@"法人代表" alert:@"请输入公司法人代表" unit:@"" withFrame:tempFrame];
    legalPersonField.delegate=self;
     tempFrame.origin.y+=44;
    phoneField=[self mackViewWtihName:@"电话" alert:@"请输入有效的电话" unit:@"" withFrame:tempFrame];
    phoneField.delegate=self;
    phoneField.keyboardType=UIKeyboardTypePhonePad;
    tempFrame.origin.y+=44;
    zipcodeField=[self mackViewWtihName:@"邮编" alert:@"请输入邮编号码" unit:@"" withFrame:tempFrame];
    zipcodeField.delegate=self;
    zipcodeField.keyboardType=UIKeyboardTypePhonePad;
    tempFrame.origin.y+=44;
    briefField=[self mackViewWtihName:@"简介" alert:@"请输入简介内容" unit:@"" withFrame:tempFrame];
    briefField.delegate=self;
    tempFrame.origin.y+=50;
    
    UILabel *warnLab=[[UILabel alloc]initWithFrame:CGRectMake(10,tempFrame.origin.y , kWidth-20, 35)];
    [warnLab setFont:[UIFont systemFontOfSize:12]];
    [warnLab setTextColor:titleLabColor];
    warnLab.numberOfLines=2;
    [warnLab setText:@"    如果您的企业信息填写有误，请点击有误项进行二次编辑。"];
    [self.backScrollView addSubview:warnLab];
    self.warnLab=warnLab;
    [self.backScrollView setContentSize:CGSizeMake(0, tempFrame.origin.y+tempFrame.size.height)];
    UITapGestureRecognizer *tapGest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScrollViewRgestFirst)];
    [self.backScrollView addGestureRecognizer:tapGest];
    
    UIButton *nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, kHeight-64, kWidth-80, 44)];
    [nextBtn setBackgroundColor:NavColor];
    [nextBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    self.upDataBtn = nextBtn;
    [nextBtn addTarget:self action:@selector(updaBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    // self.editingBtn.hidden=YES;
    if ([APPDELEGATE isNeedCompany]==NO) {
        [self beginEditing];
        warnLab.hidden=YES;
    }
    else{
         [self beginEditing];
        warnLab.hidden=NO;
        //[self endEditing];
        self.companyNameField.text=APPDELEGATE.companyModel.companyName;
        self.companyAddressField.text=APPDELEGATE.companyModel.companyAddress;
        self.phoneField.text=APPDELEGATE.companyModel.phone;
        self.legalPersonField.text=APPDELEGATE.companyModel.legalPerson;
        self.briefField.text=APPDELEGATE.companyModel.brief;
        NSMutableString *areaStr=[[NSMutableString alloc]init];
        GetCityDao *citydao=[GetCityDao new];
        [citydao openDataBase];
        NSString *str1=[citydao getCityNameByCityUid:APPDELEGATE.companyModel.companyAreaProvince];
        [areaStr appendFormat:@"%@",str1];
        NSString *str2=[citydao getCityNameByCityUid:APPDELEGATE.companyModel.companyAreaCity];
        if (str2) {
            [areaStr appendFormat:@"%@",str2];
        }
        NSString *str3=[citydao getCityNameByCityUid:APPDELEGATE.companyModel.companyAreaCounty];
        if (str3) {
            [areaStr appendFormat:@"%@",str3];
        }
        [citydao closeDataBase];
        self.AreaProvince=APPDELEGATE.companyModel.companyAreaProvince;
        self.AreaCity=APPDELEGATE.companyModel.companyAreaCity;
        self.AreaCounty=APPDELEGATE.companyModel.companyAreaCounty;
        self.AreaTown=APPDELEGATE.companyModel.companyAreaTown;
        [self.areaBtn setTitle:areaStr forState:UIControlStateNormal];
        self.zipcodeField.text=APPDELEGATE.companyModel.zipcode;
    }
}
-(void)beginEditing
{
    self.companyNameField.enabled=YES;
    self.companyAddressField.enabled=YES;
    self.phoneField.enabled=YES;
    self.legalPersonField.enabled=YES;
    self.briefField.enabled=YES;
    self.areaBtn.enabled=YES;
    self.zipcodeField.enabled=YES;
    self.upDataBtn.hidden=NO;
}
-(void)endEditing
{
    self.companyNameField.enabled=NO;
    self.companyAddressField.enabled=NO;
    self.phoneField.enabled=NO;
    self.legalPersonField.enabled=NO;
    self.briefField.enabled=NO;
    self.areaBtn.enabled=NO;
    self.zipcodeField.enabled=NO;
      self.upDataBtn.hidden=YES;
}
-(void)updaBtnAction:(UIButton *)sender
{
    NSString *namestr=self.companyNameField.text;
    if (namestr.length==0) {
        [ToastView showTopToast:@"请输入公司名称"];
        return;
    }
    NSString *addressStr=self.companyAddressField.text;
    if (addressStr.length==0) {
        [ToastView showTopToast:@"请输入公司地址"];
        return;
    }
    if (self.AreaProvince.length==0) {
        [ToastView showTopToast:@"请选择公司所在地"];
        return;
    }
    if (self.legalPersonField.text.length==0) {
        [ToastView showTopToast:@"请输入公司法人"];
        return;
    }
    if (self.legalPersonField.text.length==0) {
        [ToastView showTopToast:@"请输入公司法人"];
        return;
    }
    if (self.phoneField.text.length==0) {
        [ToastView showTopToast:@"请输入联系电话"];
        return;
    }
    if(self.zipcodeField.text.length==0)
    {
        [ToastView showTopToast:@"请输入邮编"];
        return;
    }
    if(self.briefField.text.length==0)
    {
        [ToastView showTopToast:@"请填写公司简介"];
        return;
    }
    __weak __typeof(self) blockSelf = self;
    [HTTPCLIENT saveCompanyInfoWithUid:APPDELEGATE.companyModel.uid     WithCompanyName:companyNameField.text WithCompanyAddress:companyAddressField.text WithcompanyAreaProvince:AreaProvince WithcompanyAreaCity:AreaCity WithcompanyAreaCounty:AreaCounty WithcompanyAreaTown:AreaTown WithlegalPerson:legalPersonField.text Withphone:phoneField.text Withzipcode:zipcodeField.text Withbrief:briefField.text Success:^(id responseObject) {
      //  NSLog(@"%@",responseObject);
        if([[responseObject objectForKey:@"success"] integerValue])
        {
            self.warnLab.hidden=NO;
            //[blockSelf endEditing];
            [APPDELEGATE reloadCompanyInfo];
        }
        else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            
        }
    } failure:^(NSError *error) {
       // NSLog(@"%@",error.userInfo);
        
    }];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.nowTextField=textField;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{

}
-(void)cityBtnAction:(UIButton *)sender
{
    [pickCityView showInView];
    if (self.nowTextField) {
        [self.nowTextField resignFirstResponder];
    }
}
-(void)tapScrollViewRgestFirst
{
    [self.nowTextField resignFirstResponder];
    
}


- (void)selectedLocationInfo:(Province *)location
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
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(17, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
   [backBtn setEnlargeEdgeWithTop:15 right:60 bottom:10 left:10];
    [view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-80,26, 160, 30)];
    [titleLab setTextColor:[UIColor whiteColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setText:@"企业信息"];
    [titleLab setFont:[UIFont systemFontOfSize:NavTitleSize]];
        [view addSubview:titleLab];
//    UIButton *editingBtnz=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-60, 26, 50, 30)];
//    [editingBtnz setTitle:@"编辑" forState:UIControlStateNormal];
//    [editingBtnz setTitle:@"取消" forState:UIControlStateSelected];
//    [editingBtnz addTarget:self action:@selector(editingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    editingBtn=editingBtnz;
//    [view addSubview:editingBtnz];
    return view;
}
-(void)editingBtnAction:(UIButton *)sender
{
    if (sender.selected==NO) {
        sender.selected=YES;
        [self beginEditing];
        
        return;
    }
    if (sender.selected==YES) {
        sender.selected=NO;
        [self endEditing];
        
        return;
    }
}

-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nowTextField resignFirstResponder];
//    if (backScrollView.frame.size.height==kHeight-64-44) {
//        return;
//    }else
//    {
//        CGRect frame=backScrollView.frame;
//        frame.size.height=kHeight-64-44;
//        backScrollView.frame=frame;
//    }

}
-(UITextField *)mackViewWtihName:(NSString *)name alert:(NSString *)alert unit:(NSString *)unit withFrame:(CGRect)frame
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, kWidth*0.3, 44)];
    nameLab.text=name;
    [nameLab setTextColor:titleLabColor];
    [nameLab setFont:[UIFont systemFontOfSize:14]];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:nameLab];
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth*0.35, 0, kWidth*0.4, 44)];
    [textField setFont:[UIFont systemFontOfSize:14]];
    textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    textField.placeholder=alert;
    [view addSubview:textField];
    [textField setTextColor:detialLabColor];
    UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 43.5, kWidth-20, 0.5)];
    [lineView setBackgroundColor:kLineColor];
    [view addSubview:lineView];
    [self.backScrollView addSubview:view];
    [view setBackgroundColor:[UIColor whiteColor]];
    return textField;
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
