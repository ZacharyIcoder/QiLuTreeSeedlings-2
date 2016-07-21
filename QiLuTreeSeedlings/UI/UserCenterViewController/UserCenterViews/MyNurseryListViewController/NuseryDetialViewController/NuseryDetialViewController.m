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
#import "YLDPickLocationView.h"
#import "NurseryModel.h"
#import "GetCityDao.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
#import "NSString+Phone.h"
#import "ZIKHintTableViewCell.h"
#import "BWTextView.h"
@interface NuseryDetialViewController ()<YLDPickLocationDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UIScrollView *backScrollView;
@property (nonatomic,strong) UITextField *nuseryNameField;
@property (nonatomic,strong) UITextField *nuseryAddressField;
@property (nonatomic,strong) UITextField *changePersonField;
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) BWTextView *bierfTextView;
@property (nonatomic,strong) UIButton *areaBtn;
@property (nonatomic,strong) NurseryModel *model;
@property (nonatomic,weak) UITextField * nowTextField;
@property (nonatomic,weak) UIButton *upDataBtn;
@property (nonatomic,copy) NSString *AreaProvince;
@property (nonatomic,copy) NSString *AreaCity;
@property (nonatomic,copy) NSString *AreaCounty;
@property (nonatomic,copy) NSString *AreaTown;
@property (nonatomic,strong) CityModel *xiancityModel;
@end

