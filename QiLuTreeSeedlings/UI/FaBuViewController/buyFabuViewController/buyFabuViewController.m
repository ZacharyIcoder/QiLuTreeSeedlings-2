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
#import "TreeSpecificationsModel.h"
#import "FabutiaojiaCell.h"
#import "ZIKSideView.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
#import "YLDMyBuyListViewController.h"
#import "BuyDetialInfoViewController.h"
#import "FaBuViewController.h"
#import "GuiGeModel.h"
#import "GuiGeView.h"
@interface buyFabuViewController ()<UITextFieldDelegate,ZIKSelectViewUidDelegate,UIAlertViewDelegate,GuiGeViewDelegate>
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
@property (nonatomic, strong) ZIKSideView     *sideView;
@property (nonatomic, strong) NSMutableArray   *productTypeDataMArray;
@property (nonatomic, strong) NSMutableArray *guige1Ary;
@property (nonatomic,strong)GuiGeView *guigeView;
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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.ecttiv=0;
    self.productTypeDataMArray = [NSMutableArray array];
    self.guige1Ary=[NSMutableArray array];
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
    titleTextField.tag=111;
    [titleTextField setFont:[UIFont systemFontOfSize:15]];

    self.titleTextField=titleTextField;
    UIImageView *titleLineView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 43.5, kWidth-20, 0.5)];
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
    [nameLab setTextColor:[UIColor darkGrayColor]];
    [nameLab setFont:[UIFont systemFontOfSize:15]];
    [nameLab setTextColor:titleLabColor];
    [nameView addSubview:nameLab];
    UITextField *nameTextField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth*0.30, 0, kWidth*0.6, 44)];
    nameTextField.placeholder=@"请输入苗木名称";
    nameTextField.textColor=NavColor;
    [nameTextField setFont:[UIFont systemFontOfSize:14]];
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

    UIButton *nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, kHeight-60, kWidth-80, 44)];
    [self.view addSubview:nextBtn];
    [nextBtn setBackgroundColor:NavColor];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
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
-(void)reloadViewWithFrame:(CGRect)frame
{
    [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(frame))];
}
//-(void)selectSheng:(CityModel *)sheng shi:(CityModel *)shi xian:(CityModel *)xian zhen:(CityModel *)zhen
//{
//    NSMutableString *namestr=[NSMutableString new];
//    if (sheng.code) {
//        [namestr appendString:sheng.cityName];
//        self.AreaProvince=sheng.code;
//    }else
//    {
//        self.AreaProvince=nil;
//    }
//    
//    if (shi.code) {
//        [namestr appendString:shi.cityName];
//        self.AreaCity=shi.code;
//    }else
//    {
//        self.AreaCity=nil;
//        
//    }
//    if (xian.code) {
//        [namestr appendString:xian.cityName];
//        self.AreaCounty=xian.code;
//    }else
//    {
//        self.AreaCounty=nil;
//    }
//    if (namestr.length>0) {
//        [self.areaBtn setTitle:namestr forState:UIControlStateNormal];
//        [self.areaBtn.titleLabel sizeToFit];
//    }else{
//        [self.areaBtn setTitle:@"不限" forState:UIControlStateNormal];
//        [self.areaBtn.titleLabel sizeToFit];
//        
//    }
//
//}
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
//    if (!self.productName) {
//        [ToastView showTopToast:@"苗木名称不正确"];
//        return;
//    }
    NSMutableArray *screenTijiaoAry=[NSMutableArray array];
    
    BOOL canrun = [self.guigeView  getAnswerAry:screenTijiaoAry];
    if (canrun) {
        for (int i=0; i<screenTijiaoAry.count; i++) {
            NSDictionary *dic=screenTijiaoAry[i];
            NSLog(@"%@---%@",dic[@"field"],dic[@"value"]);
        }
    }else{
        //NSLog(@"222");
    }
    
    return;
