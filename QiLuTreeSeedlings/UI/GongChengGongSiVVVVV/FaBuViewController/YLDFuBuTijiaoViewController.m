//
//  YLDFuBuTijiaoViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/15.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDFuBuTijiaoViewController.h"
#import "YLDMiaoMuUnTableViewCell.h"
#import "UIDefines.h"
#import "JSONKit.h"
#import "HttpClient.h"
@interface YLDFuBuTijiaoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy) NSString *typeStr;
@property (nonatomic,copy) NSString *nameStr;
@property (nonatomic,copy) NSString *areaShengStr;
@property (nonatomic,copy) NSString *areaShiStr;
@property (nonatomic,copy) NSString *timeStr;
@property (nonatomic,copy) NSString *priceStr;
@property (nonatomic,copy) NSString *zhiliangStr;
@property (nonatomic,copy) NSString *xingjingStr;
@property (nonatomic,copy) NSString *diJingStr;
@property (nonatomic,copy) NSString *lianxiRStr;
@property (nonatomic,copy) NSString *phoneStr;
@property (nonatomic,copy) NSString *shuomingStr;
@property (nonatomic,weak) UIView *addView;
@property (nonatomic,strong) NSMutableArray *miaomuAry;
@property (nonatomic,weak) UITableView *tableView;
@end

