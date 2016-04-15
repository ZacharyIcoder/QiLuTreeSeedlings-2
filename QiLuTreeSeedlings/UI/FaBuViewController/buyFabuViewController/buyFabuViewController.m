//
//  buyFabuViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/18.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "buyFabuViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "PickerShowView.h"
#import "PickerLocation.h"
#import "TreeSpecificationsModel.h"
#import "FabutiaojiaCell.h"
#import "ZIKSideView.h"
@interface buyFabuViewController ()<PickeShowDelegate,PickerLocationDelegate,UITextFieldDelegate,ZIKSelectViewUidDelegate>
@property (nonatomic,strong)UITextField *titleTextField;
@property (nonatomic,strong)UITextField *nameTextField;
@property (nonatomic,strong)UIButton *nameBtn;
@property (nonatomic,strong)NSString *productName;
@property (nonatomic,strong)NSArray *dataAry;
@property (nonatomic,strong)NSString *productUid;
@property (nonatomic,strong)UIScrollView *backScrollView;
@property (nonatomic,strong)UITextField *nowTextField;
@property (nonatomic,strong)NSMutableArray *cellAry;
@property (nonatomic,strong)BuyDetialModel *model;
@property (nonatomic,strong)NSDictionary *baseMessageDic;
@property (nonatomic) BOOL isCanPublish;
@property (nonatomic,strong) UIView *otherInfoView;
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
@property (nonatomic,strong)UIButton *ectiveBtn;
@property (nonatomic, strong) ZIKSideView      *sideView;
@property (nonatomic, strong) NSMutableArray   *productTypeDataMArray;
@end

