//
//  YLDBuyFabuViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/23.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDBuyFabuViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "PickerShowView.h"
#import "ZIKCityListViewController.h"
#import "GetCityDao.h"
#import "CityModel.h"
#import "ZIKCityModel.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
@interface YLDBuyFabuViewController ()<PickeShowDelegate,UITextFieldDelegate,ZIKCityListViewControllerDelegate>
@property (nonatomic,strong)UITextField *birefField;
@property (nonatomic,strong)UIButton *ectiveBtn;
@property (nonatomic)NSInteger ecttiv;
@property (nonatomic,strong)UIButton *areaBtn;
@property (nonatomic,strong)UITextField *countTextField;
@property (nonatomic,strong)UITextField *priceTextField;
@property (nonatomic,strong)PickerShowView *ecttivePickerView;
@property (nonatomic,strong)UIView *otherInfoView;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *productUid;
@property (nonatomic,strong)NSArray *guigeAry;
@property (nonatomic, strong) NSMutableArray *citys;
@property (nonatomic, strong) NSString       *citysStr;//地址的code string “，，”
@property (nonatomic) SelectStyle selectStyle;
@property (nonatomic,strong) NSDictionary *baseDic;
@end

@implementation YLDBuyFabuViewController
-(id)initWithUid:(NSString *)uid Withtitle:(NSString *)title WithName:(NSString *)name WithproductUid:(NSString *)productUid WithGuigeAry:(NSArray *)guigeAry andBaseDic:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.uid=uid;
        self.titleStr=title;
        self.name=name;
        self.productUid=productUid;
        self.guigeAry=guigeAry;
        self.baseDic=dic;
    }
    return self;
}
-(id)initWithUid:(NSString *)uid Withtitle:(NSString *)title WithName:(NSString *)name WithproductUid:(NSString *)productUid WithGuigeAry:(NSArray *)guigeAry
{
    self=[super init];
    if (self) {
        self.uid=uid;
        self.titleStr=title;
        self.name=name;
        self.productUid=productUid;
        self.guigeAry=guigeAry;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.ecttiv=0;
    self.vcTitle = @"求购发布";
        UIView *otherView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 250)];
        self.otherInfoView=otherView;
    
        CGRect  tempFrame=CGRectMake(0, 0, kWidth, 50);
    UIView *areaView=[[UIView alloc]initWithFrame:tempFrame];
    [areaView setBackgroundColor:[UIColor whiteColor]];
    UIImageView *lineImagV2=[[UIImageView alloc]initWithFrame:CGRectMake(15, 49.5, kWidth-30, 0.5)];
    [lineImagV2 setBackgroundColor:kLineColor];
    [areaView addSubview:lineImagV2];
    UILabel *areaLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 70, 50)];
    areaLab.text=@"苗源地";
    [areaLab setTextColor:titleLabColor];
    [areaLab setFont:[UIFont systemFontOfSize:15]];
    [areaView addSubview:areaLab];
    UIButton *areaBtn=[[UIButton alloc]initWithFrame:CGRectMake(100, 0, kWidth-150, 50)];
    [areaBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [areaBtn setTitle:@"请选择苗源地" forState:UIControlStateNormal];
    [areaBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
    [areaView addSubview:areaBtn];
    self.areaBtn=areaBtn;
    [areaBtn addTarget:self action:@selector(areBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [areaBtn setEnlargeEdgeWithTop:0 right:100 bottom:0 left:10];
    UIImageView  *moreAreaImageV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-25, 21, 12, 12)];
    [moreAreaImageV setImage:[UIImage imageNamed:@"moreRow"]];
    [areaView addSubview:moreAreaImageV];
    [otherView addSubview:areaView];
    tempFrame.origin.y+=50;
    UITextField *priceTextField=[self mackViewWtihName:@"价格" alert:@"请输入价格" unit:@"元" withFrame:tempFrame];
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
    [ecttiveBtn setTitle:@"请选择有效期" forState:UIControlStateNormal];
    [ecttiveBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
    self.ectiveBtn=ecttiveBtn;
    [ecttiveBtn addTarget:self action:@selector(ecttiveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [ecttiveBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    tempFrame.origin.y+=50;

    UITextField *countTextField=[self mackViewWtihName:@"数量" alert:@"请输入数量" unit:@"棵" withFrame:tempFrame];
        self.countTextField=countTextField;
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:countTextField];
        countTextField.keyboardType=UIKeyboardTypeNumberPad;
        tempFrame.origin.y+=50;
    
        UITextField *birefField=[self mackViewWtihName:@"备注" alert:@"请输入备注信息.." unit:@"" withFrame:tempFrame];
        self.birefField=birefField;
        birefField.tag=1111;
        
    if (self.baseDic) {
        self.countTextField.text=[NSString stringWithFormat:@"%@",[self.baseDic objectForKey:@"count"]];
        self.ecttiv=[[self.baseDic objectForKey:@"effective"] integerValue];
        NSString *priceStr=[self.baseDic objectForKey:@"price"];
        if ([priceStr isEqualToString:@"面议"]) {
            
        }else{
            self.priceTextField.text=priceStr;
        }
        
         NSString *remark=[self.baseDic objectForKey:@"remark"];
        if (remark.length>0) {
            self.birefField.text=remark;
        }
        self.citysStr=[self.baseDic objectForKey:@"usedArea"];
        NSArray *cityCodeAry=[self.citysStr componentsSeparatedByString:@","];
        NSMutableString *citysNameStr=[NSMutableString string];
        GetCityDao *citydao=[GetCityDao new];
        [citydao openDataBase];
        for (int i=0; i<cityCodeAry.count; i++) {
            NSString *str1=[citydao getCityNameByCityUid:cityCodeAry[i]];
            if (i==0) {
                [citysNameStr appendString:str1];
            }else{
                [citysNameStr appendFormat:@",%@",str1];
            }
        }
        [self.areaBtn setTitle:citysNameStr forState:UIControlStateNormal];
        [citydao closeDataBase];
        self.ecttiv=[[self.baseDic objectForKey:@"effective"] integerValue];
        NSString *effectiveStr;
        switch (self.ecttiv) {
            case 1:
                effectiveStr=@"长期";
                break;
            case 2:
                effectiveStr=@"一月";
                break;
            case 3:
                effectiveStr=@"三月";
                break;
            case 4:
                effectiveStr=@"半年";
                break;
            case 5:
                effectiveStr=@"一年";
                break;
            case 6:
                effectiveStr=@"一天";
                break;
            case 7:
                effectiveStr=@"三天";
                break;
            case 8:
                effectiveStr=@"五天";
                break;
            case 9:
                effectiveStr=@"一周";
                break;
            case 10:
                effectiveStr=@"半个月";
                break;
            default:
                effectiveStr=@"请选择";
                break;
        }
        [self.ectiveBtn setTitle:effectiveStr forState:UIControlStateNormal];
    }
        [self.view addSubview:otherView];
    UIButton *tijiaoBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, kHeight-70, kWidth-80, 50)];
    
    [tijiaoBtn setBackgroundColor:NavColor];
    [tijiaoBtn setTitle:@"提交" forState:UIControlStateNormal];
    [tijiaoBtn addTarget:self action:@selector(tijiaoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tijiaoBtn];
        //[self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(otherView.frame))];
    // Do any additional setup after loading the view.
}
-(void)tijiaoBtnAction:(UIButton *)sender
{
    
        if (self.countTextField.text.length==0) {
            [ToastView showTopToast:@"请填写求购数量"];
            return;
        }
        if ([self isPureInt:self.countTextField.text]==NO) {
            [ToastView showTopToast:@"数量的格式输入有误"];
            return;
        }
    if (self.ecttiv<=0) {
        [ToastView showTopToast:@"请选择有效期"];
        return;
    }
    if (self.priceTextField.text.length>0) {
            if ([self isPureFloat:self.priceTextField.text]==NO) {
                [ToastView showTopToast:@"上车价的格式输入有误"];
                return;
            }
        }
    if (self.citysStr.length<=0) {
        [ToastView showTopToast:@"请选择苗源地"];
        return;
    }
    ShowActionV();
    [HTTPCLIENT fabuBuyMessageWithUid:self.uid Withtitle:self.titleStr WithName:self.name WithProductUid:self.productUid WithCount:self.countTextField.text WithPrice:self.priceTextField.text WithEffectiveTime:[NSString stringWithFormat:@"%ld",(long)self.ecttiv] WithRemark:self.birefField.text WithusedArea:self.citysStr WithAry:self.guigeAry Success:^(id responseObject) {
        RemoveActionV();
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"发布成功"];
    UIViewController *controller = self.navigationController.viewControllers[self.navigationController.viewControllers.count-3];
            [self.navigationController popToViewController:controller animated:YES];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        RemoveActionV();
    }];
}
-(void)areBtnAction:(UIButton *)sender
{
    ZIKCityListViewController *cityVC = [[ZIKCityListViewController alloc] init];
    cityVC.selectStyle = SelectStyleMultiSelect;
    self.selectStyle = SelectStyleMultiSelect;
    cityVC.delegate = self;
    [self.navigationController pushViewController:cityVC animated:YES];
    cityVC.citys = self.citys;
}
-(void)ecttiveBtnAction
{
    [self.countTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [self.birefField     resignFirstResponder];
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
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth*0.35, 0, kWidth*0.6, 50)];
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
- (void)textFieldChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    int kssss=10;
    if (textField.tag==111) {
        kssss=20;
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
                [ToastView showToast:[NSString stringWithFormat:@"最多%d个字符",kssss] withOriginY:250 withSuperView:self.view];
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
            [ToastView showToast:[NSString stringWithFormat:@"最多%d个字符",kssss] withOriginY:250 withSuperView:self.view];
            textField.text = [toBeString substringToIndex:kssss];
            return;
        }
    }
}
#pragma mark - 确定返回后，传回地址执行协议
- (void)selectCitysInfo:(NSString *)citysStr {
    _citysStr = citysStr;
    GetCityDao *citydao = [GetCityDao new];
    [citydao openDataBase];
    __block NSString *str = @"";
    NSArray *cityArray = [_citysStr componentsSeparatedByString:@","];
    [cityArray enumerateObjectsUsingBlock:^(NSString *cityCode, NSUInteger idx, BOOL * _Nonnull stop) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[citydao getCityNameByCityUid:cityCode]]];
    }];
    [citydao closeDataBase];
    if ([str containsString:@","] && ![str isEqualToString:@""]) {
        str =  [str substringToIndex:str.length-1];
    }

    [self.areaBtn setTitle:str forState:UIControlStateNormal];
}
- (NSArray *)citys {
    //if (_citys == nil) {
    _citys = [[NSMutableArray alloc] init];
    GetCityDao *dao = [[GetCityDao alloc] init];
    [dao openDataBase];
    NSArray *allProvince = [dao getCityByLeve:@"1"];
    [allProvince enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        ZIKCityModel *cityModel = [ZIKCityModel initCityModelWithDic:dic];
        //             cityModel.province.citys = [dao getCityByLeve:@"2" andParent_code:cityModel.province.code];
        NSMutableArray *cityMArr = [dao getCityByLeve:@"2" andParent_code:cityModel.province.code];
        
        
        NSMutableDictionary *dicionary = [NSMutableDictionary dictionary];
        [dicionary setObject:cityModel.province.provinceID forKey:@"id"];
        [dicionary setObject:cityModel.province.code forKey:@"code"];
        [dicionary setObject:cityModel.province.parent_code forKey:@"parent_code"];
        [dicionary setObject:@"全省" forKey:@"name"];
        [dicionary setObject:cityModel.province.level forKey:@"level"];
        [cityMArr insertObject:dicionary atIndex:0];
        cityModel.province.citys = cityMArr;
        
        [_citys addObject:cityModel];
        
    }];
    //self.dataAry = [CityModel creatCityAryByAry:allTown];
    [dao closeDataBase];
    if (![[self.areaBtn currentTitle] isEqualToString:@"请选择苗源地"]) {
        NSArray *cityArray = [_citysStr componentsSeparatedByString:@","];
        __block NSInteger numcount = 0;
        [_citys enumerateObjectsUsingBlock:^(ZIKCityModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            [model.province.citys enumerateObjectsUsingBlock:^(NSMutableDictionary *cityDic, NSUInteger idx, BOOL * _Nonnull stop) {
                [cityArray enumerateObjectsUsingBlock:^(NSString *cityCode, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([cityDic[@"code"] isEqualToString:cityCode]) {
                        cityDic[@"select"] = @"1";
                        if (++numcount == cityArray.count) {
                            *stop = YES;
                        }
                    }
                }];
            }];
        }];
    }
    
    //}
    return _citys;
}
//1. 整形判断

- (BOOL)isPureInt:(NSString *)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
    
}




//2.浮点形判断：

- (BOOL)isPureFloat:(NSString *)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return [scan scanFloat:&val] && [scan isAtEnd];
    
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