@implementation NuseryDetialViewController
@synthesize model;
-(id)initWuid:(NSString *)uid
{
    self=[super init];

    if (self) {
        model.uid=uid;
        ShowActionV();
        [HTTPCLIENT nurseryDetialWithUid:uid Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSDictionary *dic=[responseObject objectForKey:@"result"];
                model=[NurseryModel creaNursweryModelByDic:dic];
                [self setMessage];
            }else
            {
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
            RemoveActionV();
        } failure:^(NSError *error) {
            RemoveActionV();
        }];

    }
    return self;
}
@synthesize nuseryNameField,nuseryAddressField,changePersonField,phoneTextField,bierfTextView,areaBtn;
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
    tempFrame.size.height=100;
    bierfTextView=[self jianjieTextViewWithName:@"简介" WithAlort:@"请输入简介" WithFrame: tempFrame];
    tempFrame.origin.y+=110;
    tempFrame.size.height=30;
    ZIKHintTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"ZIKHintTableViewCell" owner:self options:nil] lastObject];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.hintStr=@"注：输入框后有＊的为必填项";
    cell.frame=tempFrame;
    [self.backScrollView addSubview:cell];
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
    NSString *birefStr=self.bierfTextView.text;
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
    if(phone.length!=11)
    {
        [ToastView showTopToast:@"手机号必须是11位"];
        return;
    }
    if (![phone checkPhoneNumInput]) {
        [ToastView showTopToast:@"手机号格式不正确"];
        return;
    }

    if (nuserAddress.length==0) {
        [ToastView showTopToast:@"请输入苗圃地址"];
        return;
    }
    if (self.xiancityModel) {
        if ([self.xiancityModel.level integerValue]==CityLeveZhen) {
            self.AreaTown=self.xiancityModel.code;
        }
    }
    if (self.AreaTown.length==0) {
      [ToastView showTopToast:@"苗圃地址需精确到镇"];
        return;
    }
    ShowActionV();
    [HTTPCLIENT saveNuresryWithUid:model.uid WithNurseryName:nuserName WithnurseryAreaProvince:self.AreaProvince WithnurseryAreaCity:self.AreaCity WithnurseryAreaCounty:self.AreaCounty WithnurseryAreaTown:self.AreaTown WithnurseryAddress:nuserAddress WithchargelPerson:changePerson WithPhone:phone Withbrief:birefStr Success:^(id responseObject) {
        RemoveActionV();
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"添加成功，即将返回"];
            [self performSelector:@selector(backBtnAction:) withObject:nil afterDelay:0.3];
        }else
        {
             [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        RemoveActionV();
    }];
}
-(BWTextView*)jianjieTextViewWithName:(NSString *)name WithAlort:(NSString *)alort WithFrame:(CGRect)frame
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.backScrollView addSubview:view];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 90, 50)];
    [nameLab setText:name];
    [nameLab setTextColor:DarkTitleColor];
    [nameLab setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:nameLab];
    
    BWTextView *TextView=[[BWTextView alloc]init];
    TextView.placeholder=alort;
    TextView.tag=100;
    [TextView setTextColor:detialLabColor];
    [TextView setFont:[UIFont systemFontOfSize:14]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:TextView];
    TextView.frame=CGRectMake(kWidth*0.35, 10, kWidth*0.6, frame.size.height-20);
    [view addSubview:TextView];
    return TextView;
}
- (void)textViewChanged:(NSNotification *)obj {
    BWTextView *textField = (BWTextView *)obj.object;
    NSInteger kssss=10;
    if (textField.tag>0) {
        kssss=textField.tag;
    }
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kssss) {
                // NSLog(@"最多%d个字符!!!",kMaxLength);
                [ToastView showToast:[NSString stringWithFormat:@"最多%ld个字符",(long)kssss] withOriginY:250 withSuperView:self.view];
                //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%d个字符",kMaxLength] view:nil];
                textField.text = [toBeString substringToIndex:kssss];
                return;
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kssss) {
            //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%ld个字符",(long)kMaxLength] view:nil];
            //NSLog(@"最多%d个字符!!!",kMaxLength);
            [ToastView showToast:[NSString stringWithFormat:@"最多%ld个字符",(long)kssss] withOriginY:250 withSuperView:self.view];
            textField.text = [toBeString substringToIndex:kssss];
            return;
        }
    }
}
-(void)setMessage
{
    self.nuseryNameField.text=model.nurseryName;
    self.nuseryAddressField.text=model.nurseryAddress;
    self.phoneTextField.text=model.phone;
    self.bierfTextView.text=model.brief;
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
    NSString *str4=[citydao getCityNameByCityUid:model.nurseryAreaTown];
    if (str4) {
        [areaStr appendFormat:@"%@",str4];
    }
    [citydao closeDataBase];
    [self.areaBtn setTitle:areaStr forState:UIControlStateNormal];
}
-(void)pickLocationAction
{
   YLDPickLocationView *pickerLocation=[[YLDPickLocationView alloc]initWithFrame:[UIScreen mainScreen].bounds CityLeve:CityLeveZhen];
        pickerLocation.delegate=self;
    if (self.nowTextField) {
        [self.nowTextField resignFirstResponder];
    }
    [pickerLocation showPickView];
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
    if (xian.code) {
        [namestr appendString:xian.cityName];
        self.AreaCounty=xian.code;
        self.xiancityModel=xian;
    }else
    {
        self.xiancityModel=nil;
        self.AreaCounty=nil;
    }
    
    if (zhen.code) {
        [namestr appendString:zhen.cityName];
        self.AreaTown=zhen.code;
    }else
    {
        self.AreaTown=nil;
    }
    if (namestr.length>0) {
        [self.areaBtn setTitle:namestr forState:UIControlStateNormal];
        [self.areaBtn.titleLabel sizeToFit];
    }else{
        [self.areaBtn setTitle:@"请选择地区" forState:UIControlStateNormal];
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
     NSString *nameStr=@"新增苗圃信息";
    if (model.uid) {
        nameStr=@"修改苗圃信息";
    }else
    {
        nameStr=@"新增苗圃信息";
    }
    [titleLab setText:nameStr];
    [titleLab setFont:[UIFont systemFontOfSize:NavTitleSize]];
    [view addSubview:titleLab];
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
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth*0.35, 0, kWidth*0.53, 44)];
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
    if ([name isEqualToString:@"苗圃基地"]||[name isEqualToString:@"详细地址"]||[name isEqualToString:@"地区"]||[name isEqualToString:@"负责人"]||[name isEqualToString:@"电话"]) {
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-40, 0,10 , frame.size.height)];
        [lab setTextColor:yellowButtonColor];
        [lab setText:@"*"];
        [view addSubview:lab];
    }

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
    if([name isEqualToString:@"地区"])
    {
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-40, 0,10 , frame.size.height)];
        [lab setTextColor:yellowButtonColor];
        [lab setText:@"*"];
        [view addSubview:lab];
        [view setBackgroundColor:[UIColor whiteColor]];
    }
  
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