@implementation buyFabuViewController
@synthesize cellAry;
-(id)initWithModel:(BuyDetialModel *)model
{
    self=[super init];
    if (self) {
        self.model=model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.ecttiv=0;
    self.productTypeDataMArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    self.cellAry=[NSMutableArray array];
    UIView *navView=[self makeNavView];
    [self.view addSubview:navView];
    [self.view setBackgroundColor:BGColor];
    self.backScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-64)];
    [self.view addSubview:self.backScrollView];
    [self.backScrollView setBackgroundColor:BGColor];
    CGRect tempFrame=CGRectMake(0,0, kWidth, 44);
    UIView *titleView=[[UIView alloc]initWithFrame:tempFrame];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, kWidth*0.25, 44)];
    [titleLab setTextColor:titleLabColor];
    [titleLab setFont:[UIFont systemFontOfSize:15]];
    [titleView addSubview:titleLab];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    titleLab.text=@"标题";
    UITextField *titleTextField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth*0.27, 0, kWidth*0.6, 44)];
    titleTextField.placeholder=@"请输入标题";
    [titleTextField setTextColor:detialLabColor];
    [titleTextField setFont:[UIFont systemFontOfSize:15]];
    self.titleTextField=titleTextField;
    UIImageView *titleLineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 43.5, kWidth-10, 0.5)];
    [titleLineView setBackgroundColor:kLineColor];
    [titleView addSubview:titleLineView];
    [titleView addSubview:titleTextField];
    titleTextField.delegate=self;
      titleTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.backScrollView addSubview:titleView];
    tempFrame.origin.y+=44.5;
    UIView *nameView=[[UIView alloc]initWithFrame:tempFrame];
    [nameView setBackgroundColor:[UIColor whiteColor]];
    [self.backScrollView addSubview:nameView];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(15/320.f*kWidth, 0, kWidth*0.25, 44)];
    nameLab.text=@"苗木名称";
    [nameLab setFont:[UIFont systemFontOfSize:15]];
    [nameLab setTextColor:titleLabColor];
    [nameView addSubview:nameLab];
    UITextField *nameTextField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth*0.30, 0, kWidth*0.6, 44)];
    nameTextField.placeholder=@"请输入苗木名称";
    nameTextField.textColor=NavColor;
    [nameTextField setFont:[UIFont systemFontOfSize:15]];
    nameTextField.delegate=self;
  [nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.nameTextField=nameTextField;
    [nameView addSubview:nameTextField];
    UIButton *nameBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-70, 9, 50, 25)];
    [nameBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
   [nameView addSubview:nameBtn];
    [nameBtn addTarget:self action:@selector(nameBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [nameBtn setImage:[UIImage imageNamed:@"treeNameSure"] forState:UIControlStateNormal];
    [nameBtn setImage:[UIImage imageNamed:@"treeNameSure2"] forState:UIControlStateSelected];
    UIImageView *nameLineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 43.5, kWidth-10, 0.5)];
    [nameLineView setBackgroundColor:kLineColor];
    [nameView addSubview:nameLineView];
    self.nameBtn=nameBtn;
    UIView *otherView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nameView.frame)+5, kWidth, 250)];
    self.otherInfoView=otherView;
    [self.backScrollView addSubview:otherView];
     tempFrame=CGRectMake(0, 0, kWidth, 50);
    UITextField *countTextField=[self mackViewWtihName:@"数量" alert:@"请输入数量" unit:@"棵" withFrame:tempFrame];
    self.countTextField=countTextField;
    countTextField.keyboardType=UIKeyboardTypeNumberPad;
    tempFrame.origin.y+=50;
    UITextField *priceTextField=[self mackViewWtihName:@"价格" alert:@"请输入单价" unit:@"元" withFrame:tempFrame];
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
    [self.otherInfoView addSubview:ecttiveView];
    [ecttNameLab setText:@"有效期"];
    [ecttNameLab setTextColor:titleLabColor];
    [ecttNameLab setFont:[UIFont systemFontOfSize:15]];
    UIButton *ecttiveBtn=[[UIButton alloc]initWithFrame:CGRectMake(120, 0, kWidth-200, 50)];
    [ecttiveView addSubview:ecttiveBtn];
    [ecttiveBtn setTitle:@"不限" forState:UIControlStateNormal];
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
    [self.otherInfoView addSubview:areaView];
    tempFrame.origin.y+=50;
    
    UITextField *birefField=[self mackViewWtihName:@"备注" alert:@"请输入备注信息" unit:@"" withFrame:tempFrame];
    self.birefField=birefField;
    birefField.tag=1111;
    
    
    [self.backScrollView addSubview:otherView];
    [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(otherView.frame))];
    UIButton *nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, kHeight-60, kWidth-80, 44)];
    [self.view addSubview:nextBtn];
    [nextBtn setBackgroundColor:NavColor];
    [nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tapgest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidingKey)];
    [self.backScrollView addGestureRecognizer:tapgest];
    
    if(self.model)
    {
        [self editingMyBuy];
    }
}
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        if (self.nameBtn.selected==YES) {
            self.nameBtn.selected=NO;
        }
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
        [self.areaBtn setTitle:@"请选择" forState:UIControlStateNormal];
        [self.areaBtn.titleLabel sizeToFit];
        
    }
}
-(void)ecttiveBtnAction
{
    if (!self.ecttivePickerView) {
        self.ecttivePickerView=[[PickerShowView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.ecttivePickerView resetPickerData:@[@"一天",@"三天",@"五天",@"一周",@"半个月",@"一个月",@"三个月",@"半年",@"一年",@"永久"]];
        self.ecttivePickerView.delegate=self;
    }
    [self.ecttivePickerView showInView];
}
-(UITextField *)mackViewWtihName:(NSString *)name alert:(NSString *)alert unit:(NSString *)unit withFrame:(CGRect)frame
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, kWidth*0.3, 44)];
    [nameLab setFont:[UIFont systemFontOfSize:15]];
    nameLab.text=name;
    [nameLab setTextColor:titleLabColor];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:nameLab];
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth*0.35, 0, kWidth*0.6, 44)];
    textField.placeholder=alert;
    textField.delegate=self;
    [textField setTextColor:detialLabColor];
    [textField setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:textField];
    UILabel *unitLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-60, 0, 50, 44)];
    [unitLab setFont:[UIFont systemFontOfSize:15]];
    [unitLab setTextAlignment:NSTextAlignmentRight];
    [unitLab setText:unit];
    [unitLab setTextColor:detialLabColor];
    [view addSubview:unitLab];
    UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 43.5, kWidth-20, 0.5)];
    [lineView setBackgroundColor:kLineColor];
    [view addSubview:lineView];
    [self.otherInfoView addSubview:view];
    return textField;
}