//    for (int i=0; i<cellAry.count; i++) {
//        TreeSpecificationsModel *model=cellAry[i];
//        if (model.anwser.length>0) {
//            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:model.field,@"field",
//                               model.anwser,@"anwser"
//                               , nil];
//            [screenTijiaoAry addObject:dic];
//        }
//    }
//    
//    if(screenTijiaoAry.count==0)
//    {
//        [ToastView showTopToast:@"请填入至少一种规格"];
//        return;
//    }
//    NSString *countStr=self.countTextField.text;
//    NSString *priceStr=self.priceTextField.text;
//    NSString *birefStr=self.birefField.text;
//    if (countStr.length==0) {
//        [ToastView showTopToast:@"请填写求购数量"];
//        return;
//    }
//    if ([self isPureInt:countStr]==NO) {
//        [ToastView showTopToast:@"数量的格式输入有误"];
//        return;
//    }
//    if (priceStr.length>0) {
//        if ([self isPureFloat:priceStr]==NO) {
//            [ToastView showTopToast:@"上车价的格式输入有误"];
//            return;
//        }
//    }
//    ShowActionV();
//    [HTTPCLIENT fabuBuyMessageWithUid:self.model.uid Withtitle:self.titleTextField.text WithName:self.productName WithProductUid:self.productUid WithCount:countStr WithPrice:priceStr WithEffectiveTime:[NSString stringWithFormat:@"%ld",(long)self.ecttiv] WithRemark:birefStr WithUsedProvince:self.AreaProvince WithUsedCity:self.AreaCity WithUsedCounty:self.AreaCounty WithAry:screenTijiaoAry Success:^(id responseObject) {
//        //        NSLog(@"%@",responseObject);
//        RemoveActionV();
//        if ([[responseObject objectForKey:@"success"] integerValue]) {
//            [ToastView showTopToast:@"提交成功，即将返回"];
//            //[self performSelector:@selector(backRootView) withObject:nil afterDelay:1];
//            for(UIViewController *controller in self.navigationController.viewControllers) {
//                if([controller isKindOfClass:[BuyDetialInfoViewController class]]||[controller isKindOfClass:[YLDMyBuyListViewController class]]||[controller isKindOfClass:[FaBuViewController class]]){
//                    [self.navigationController popToViewController:controller animated:YES];
//                }
//            }
//
//        }else
//        {
//            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
//        }
//    } failure:^(NSError *error) {
//       RemoveActionV(); 
//    }];
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
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(17, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdgeWithTop:15 right:60 bottom:10 left:10];
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
    
    [titleLab setFont:[UIFont systemFontOfSize:NavTitleSize]];
    [view addSubview:titleLab];
    return view;
}
- (void)getTreeSHUXINGWithBtn:(UIButton *)sender
{
    [self.guige1Ary removeAllObjects];
    if (self.guigeView) {
        [self.guigeView removeFromSuperview];
        self.guigeView=nil;
    }
    [HTTPCLIENT huoqumiaomuGuiGeWithTreeName:self.nameTextField.text andType:@"1" andMain:@"0" Success:^(id responseObject) {
        if (![[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showToast:[responseObject objectForKey:@"msg"]
                     withOriginY:66.0f
                   withSuperView:APPDELEGATE.window];
            if ([responseObject[@"msg"] isEqualToString:@"该苗木不存在"]) {
                [self requestProductType];
            }
        }else{
            sender.selected=YES;
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            self.productUid=[dic objectForKey:@"productUid"];
            NSArray *guigeAry=[dic objectForKey:@"list"];
           // NSMutableArray *selectAry=[NSMutableArray array];
            for (int i=0; i<guigeAry.count; i++) {
                NSDictionary *dic=guigeAry[i];
                if ([[dic objectForKey:@"level"] integerValue]==0) {
                    GuiGeModel *guigeModel=[GuiGeModel creatGuiGeModelWithDic:dic];
                    [self.guige1Ary addObject:guigeModel];
                }
                if ([[dic objectForKey:@"level"] integerValue]==1) {
                      GuiGeModel *guigeModel=[GuiGeModel creatGuiGeModelWithDic:dic];
                    //[selectAry addObject:guigeModel];
                    for (int j=0; j<self.guige1Ary.count; j++) {
                        GuiGeModel *guigeModel1=self.guige1Ary[j];
                        for (int k=0 ; k<guigeModel1.propertyLists.count; k++) {
                            Propers *proper=guigeModel1.propertyLists[k];
                            if (proper.relation == guigeModel.uid) {
                                proper.guanlianModel=guigeModel;
                            }
                        }
                    }
                }
            }
            GuiGeView *guigeView=[[GuiGeView alloc]initWithAry:self.guige1Ary andFrame:CGRectMake(0, 88, kWidth, 0)];
            [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(guigeView.frame))];
            guigeView.delegate=self;
            self.guigeView=guigeView;
            [self.backScrollView addSubview:guigeView];
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
               // [self creatSCreeningCellsWithAnswerWithAry:ary];
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
//-(void)creatSCreeningCellsWithAnswerWithAry:(NSArray *)specAry
//{
//    self.dataAry=[TreeSpecificationsModel creatTreeSpecificationsModelAryByAry:self.dataAry];
//   
//    [self.backScrollView.subviews enumerateObjectsUsingBlock:^(UIView *myview, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([myview isKindOfClass:[FabutiaojiaCell class]]) {
//            [myview removeFromSuperview];
//        }
//    }];
//    CGFloat Y=88;
//    for (int i=0; i<self.dataAry.count; i++) {
//        TreeSpecificationsModel *model=self.dataAry[i];
//        FabutiaojiaCell *cell;
//        NSMutableString *answerStr=[NSMutableString string];
//        for (int j=0; j<specAry.count; j++) {
//            NSDictionary *specDic=specAry[j];
//            
//            if ([[specDic objectForKey:@"name"] isEqualToString:model.name]) {
//                answerStr=[specDic objectForKey:@"value"];
//            }
//        }
//        if ([answerStr isEqualToString:@"不限"]) {
//            answerStr = [NSMutableString string];
//        }
//    
//        cell=[[FabutiaojiaCell alloc]initWithFrame:CGRectMake(0, Y, kWidth, 50) AndModel:model andAnswer:answerStr];
//        [cellAry addObject:cell.model];
//        Y=CGRectGetMaxY(cell.frame);
//        // cell.delegate=self;
//        [cell setBackgroundColor:[UIColor whiteColor]];
//        [self.backScrollView addSubview:cell];
//    }
////    CGRect otherframe= self.otherInfoView.frame;
////    otherframe.origin.y=Y+5;
////    self.otherInfoView.frame=otherframe;
////    [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(self.otherInfoView.frame)+5)];
////    if (self.baseMessageDic) {
////        self.countTextField.text=[NSString stringWithFormat:@"%@",[self.baseMessageDic objectForKey:@"count"]];
////        self.priceTextField.text=[NSString stringWithFormat:@"%@",[self.baseMessageDic objectForKey:@"price"]];
////        NSArray *ectiveAry = @[@"一天",@"三天",@"五天",@"一周",@"半个月",@"一个月",@"三个月",@"半年",@"一年",@"长期"];
////        NSInteger ective=[[self.baseMessageDic objectForKey:@"effective"] integerValue];
////        self.ecttiv=ective;
////        NSString *str=@"长期";
////        if (self.ecttiv<=10) {
////            str=ectiveAry[ective-1];
////        }
////        [self.ectiveBtn setTitle:str forState:UIControlStateNormal];
////        NSString *addressStr=[self.baseMessageDic objectForKey:@"address"];
////      addressStr =  [addressStr stringByReplacingOccurrencesOfString:@"null" withString:@""];
////        [self.areaBtn setTitle:addressStr forState:UIControlStateNormal];
////        self.birefField.text=[self.baseMessageDic objectForKey:@"remark"];
////        self.AreaProvince=[self.baseMessageDic objectForKey:@"province"];
////        self.AreaCity=[self.baseMessageDic objectForKey:@"city"];
////        self.AreaCounty=[self.baseMessageDic objectForKey:@"county"];
////    }
//
//}
//-(void)creatScreeningCells
//{
//    self.dataAry=[TreeSpecificationsModel creatTreeSpecificationsModelAryByAry:self.dataAry];
//    //    NSLog(@"%@",ary);
//    CGFloat Y=88;
//    [self.backScrollView.subviews enumerateObjectsUsingBlock:^(UIView *myview, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([myview isKindOfClass:[FabutiaojiaCell class]]) {
//            [myview removeFromSuperview];
//        }
//    }];
//    for (int i=0; i<self.dataAry.count; i++) {
//        FabutiaojiaCell *cell;
//        cell=[[FabutiaojiaCell alloc]initWithFrame:CGRectMake(0, Y, kWidth, 50) AndModel:self.dataAry[i] andAnswer:nil];
//        [cellAry addObject:cell.model];
//        Y=CGRectGetMaxY(cell.frame);
//        [cell setBackgroundColor:[UIColor whiteColor]];
//        [self.backScrollView addSubview:cell];
//    }
////    CGRect otherframe= self.otherInfoView.frame;
////    otherframe.origin.y=Y+5;
////    self.otherInfoView.frame=otherframe;
////    [self.backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(self.otherInfoView.frame)+5)];
//}
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
- (void)requestProductType {
    [HTTPCLIENT getTypeInfoSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue] == 1 ) {
            NSArray *typeListArray = [[responseObject objectForKey:@"result"] objectForKey:@"typeList"];
            if (typeListArray.count == 0) {
                [ToastView showTopToast:@"暂时没有产品信息!"];
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
    self.nameTextField.text = selectTitle;
    [self nameBtnAction:self.nameBtn];
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

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"%ld",(long)buttonIndex);
    if(alertView.tag == 300)//是否退出编辑
    {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(void)backBtnAction:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要退出编辑？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    //[[UIView appearance]setTintColor:titleLabColor];
    [alert show];
    alert.tag = 300;
    alert.delegate = self;

    //[self.navigationController popViewControllerAnimated:YES];
}

@end
