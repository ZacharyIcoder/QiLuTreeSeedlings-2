//
//  YLDEditDingDanViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDEditDingDanViewController.h"
#import "YLDPickLocationView.h"
#import "YLDFuBuTijiaoViewController.h"
#import "YLDPickTimeView.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "PickerShowView.h"
#import "ZIKCityModel.h"
#import "GetCityDao.h"
#import "BWTextView.h"
@interface YLDEditDingDanViewController ()<PickeShowDelegate,YLDPickLocationDelegate,YLDPickTimeDelegate>
@property (nonatomic,strong) UIScrollView *backScrollView;
@property (nonatomic,strong) NSArray *typeAry;
@property (nonatomic,strong) NSArray *piceAry;
@property (nonatomic,strong) NSArray *qualityAry;
@property (nonatomic,weak) UIButton *typeBtn;
@property (nonatomic,weak) UITextField *NameTextField;
@property (nonatomic,weak) UIButton *areaBtn;
@property (nonatomic,weak) UIButton *timeBtn;
@property (nonatomic,copy) NSString *AreaProvince;
@property (nonatomic,copy) NSString *AreaCity;
@property (nonatomic,weak) UIButton *priceBtn;
@property (nonatomic,weak) UIButton *qualityBtn;
@property (nonatomic,weak) UITextField *xiongjingField;
@property (nonatomic,weak) UITextField *dijingField;
@property (nonatomic,weak) UITextField *lianxirenField;
@property (nonatomic,weak) BWTextView *jianjieTextView;
@property (nonatomic,copy) NSString *typeStr;
//@property (nonatomic,copy) NSString *nameStr;
@property (nonatomic,copy) NSString *timeStr;
@property (nonatomic,copy) NSString *priceStr;
@property (nonatomic,copy) NSString *qualityStr;
@property (nonatomic,weak) UITextField *lianxifangshiField;
@end