-(void)editingMyBuy
{
    self.titleTextField.text=self.model.title;
    self.nameTextField.text=self.model.productName;
    self.nameBtn.selected=YES;
    self.productName=self.nameTextField.text;
    [self getEditingMessage];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.nowTextField=textField;
}
-(void)nextBtnAction:(UIButton *)sender
{
    if (self.titleTextField.text.length==0) {
        [ToastView showTopToast:@"标题不能为空"];
        return;
    }
    if (self.nameBtn.selected==NO) {
        [ToastView showTopToast:@"请先确认苗木名称"];
        return;
    }
    if(!self.productUid)
    {
        [ToastView showTopToast:@"该苗木不存在"];
        return;
    }
    if (!self.productName) {
        [ToastView showTopToast:@"苗木名称不正确"];
        return;
    }
    if (self.ecttiv==0) {
        [ToastView showTopToast:@"请选择有效期"];
        return;
    }
    NSMutableArray *screenTijiaoAry=[NSMutableArray array];
    for (int i=0; i<cellAry.count; i++) {
        TreeSpecificationsModel *model=cellAry[i];
        if (model.anwser.length>0) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:model.field,@"field",
                               model.anwser,@"anwser"
                               , nil];
            [screenTijiaoAry addObject:dic];
        }
    }
    
    if(screenTijiaoAry.count==0)
    {
        [ToastView showTopToast:@"请填入至少一种规格"];
        return;
    }
    NSString *countStr=self.countTextField.text;
    NSString *priceStr=self.priceTextField.text;
    NSString *birefStr=self.birefField.text;
    if (countStr.length==0) {
        [ToastView showTopToast:@"请填写求购数量"];
        return;
    }
    if ([self isPureInt:countStr]==NO) {
        [ToastView showTopToast:@"请检查输入的数量格式是否正确"];
        return;
    }
    if (priceStr.length>0) {
        if ([self isPureFloat:priceStr]==NO) {
            [ToastView showTopToast:@"请检查输入的价格格式是否正确"];
            return;
        }
    }
   
    if (self.AreaProvince.length==0) {
        [ToastView showTopToast:@"请选择用苗城市"];
        return;
    }
    [HTTPCLIENT fabuBuyMessageWithUid:self.model.uid Withtitle:self.titleTextField.text WithName:self.productName WithProductUid:self.productUid WithCount:countStr WithPrice:priceStr WithEffectiveTime:[NSString stringWithFormat:@"%ld",(long)self.ecttiv] WithRemark:birefStr WithUsedProvince:self.AreaProvince WithUsedCity:self.AreaCity WithUsedCounty:self.AreaCounty WithAry:screenTijiaoAry Success:^(id responseObject) {
        //        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"提交成功，即将返回"];
            [self performSelector:@selector(backRootView) withObject:nil afterDelay:1];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
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
-(void)backRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    if(self.model)
    {
        [titleLab setText:@"求购编辑"];
    }else
    {
        [titleLab setText:@"求购发布"];
    }
    
    [titleLab setFont:[UIFont systemFontOfSize:20]];
    [view addSubview:titleLab];
    return view;
}
-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getTreeSHUXINGWithBtn:(UIButton *)sender
{
    ;
    [HTTPCLIENT getMmAttributeWith:self.nameTextField.text WithType:@"2" Success:^(id responseObject) {
        
        if (![[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showToast:[responseObject objectForKey:@"msg"]
                     withOriginY:66.0f
                   withSuperView:APPDELEGATE.window];
            if ([responseObject[@"msg"] isEqualToString:@"该苗木不存在"]) {
                [self requestProductType];
            }
        }else
        {
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            self.dataAry=[dic objectForKey:@"list"];
            sender.selected=YES;
            self.productUid=[dic objectForKey:@"productUid"];
            
            [self creatScreeningCells];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)getEditingMessage
{
    
        [HTTPCLIENT myBuyEditingWithUid:self.model.uid Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSDictionary *dic=[[responseObject objectForKey:@"result"] objectForKey:@"ProductSpec"];
                self.productUid=[dic objectForKey:@"productUid"];
                self.productName=[dic objectForKey:@"productName"];
                self.baseMessageDic=[[responseObject objectForKey:@"result"] objectForKey:@"baseMsg"];
                NSArray *ary=[dic objectForKey:@"bean"];
                self.dataAry=ary;
                [self creatSCreeningCellsWithAnswerWithAry:ary];
            }else
            {
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
   

}
-(void)nameBtnAction:(UIButton *)sender
{
    if (sender.selected) {
        return;
    }
    if (self.nameTextField.text.length==0) {
        [ToastView showToast:@"请输入苗木名称"
                 withOriginY:66.0f
               withSuperView:APPDELEGATE.window];
        return;
    }
    self.productName=self.nameTextField.text;
    [self getTreeSHUXINGWithBtn:sender];
}
-(void)creatSCreeningCellsWithAnswerWithAry:(NSArray *)specAry
{
    self.dataAry=[TreeSpecificationsModel creatTreeSpecificationsModelAryByAry:self.dataAry];
   
    [self.backScrollView.subviews enumerateObjectsUsingBlock:^(UIView *myview, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([myview isKindOfClass:[FabutiaojiaCell class]]) {
            [myview removeFromSuperview];
        }
    }];
    CGFloat Y=88;
    for (int i=0; i<self.dataAry.count; i++) {
        TreeSpecificationsModel *model=self.dataAry[i];
        FabutiaojiaCell *cell;
        NSMutableString *answerStr=[NSMutableString string];
        for (int j=0; j<specAry.count; j++) {
            NSDictionary *specDic=specAry[j];
            
            if ([[specDic objectForKey:@"name"] isEqualToString:model.name]) {
                answerStr=[specDic objectForKey:@"value"];
            }
        }
        if ([answerStr isEqualToString:@"不限"]) {
            answerStr = [NSMutableString string];
        }
    
        cell=[[FabutiaojiaCell alloc]initWithFrame:CGRectMake(0, Y, kWidth, 50) AndModel:model andAnswer:answerStr];
        [cellAry addObject:cell.model];
        Y=CGRectGetMaxY(cell.frame);
        // cell.delegate=self;
        [cell setBackgroundColor:[UIColor whiteColor]];
        [self.backScrollView addSubview:cell];
    }
    CGRect otherframe= self.otherInfoView.frame;
    otherframe.origin.y=Y+5;
    self.otherInfoView.frame=otherframe;
    [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(self.otherInfoView.frame)+5)];
    if (self.baseMessageDic) {
        self.countTextField.text=[NSString stringWithFormat:@"%@",[self.baseMessageDic objectForKey:@"count"]];
        self.priceTextField.text=[NSString stringWithFormat:@"%@",[self.baseMessageDic objectForKey:@"price"]];
        NSArray *ectiveAry = @[@"一天",@"三天",@"五天",@"一周",@"半个月",@"一个月",@"三个月",@"半年",@"一年",@"永久"];
        NSInteger ective=[[self.baseMessageDic objectForKey:@"effective"] integerValue];
        self.ecttiv=ective;
        NSString *str=@"永久";
        if (self.ecttiv<=10) {
            str=ectiveAry[ective-1];
        }
        [self.ectiveBtn setTitle:str forState:UIControlStateNormal];
        NSString *addressStr=[self.baseMessageDic objectForKey:@"address"];
      addressStr =  [addressStr stringByReplacingOccurrencesOfString:@"null" withString:@""];
        [self.areaBtn setTitle:addressStr forState:UIControlStateNormal];
        self.birefField.text=[self.baseMessageDic objectForKey:@"remark"];
        self.AreaProvince=[self.baseMessageDic objectForKey:@"province"];
        self.AreaCity=[self.baseMessageDic objectForKey:@"city"];
        self.AreaCounty=[self.baseMessageDic objectForKey:@"county"];
    }

}
-(void)creatScreeningCells
{
    self.dataAry=[TreeSpecificationsModel creatTreeSpecificationsModelAryByAry:self.dataAry];
    //    NSLog(@"%@",ary);
    CGFloat Y=88;
    [self.backScrollView.subviews enumerateObjectsUsingBlock:^(UIView *myview, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([myview isKindOfClass:[FabutiaojiaCell class]]) {
            [myview removeFromSuperview];
        }
    }];
    for (int i=0; i<self.dataAry.count; i++) {
        FabutiaojiaCell *cell;
        cell=[[FabutiaojiaCell alloc]initWithFrame:CGRectMake(0, Y, kWidth, 50) AndModel:self.dataAry[i] andAnswer:nil];
        [cellAry addObject:cell.model];
        Y=CGRectGetMaxY(cell.frame);
        [cell setBackgroundColor:[UIColor whiteColor]];
        [self.backScrollView addSubview:cell];
    }
    CGRect otherframe= self.otherInfoView.frame;
    otherframe.origin.y=Y+5;
    self.otherInfoView.frame=otherframe;
    [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(self.otherInfoView.frame)+5)];
}
-(void)cellBeginEditing:(UITextField *)field
{
    self.nowTextField=field;
}

-(void)hidingKey
{
    if (self.nowTextField) {
        [self.nowTextField resignFirstResponder];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hidingKey];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)selectNum:(NSInteger)select
{
    NSLog(@"%ld",select+1);
    self.ecttiv=select+1;
    //@[@"一天",@"三天",@"五天",@"一周",@"半个月",@"一个月",@"三个月",@"半年",@"一年",@"永久"]
    
}
-(void)selectInfo:(NSString *)select
{
    [self.ectiveBtn setTitle:select forState:UIControlStateNormal];
}
- (void)requestProductType {
    [HTTPCLIENT getTypeInfoSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue] == 1 ) {
            NSArray *typeListArray = [[responseObject objectForKey:@"result"] objectForKey:@"typeList"];
            if (typeListArray.count == 0) {
                NSLog(@"暂时没有产品信息!!!");
            }
            else if (typeListArray.count > 0) {
                self.productTypeDataMArray = (NSMutableArray *)typeListArray;
                [self showSideView];
            }
        }
        else if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
            
        }
    } failure:^(NSError *error) {
        //NSLog(@"%@",error);
    }];
}

- (void)showSideView {
    //[self.nameTextField resignFirstResponder];
    if (!self.sideView) {
        self.sideView = [[ZIKSideView alloc] initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight)];
    }
    self.sideView.pleaseSelectLabel.text = @"请选择苗木";
    self.sideView.selectView.uidDelegate = self;
    //    self.selectView = self.sideView.selectView;
    //    self.selectView.delegate = self;
    self.sideView.dataArray = self.productTypeDataMArray;
    self.sideView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:.3 animations:^{
        self.sideView.frame = CGRectMake(0, 0, kWidth, kHeight);
    }];
    [self.view addSubview:self.sideView];
}

- (void)didSelectorUid:(NSString *)selectId title:(NSString *)selectTitle {
    NSLog(@"%@",selectTitle);
    self.nameTextField.text = selectTitle;
    [self.sideView removeSideViewAction];
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