@implementation YLDFuBuTijiaoViewController
-(id)initWithType:(NSString *)typeStr andName:(NSString *)nameStr andAreaSheng:(NSString *)areaShengStr andAreaShi:(NSString *)areaShiStr andTime:(NSString *)timeStr andPrice:(NSString *)priceStr andZhiL:(NSString *)zhiliangStr andXingJing:(NSString *)xingjingStr andDiJing:(NSString *)diJingStr andLianxR:(NSString *)lianxiRStr andPhone:(NSString *)phoneStr andShuoMing:(NSString *)shuomingStr
{
    self=[super init];
    if (self) {
        self.typeStr=typeStr;
        self.nameStr=nameStr;
        self.areaShengStr=areaShengStr;
        self.areaShiStr=areaShiStr;
        self.timeStr=timeStr;
        self.priceStr=priceStr;
        self.zhiliangStr=zhiliangStr;
        self.xingjingStr=xingjingStr;
        self.diJingStr=diJingStr;
        self.lianxiRStr=lianxiRStr;
        self.phoneStr=phoneStr;
        self.shuomingStr=shuomingStr;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"订单发布";
    self.miaomuAry=[NSMutableArray array];
    UITextField *nameField=[self creatTextFieldWithName:@"项目名称" alortStr:@"" andFrame:CGRectMake(0, 64, kWidth, 50)];
    nameField.text=self.nameStr;
    nameField.enabled=NO;
    self.addView=[self CreatAddView];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 205, kWidth, kHeight-245)];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    UIButton *chongzhiBtn=[[UIButton alloc]initWithFrame:CGRectMake(10,kHeight-45, kWidth/2-15, 40)];
    [chongzhiBtn setBackgroundColor:NavYellowColor];
    [chongzhiBtn setTitle:@"上一步" forState:UIControlStateNormal];
    [self.view addSubview:chongzhiBtn];
    [chongzhiBtn addTarget:self action:@selector(chongzhiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *xiayibuBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2+5, kHeight-45, kWidth/2-15, 40)];
    [xiayibuBtn setBackgroundColor:NavColor];
    [xiayibuBtn setTitle:@"发布" forState:UIControlStateNormal];
    [xiayibuBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xiayibuBtn];
    // Do any additional setup after loading the view.
}
-(void)nextBtnAction:(UIButton *)sender
{
    if (self.miaomuAry.count<=0) {
        [ToastView showTopToast:@"至少添加一项苗木"];
        return;
    }
    NSString *miaomuJsonStr=[self.miaomuAry JSONString];
    [HTTPCLIENT fabuGongChengDingDanWithorderName:self.nameStr WithorderTypeUid:self.typeStr WithusedProvince:self.areaShengStr WithusedCity:self.areaShiStr WithendDate:self.timeStr WithchargePerson:self.lianxiRStr Withphone:self.phoneStr WithqualityRequirement:self.zhiliangStr WithquotationRequires:self.priceStr Withdbh:self.xingjingStr WithgroundDiameter:self.diJingStr Withdescription:self.shuomingStr With:miaomuJsonStr Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"发布成功，即将返回"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)chongzhiBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.miaomuAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLDMiaoMuUnTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDMiaoMuUnTableViewCell"];
    if (!cell) {
        cell=[YLDMiaoMuUnTableViewCell yldMiaoMuUnTableViewCell];
    }
    cell.bianhaoLab.text=[NSString stringWithFormat:@"%ld",indexPath.row+1];
    NSDictionary *DIC=self.miaomuAry[indexPath.row];
    cell.messageDic=DIC;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(UIView *)CreatAddView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 120, kWidth, 80)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UITextField *nameTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 5, kWidth/2-45, 30)];
    nameTextField.tag=111;
    [nameTextField setFont:[UIFont systemFontOfSize:14]];
    nameTextField.placeholder=@"请输入苗木品种";
    nameTextField.borderStyle=UITextBorderStyleRoundedRect;
    nameTextField.textColor=NavColor;
    [view addSubview:nameTextField];
   
    UITextField *numTextField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth/2-25, 5, kWidth/2-45, 30)];
    numTextField.placeholder=@"请输入需求数量";
    numTextField.tag=112;
    [numTextField setFont:[UIFont systemFontOfSize:14]];
    numTextField.borderStyle=UITextBorderStyleRoundedRect;
    numTextField.textColor=NavYellowColor;
    numTextField.keyboardType=UIKeyboardTypeNumberPad;
    [view addSubview:numTextField];
    UITextField *shuomingTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 40, kWidth-80, 30)];
    shuomingTextField.placeholder=@"请输入需求数量";
    shuomingTextField.borderStyle=UITextBorderStyleRoundedRect;
    shuomingTextField.textColor=DarkTitleColor;
    shuomingTextField.tag=113;
    [shuomingTextField setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:shuomingTextField];
    UIButton *addBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-60, 5, 55, 65)];
    [addBtn setImage:[UIImage imageNamed:@"addView"] forState:UIControlStateNormal];
    [view addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:view];
    UIImageView *lineImagV=[[UIImageView alloc]initWithFrame:CGRectMake(10,80-0.5, kWidth-20, 0.5)];
    [lineImagV setBackgroundColor:kLineColor];
    
    [view addSubview:lineImagV];
    return view;
}
-(void)addBtnAction:(UIButton *)sender
{
    UITextField *nameTextField=[self.addView viewWithTag:111];
    UITextField *numTextField=[self.addView viewWithTag:112];
    UITextField *shuomingTextField=[self.addView viewWithTag:113];
    if (nameTextField.text.length==0) {
        [ToastView showTopToast:@"请输入苗木品种"];
        return;
    }
    if (numTextField.text.length==0) {
        [ToastView showTopToast:@"请输入需求数量"];
        return;
    }
    
    NSMutableDictionary *miaomuDic=[NSMutableDictionary dictionary];
    miaomuDic[@"name"]=nameTextField.text;
    miaomuDic[@"quantity"]=numTextField.text;
    if (shuomingTextField.text.length==0) {
        shuomingTextField.text=nil;
    }else{
        miaomuDic[@"description"]=shuomingTextField.text;
    }
    
    [self.miaomuAry addObject:miaomuDic];
    nameTextField.text=nil;
    numTextField.text=nil;
    shuomingTextField.text=nil;
    [nameTextField resignFirstResponder];
    [numTextField resignFirstResponder];
    [shuomingTextField resignFirstResponder];
    [self.tableView reloadData];
}
-(UITextField *)creatTextFieldWithName:(NSString *)nameStr alortStr:(NSString *)alortStr andFrame:(CGRect)frame
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, frame.size.height)];
    [nameLab setText:nameStr];
    [nameLab setTextColor:detialLabColor];
    [nameLab setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:nameLab];
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(110, 7, 160/320.f*kWidth, 30)];
    textField.placeholder=alortStr;
    textField.textColor=DarkTitleColor;
    [view addSubview:textField];
    UIImageView *lineImagV=[[UIImageView alloc]initWithFrame:CGRectMake(10,frame.size.height-0.5, kWidth-20, 0.5)];
    [lineImagV setBackgroundColor:kLineColor];
    
    [view addSubview:lineImagV];
    [self.view addSubview:view];
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