@implementation YLDEditDingDanViewController
@synthesize typeAry;
-(id)init
{
    self=[super init];
    if (self) {
        [HTTPCLIENT huiquZhiliangYaoQiuBaoDingSuccess:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]==1) {
                NSDictionary *result=[responseObject objectForKey:@"result"];
                NSArray *bigDataAry=[result objectForKey:@"lxBeanList"];
                for (int i=0; i<bigDataAry.count; i++) {
                    NSDictionary *ddddis=bigDataAry[i];
                    NSString *lxName=ddddis[@"lxName"];
                    if ([lxName isEqualToString:@"订单类型"]) {
                        self.typeAry=ddddis[@"zidianList"];
                    }
                    if ([lxName isEqualToString:@"报价要求"]) {
                        self.piceAry=ddddis[@"zidianList"];
                    }
                    if ([lxName isEqualToString:@"质量要求"]) {
                        self.qualityAry=ddddis[@"zidianList"];
                    }
                }
            }else
            {
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle = @"订单编辑";
    UIScrollView *backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 65, kWidth, kHeight-65)];
    [backScrollView setBackgroundColor:BGColor];
    self.backScrollView=backScrollView;
    [self.view addSubview:backScrollView];
    CGRect tempFrame=CGRectMake(0, 5, kWidth, 50);
    UIButton *pickTypeBtn=[self danxuanViewWithName:@"订单类型" alortStr:@"请输入订单类型" andFrame:tempFrame];
    self.typeBtn=pickTypeBtn;
    [pickTypeBtn addTarget:self action:@selector(pickTypeBtnAcion:) forControlEvents:UIControlEventTouchUpInside];
    tempFrame.origin.y+=50;
    self.NameTextField=[self creatTextFieldWithName:@"项目名称" alortStr:@"请输入项目名称" andFrame:tempFrame];
    tempFrame.origin.y+=50;
    UIButton *areaBtn=[self danxuanViewWithName:@"用苗地址" alortStr:@"请选择用苗地" andFrame:tempFrame];
    self.areaBtn=areaBtn;
    [areaBtn addTarget:self action:@selector(areaBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    tempFrame.origin.y+=55;
    UIButton *timeBtn=[self danxuanViewWithName:@"截止日期" alortStr:@"请选择截止日期" andFrame:tempFrame];
    self.timeBtn=timeBtn;
    [timeBtn addTarget:self action:@selector(timeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    tempFrame.origin.y+=50;
    UIButton *priceBtn=[self danxuanViewWithName:@"报价要求" alortStr:@"请选择报价要求" andFrame:tempFrame];
    self.priceBtn=priceBtn;
    [priceBtn addTarget:self action:@selector(pickPiceBtnAcion:) forControlEvents:UIControlEventTouchUpInside];
    tempFrame.origin.y+=50;
    UIButton *qualityBtn=[self danxuanViewWithName:@"质量要求" alortStr:@"请选择质量要求" andFrame:tempFrame];
    self.qualityBtn = qualityBtn;
    [qualityBtn addTarget:self action:@selector(pickqualityBtnAcion:) forControlEvents:UIControlEventTouchUpInside];
    tempFrame.origin.y+=50;
    tempFrame.size.height=90;
    [self celiangyangqiuViewWith:tempFrame];
    tempFrame.origin.y+=95;
    tempFrame.size.height=50;
    self.lianxirenField=[self creatTextFieldWithName:@"联系人" alortStr:@"请输入联系人姓名" andFrame:tempFrame];
    tempFrame.origin.y+=50;
    self.lianxifangshiField=[self creatTextFieldWithName:@"联系方式" alortStr:@"请输入联系方式" andFrame:tempFrame];
    self.lianxifangshiField.keyboardType=UIKeyboardTypePhonePad;
    tempFrame.origin.y+=50;
    tempFrame.size.height=90;
    self.jianjieTextView=[self jianjieTextViewWithName:@"其他说明" WithAlort:@"" WithFrame:tempFrame];
//    UIButton *chongzhiBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(tempFrame)+5, kWidth/2-15, 40)];
//    [chongzhiBtn setBackgroundColor:NavYellowColor];
//    [chongzhiBtn setTitle:@"重置" forState:UIControlStateNormal];
//    [self.backScrollView addSubview:chongzhiBtn];
//    [chongzhiBtn addTarget:self action:@selector(chongzhiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *xiayibuBtn=[[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(tempFrame)+5, kWidth-60, 40)];
    [xiayibuBtn setBackgroundColor:NavColor];
    [xiayibuBtn setTitle:@"发布" forState:UIControlStateNormal];
    [xiayibuBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backScrollView addSubview:xiayibuBtn];
    [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(tempFrame)+60)];
    // Do any additional setup after loading the view.
}
-(void)chongzhiBtnAction:(UIButton *)sender
{
    self.typeStr=nil;
    [self.typeBtn setTitle:@"请选择订单类型" forState:UIControlStateNormal];
    self.NameTextField.text=nil;
    self.AreaProvince=nil;
    self.AreaCity=nil;
    [self.areaBtn setTitle:@"请选择用苗地" forState:UIControlStateNormal];
    self.timeStr=nil;
    [self.timeBtn setTitle:@"请选择截止日期" forState:UIControlStateNormal];
    self.priceStr=nil;
    [self.priceBtn setTitle:@"请选择报价要求" forState:UIControlStateNormal];
    self.qualityStr=nil;
    [self.qualityBtn setTitle:@"请选择质量要求" forState:UIControlStateNormal];
    self.xiongjingField.text=nil;
    self.dijingField.text=nil;
    self.lianxirenField.text=nil;
    self.lianxifangshiField.text=nil;
    self.jianjieTextView.text=nil;
    
}
-(void)nextBtnAction:(UIButton *)sender
{
    if (!self.typeStr) {
        [ToastView showTopToast:@"请选择订单类型"];
        return;
    }
    if (self.NameTextField.text.length==0) {
        [ToastView showTopToast:@"请输入项目名称"];
        return;
    }
    if (!self.AreaProvince) {
        [ToastView showTopToast:@"请选择用苗地"];
        return;
    }
    if (!self.timeStr) {
        [ToastView showTopToast:@"请选择截止日期"];
        return;
    }
    if (!self.priceStr) {
        [ToastView showTopToast:@"请选择报价要求"];
        return;
    }
    if (!self.qualityStr) {
        [ToastView showTopToast:@"请选择质量要求"];
        return;
    }
    if (self.xiongjingField.text.length==0) {
        [ToastView showTopToast:@"请完善胸径信息"];
        return;
    }
    if (self.dijingField.text.length==0) {
        [ToastView showTopToast:@"请完善地径信息"];
        return;
    }
    if (self.lianxirenField.text.length==0) {
        [ToastView showTopToast:@"请完善联系人姓名"];
        return;
    }
    if (self.lianxifangshiField.text.length==0) {
        [ToastView showTopToast:@"请完善联系方式"];
        return;
    }
}
-(void)areaBtnAction:(UIButton *)sender
{
    YLDPickLocationView *pickLocationV=[[YLDPickLocationView alloc]initWithFrame:[UIScreen mainScreen].bounds CityLeve:CityLeveShi];
    pickLocationV.delegate=self;
    [pickLocationV showPickView];
}
-(void)timeBtnAction:(UIButton *)sender
{
    YLDPickTimeView *pickTimeView=[[YLDPickTimeView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    pickTimeView.delegate=self;
    [pickTimeView showInView];
    
}
-(void)pickqualityBtnAcion:(UIButton *)sender
{
    NSMutableArray *newAry=[NSMutableArray array];
    for (int i=0; i<self.qualityAry.count; i++) {
        NSDictionary *dic=self.qualityAry[i];
        NSString *name=dic[@"name"];
        [newAry addObject:name];
    }
    PickerShowView *pickerSV=[[PickerShowView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    pickerSV.delegate=self;
    pickerSV.tag=113;
    [pickerSV resetPickerData:newAry];
    [pickerSV showInView];
}
-(void)pickTypeBtnAcion:(UIButton *)sender
{
    NSMutableArray *newAry=[NSMutableArray array];
    for (int i=0; i<self.typeAry.count; i++) {
        NSDictionary *dic=self.typeAry[i];
        NSString *name=dic[@"name"];
        [newAry addObject:name];
    }
    PickerShowView *pickerSV=[[PickerShowView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    pickerSV.delegate=self;
    pickerSV.tag=111;
    [pickerSV resetPickerData:newAry];
    [pickerSV showInView];
}
-(void)pickPiceBtnAcion:(UIButton *)sender
{
    NSMutableArray *newAry=[NSMutableArray array];
    for (int i=0; i<self.piceAry.count; i++) {
        NSDictionary *dic=self.piceAry[i];
        NSString *name=dic[@"name"];
        [newAry addObject:name];
    }
    PickerShowView *pickerSV=[[PickerShowView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    pickerSV.delegate=self;
    pickerSV.tag=112;
    [pickerSV resetPickerData:newAry];
    [pickerSV showInView];
}
-(void)timeDate:(NSDate *)selectDate andTimeStr:(NSString *)timeStr
{
    self.timeStr=[NSString stringWithFormat:@"%@ 23:59:59",timeStr];
    [self.timeBtn setTitle:timeStr forState:UIControlStateNormal];
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
    if (namestr.length>0) {
        [self.areaBtn setTitle:namestr forState:UIControlStateNormal];
        [self.areaBtn.titleLabel sizeToFit];
    }else{
        [self.areaBtn setTitle:@"请选择用苗地" forState:UIControlStateNormal];
        [self.areaBtn.titleLabel sizeToFit];
        
    }
}
-(void)selectNum:(NSInteger)select andselectInfo:(NSString *)selectStr PickerShowView:(PickerShowView *)pickerShowView
{
    if (pickerShowView.tag==111) {
        NSDictionary *dic=self.typeAry[select];
        self.typeStr=[dic objectForKey:@"uid"];
        [self.typeBtn setTitle:selectStr forState:UIControlStateNormal];
    }
    if (pickerShowView.tag==112) {
        NSDictionary *dic=self.piceAry[select];
        self.priceStr=[dic objectForKey:@"uid"];
        [self.priceBtn setTitle:selectStr forState:UIControlStateNormal];
    }
    if (pickerShowView.tag==113) {
        NSDictionary *dic=self.qualityAry[select];
        self.qualityStr=[dic objectForKey:@"uid"];
        [self.qualityBtn setTitle:selectStr forState:UIControlStateNormal];
    }
}

-(UIButton *)danxuanViewWithName:(NSString *)nameStr alortStr:(NSString *)alortStr andFrame:(CGRect)frame
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, frame.size.height)];
    [nameLab setText:nameStr];
    [view addSubview:nameLab];
    [nameLab setTextColor:detialLabColor];
    [nameLab setFont:[UIFont systemFontOfSize:14]];
    UIButton *pickBtn=[[UIButton alloc]initWithFrame:CGRectMake(110, 0, 160/320.f*kWidth, frame.size.height)];
    pickBtn.center=CGPointMake(frame.size.width/2+10,frame.size.height/2);
    [pickBtn setEnlargeEdgeWithTop:7 right:100 bottom:7 left:80];
    [pickBtn setTitle:alortStr forState:UIControlStateNormal];
    [pickBtn setTitleColor:titleLabColor forState:UIControlStateNormal];
    [pickBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    UIImageView *lineImagV=[[UIImageView alloc]initWithFrame:CGRectMake(10,frame.size.height-0.5, kWidth-20, 0.5)];
    [lineImagV setBackgroundColor:kLineColor];
    [view addSubview:lineImagV];
    UIImageView *imageVVV=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-42.5, 15, 15, 15)];
    [imageVVV setImage:[UIImage imageNamed:@"xiala2"]];
    [view addSubview:imageVVV];
    
    [view addSubview:pickBtn];
    [self.backScrollView addSubview:view];
    return pickBtn;
}
-(UITextField *)creatTextFieldWithName:(NSString *)nameStr alortStr:(NSString *)alortStr andFrame:(CGRect)frame
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, frame.size.height)];
    [nameLab setText:nameStr];
    [nameLab setTextColor:DarkTitleColor];
    [nameLab setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:nameLab];
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(110, 7, 160/320.f*kWidth, 30)];
    textField.placeholder=alortStr;
    [view addSubview:textField];
    UIImageView *lineImagV=[[UIImageView alloc]initWithFrame:CGRectMake(10,frame.size.height-0.5, kWidth-20, 0.5)];
    [lineImagV setBackgroundColor:kLineColor];
    
    [view addSubview:lineImagV];
    [self.backScrollView addSubview:view];
    return textField;
}
-(void)celiangyangqiuViewWith:(CGRect)frame
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(10, frame.size.height/2-15, 90, 30)];
    [nameLab setText:@"测量要求"];
    [nameLab setTextColor:DarkTitleColor];
    [nameLab setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:nameLab];
    [self.backScrollView addSubview:view];
    UIImageView *lineImagV=[[UIImageView alloc]initWithFrame:CGRectMake(110,frame.size.height/2-0.5, kWidth-120, 0.5)];
    [lineImagV setBackgroundColor:kLineColor];
    
    [view addSubview:lineImagV];
    UILabel *detiallab1=[[UILabel alloc]initWithFrame:CGRectMake(110, frame.size.height/4-15, 80, 30)];
    [detiallab1 setText:@"胸径离地面"];
    [detiallab1 setFont:[UIFont systemFontOfSize:14]];
    [detiallab1 setTextColor:detialLabColor];
    [view addSubview:detiallab1];
    UILabel *unitLab1=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-55, frame.size.height/4-15, 45, 30)];
    [unitLab1 setText:@"厘米处"];
    [unitLab1 setFont:[UIFont systemFontOfSize:14]];
    [unitLab1 setTextColor:detialLabColor];
    [view addSubview:unitLab1];
    [self.backScrollView addSubview:view];
    UITextField *xiongjingTextField=[[UITextField alloc]initWithFrame:CGRectMake(185, frame.size.height/4-15, kWidth-55-190, 30)];
    xiongjingTextField.borderStyle=UITextBorderStyleRoundedRect;
    self.xiongjingField=xiongjingTextField;
    xiongjingTextField.keyboardType=UIKeyboardTypeDecimalPad;
    [view addSubview:xiongjingTextField];
    
    
    
    UILabel *detiallab2=[[UILabel alloc]initWithFrame:CGRectMake(110, frame.size.height/4*3-15, 80, 30)];
    [detiallab2 setText:@"地径离地面"];
    [detiallab2 setFont:[UIFont systemFontOfSize:14]];
    [detiallab2 setTextColor:detialLabColor];
    [view addSubview:detiallab2];
    UILabel *unitLab2=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-55, frame.size.height/4*3-15, 45, 30)];
    [unitLab2 setText:@"厘米处"];
    [unitLab2 setFont:[UIFont systemFontOfSize:14]];
    [unitLab2 setTextColor:detialLabColor];
    [view addSubview:unitLab2];
    UITextField *dijingTextField=[[UITextField alloc]initWithFrame:CGRectMake(185, frame.size.height/4*3-15, kWidth-55-190, 30)];
    dijingTextField.borderStyle=UITextBorderStyleRoundedRect;
    dijingTextField.keyboardType=UIKeyboardTypeDecimalPad;
    self.dijingField=dijingTextField;
    [view addSubview:dijingTextField];
}
-(BWTextView*)jianjieTextViewWithName:(NSString *)name WithAlort:(NSString *)alort WithFrame:(CGRect)frame
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.backScrollView addSubview:view];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 50)];
    [nameLab setText:name];
    [nameLab setTextColor:DarkTitleColor];
    [nameLab setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:nameLab];
    
    BWTextView *TextView=[[BWTextView alloc]init];
    TextView.placeholder=@"请输入50字以内的说明...";
    TextView.frame=CGRectMake(110, 10, kWidth-120, frame.size.height-20);
    TextView.font=[UIFont systemFontOfSize:16];
    TextView.textColor=DarkTitleColor;
    [view addSubview:TextView];
    return TextView;
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