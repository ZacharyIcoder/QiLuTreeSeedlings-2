//
//  YLDFuBuTijiaoViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/15.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDFuBuTijiaoViewController.h"
#import "YLDMiaoMuUnTableViewCell.h"
#import "YLDMMPiLiangBianJiViewController.h"
#import "UIDefines.h"
#import "JSONKit.h"
#import "HttpClient.h"
@interface YLDFuBuTijiaoViewController ()<UITableViewDelegate,UITableViewDataSource,YLDMMeditingDelegate>
@property (nonatomic,copy) NSString *typeStr;
@property (nonatomic,copy) NSString *typeName;
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
@property (nonatomic,strong) UIView *addView;
@property (nonatomic,strong) NSMutableArray *miaomuAry;
@property (nonatomic,weak) UITableView *tableView;
@end

@implementation YLDFuBuTijiaoViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(id)initWithType:(NSString *)typeStr andTypeName:(NSString *)typeName andName:(NSString *)nameStr andAreaSheng:(NSString *)areaShengStr andAreaShi:(NSString *)areaShiStr andTime:(NSString *)timeStr andPrice:(NSString *)priceStr andZhiL:(NSString *)zhiliangStr andXingJing:(NSString *)xingjingStr andDiJing:(NSString *)diJingStr andLianxR:(NSString *)lianxiRStr andPhone:(NSString *)phoneStr andShuoMing:(NSString *)shuomingStr
{
    self=[super init];
    if (self) {
        self.typeStr=typeStr;
        self.typeName=typeName;
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
    UIButton *piliangBianJiBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-90, 24, 80, 40)];
    [piliangBianJiBtn setTitle:@"批量编辑" forState:UIControlStateNormal];
    [piliangBianJiBtn addTarget:self action:@selector(pliangbianjiBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBackView addSubview:piliangBianJiBtn];
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
-(void)pliangbianjiBtnAction
{
    if (self.miaomuAry.count<=0) {
        [ToastView showTopToast:@"至少添加一项苗木"];
        return;
    }
    YLDMMPiLiangBianJiViewController *yldMM=[[YLDMMPiLiangBianJiViewController alloc]initWithDataAry:self.miaomuAry];
    yldMM.delegate=self;
    [self.navigationController pushViewController:yldMM animated:YES];
}
-(void)finishActionWithAry:(NSMutableArray *)ary{
    self.miaomuAry=ary;
    [self.tableView reloadData];
}
-(void)nextBtnAction:(UIButton *)sender
{
    if (self.miaomuAry.count<=0) {
        [ToastView showTopToast:@"至少添加一项苗木"];
        return;
    }
    NSString *miaomuJsonStr=[self.miaomuAry JSONString];
    [HTTPCLIENT fabuGongChengDingDanWithUid:nil WithprojectName:self.nameStr WithorderName:self.typeName WithorderTypeUid:self.typeStr WithusedProvince:self.areaShengStr WithusedCity:self.areaShiStr WithendDate:self.timeStr WithchargePerson:self.lianxiRStr Withphone:self.phoneStr WithqualityRequirement:self.zhiliangStr WithquotationRequires:self.priceStr Withdbh:self.xingjingStr WithgroundDiameter:self.diJingStr Withdescription:self.shuomingStr With:miaomuJsonStr Success:^(id responseObject) {
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
    NSString *sdsadsa=DIC[@"description"];
    CGFloat height=[self getHeightWithContent:sdsadsa width:kWidth-70 font:15];
    CGRect frame=cell.frame;
    if (height>20) {
        frame.size.height=70+height;
    }else{
        frame.size.height=90;
    }
    cell.frame=frame;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *DIC=self.miaomuAry[indexPath.row];
   
    NSString *sdsadsa=DIC[@"description"];
    CGFloat height=[self getHeightWithContent:sdsadsa width:kWidth-70 font:15];
//    CGRect frame=cell.frame;
    if (height>20) {
        return 70+height;
    }else{
         return 90;
    }
}
-(UIView *)CreatAddView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 120, kWidth, 80)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UITextField *nameTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 5, kWidth/2-45, 30)];

    [nameTextField setFont:[UIFont systemFontOfSize:14]];
    nameTextField.tag=20;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nameTextField];
    nameTextField.placeholder=@"请输入苗木品种";
    nameTextField.borderStyle=UITextBorderStyleRoundedRect;
    nameTextField.textColor=NavColor;
    [view addSubview:nameTextField];
   
    UITextField *numTextField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth/2-25, 5, kWidth/2-45, 30)];
    numTextField.placeholder=@"请输入需求数量";
  
    numTextField.tag=7;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:numTextField];
    [numTextField setFont:[UIFont systemFontOfSize:14]];
    numTextField.borderStyle=UITextBorderStyleRoundedRect;
    numTextField.textColor=NavYellowColor;
    numTextField.keyboardType=UIKeyboardTypeNumberPad;
    [view addSubview:numTextField];
    UITextField *shuomingTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 40, kWidth-80, 30)];
    shuomingTextField.tag=100;
    shuomingTextField.placeholder=@"请输入苗木说明(100字以内)";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:shuomingTextField];
    shuomingTextField.borderStyle=UITextBorderStyleRoundedRect;
    shuomingTextField.textColor=DarkTitleColor;

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
    UITextField *nameTextField=[self.addView viewWithTag:20];
    UITextField *numTextField=[self.addView viewWithTag:7];
    UITextField *shuomingTextField=[self.addView viewWithTag:100];
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
- (void)textFieldChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
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
                [ToastView showToast:[NSString stringWithFormat:@"最多%ld个字符",kssss] withOriginY:250 withSuperView:self.view];
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
            [ToastView showToast:[NSString stringWithFormat:@"最多%ld个字符",kssss] withOriginY:250 withSuperView:self.view];
            textField.text = [toBeString substringToIndex:kssss];
            return;
        }
    }
}
//获取字符串的高度
-(CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.height;
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
