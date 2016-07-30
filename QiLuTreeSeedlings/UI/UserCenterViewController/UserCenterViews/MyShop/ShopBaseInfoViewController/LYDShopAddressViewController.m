//
//  LYDShopAddressViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/27.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "LYDShopAddressViewController.h"
#import "YLDPickLocationView.h"
#import "HttpClient.h"
#import "UIDefines.h"
@interface LYDShopAddressViewController ()<YLDPickLocationDelegate>
@property (nonatomic,copy) NSString *shopProvince;
@property (nonatomic,copy) NSString *shopCity;
@property (nonatomic,copy) NSString *shopCounty;
@property (nonatomic,copy) NSString *areaAddress;
@property (nonatomic,copy) NSString *shopAddress;
@property (nonatomic,weak) YLDPickLocationView*pickLocationV;
@end

@implementation LYDShopAddressViewController
-(id)initWithshopProvince:(NSString *)shopProvince withshopCity:(NSString *)shopCity withshopCounty:(NSString *)shopCounty withshopAddress:(NSString *)shopAddress WithareaAddress:(NSString *)areaAddress
{
    self=[super init];
    if (self) {
        self.shopProvince=shopProvince;
        self.shopCity=shopCity;
        self.shopCounty=shopCounty;
        self.shopAddress=shopAddress;
        self.areaAddress=areaAddress;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"所在地";
    if (self.areaAddress.length>0) {
 
        [self.areaBtn setTitle:self.areaAddress forState:UIControlStateNormal];
        [self.areaBtn setTitleColor:DarkTitleColor forState:UIControlStateNormal];
    }
    self.addressTextField.textColor=DarkTitleColor;
    self.addressTextField.text=self.shopAddress;
    [self.areaBtn addTarget:self action:@selector(areaBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sureBtn addTarget:self action:@selector(sureBtnAcion:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}
-(void)sureBtnAcion:(UIButton *)sender
{
    if (self.shopCounty.length<=0) {
        [ToastView showTopToast:@"地区需精确到县"];
        return;
    }
    
    [HTTPCLIENT UpDataMyShopAddressWithshopProvince:self.shopProvince WithshopCity:self.shopCity WithshopCounty:self.shopCounty WithshopAddress:self.addressTextField.text Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"修改成功，即将返回"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)areaBtnAction:(UIButton *)sender
{
    if (!self.pickLocationV) {
        YLDPickLocationView *pickerView=[[YLDPickLocationView alloc]initWithFrame:[UIScreen mainScreen].bounds CityLeve:CityLeveXian];
        self.pickLocationV=pickerView;
        pickerView.delegate=self;
        [pickerView showPickView];
            [self.addressTextField resignFirstResponder];
       
    }
}
-(void)selectSheng:(CityModel *)sheng shi:(CityModel *)shi xian:(CityModel *)xian zhen:(CityModel *)zhen
{
    NSMutableString *namestr=[NSMutableString new];
    if (sheng.code) {
        [namestr appendString:sheng.cityName];
        self.shopProvince=sheng.code;
    }else
    {
        self.shopProvince=nil;
    }
    
    if (shi.code) {
        [namestr appendString:shi.cityName];
        self.shopCity=shi.code;
    }else
    {
        self.shopCity=nil;
        
    }
    if (xian.code) {
        [namestr appendString:xian.cityName];
        self.shopCounty=xian.code;
    }else
    {
        self.shopCounty=nil;
    }
    if (namestr.length>0) {
        [self.areaBtn setTitle:namestr forState:UIControlStateNormal];
        [self.areaBtn setTitleColor:DarkTitleColor forState:UIControlStateNormal];
    }
//    else{
//        [self.areaBtn setTitle:@"请选择地区" forState:UIControlStateNormal];
//        [self.areaBtn.titleLabel sizeToFit];
//        
//    }
    
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
