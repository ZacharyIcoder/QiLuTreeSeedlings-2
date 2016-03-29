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
#import "SreeningViewCell.h"
#import "buyFabuTijiaoViewController.h"
@interface buyFabuViewController ()<UITextFieldDelegate>
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
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(15/320.f*kWidth, 0, kWidth*0.25, 44)];
    [titleView addSubview:titleLab];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    titleLab.text=@"标题";
    UITextField *titleTextField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth*0.27, 0, kWidth*0.6, 44)];
    titleTextField.placeholder=@"请输入标题";
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
    [nameView addSubview:nameLab];
    UITextField *nameTextField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth*0.27, 0, kWidth*0.6, 44)];
    nameTextField.placeholder=@"请输入苗木名称";
    nameTextField.textColor=NavColor;
    nameTextField.text=@"油松";
    nameTextField.delegate=self;
  
    self.nameTextField=nameTextField;
    [nameView addSubview:nameTextField];
    UIButton *nameBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-70, 9, 50, 25)];
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
    if (self.titleTextField.text.length<5) {
        [ToastView showTopToast:@"标题不能小于五位"];
        return;
    }
    if (self.nameBtn.selected==NO) {
        [ToastView showTopToast:@"请先筛选"];
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
    buyFabuTijiaoViewController *buyfabuTJViewController=[[buyFabuTijiaoViewController alloc]initWithAry:screenTijiaoAry andTitle:self.titleTextField.text andProname:self.productName andProUid:self.productUid andDic:self.baseMessageDic andUid:self.model.uid];
    [self.navigationController pushViewController:buyfabuTJViewController animated:YES];
    //NSLog(@"%@",screenTijiaoAry);
    
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
    [titleLab setText:@"发布求购信息"];
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
       // NSLog(@"%@",responseObject);
        
        if (![[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showToast:[responseObject objectForKey:@"msg"]
                     withOriginY:66.0f
                   withSuperView:APPDELEGATE.window];
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
    //        if (self.model.spec.count>0) {
    //            NSArray *specAry=self.model.spec;
    //            for (int j=0; j<specAry.count; j++) {
    //                NSDictionary *specDic=specAry[j];
    //                TreeSpecificationsModel *model=self.dataAry[i];
    //                if ([[specDic objectForKey:@"name"] isEqualToString:model.name]) {
    //                    cell=[[SreeningViewCell alloc]initWithFrame:CGRectMake(0, Y, kWidth, 50) AndModel:self.dataAry[i] andAnswer:@""];
    //                }
    //            }
    //
    //        }else
    self.dataAry=[TreeSpecificationsModel creatTreeSpecificationsModelAryByAry:self.dataAry];
   
    
    //    NSLog(@"%@",ary);
    CGFloat Y=88;
    for (int i=0; i<self.dataAry.count; i++) {
        TreeSpecificationsModel *model=self.dataAry[i];
        SreeningViewCell *cell;
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
        cell=[[SreeningViewCell alloc]initWithFrame:CGRectMake(0, Y, kWidth, 50) AndModel:model andAnswer:answerStr];
        [cellAry addObject:cell.model];
        Y=CGRectGetMaxY(cell.frame);
        // cell.delegate=self;
        [cell setBackgroundColor:[UIColor whiteColor]];
        [self.backScrollView addSubview:cell];
    }
    [self.backScrollView setContentSize:CGSizeMake(0, Y+60)];
    
}
-(void)creatScreeningCells
{
    self.dataAry=[TreeSpecificationsModel creatTreeSpecificationsModelAryByAry:self.dataAry];
    //    NSLog(@"%@",ary);
    CGFloat Y=88;
    for (int i=0; i<self.dataAry.count; i++) {
        SreeningViewCell *cell;
        cell=[[SreeningViewCell alloc]initWithFrame:CGRectMake(0, Y, kWidth, 50) AndModel:self.dataAry[i]];
        [cellAry addObject:cell.model];
        Y=CGRectGetMaxY(cell.frame);
       // cell.delegate=self;
        [cell setBackgroundColor:[UIColor whiteColor]];
        [self.backScrollView addSubview:cell];
    }
    [self.backScrollView setContentSize:CGSizeMake(0, Y+60)];
}
-(void)cellBeginEditing:(UITextField *)field
{
    self.nowTextField=field;
}
//-(void)cellEndEditing
//{
//    if (self.backScrollView.frame.size.height==kHeight-44-44) {
//        return;
//    }
//    CGRect frame=self.backScrollView.frame;
//    frame.size.height=kHeight-44-44;
//    self.backScrollView.frame=frame;
//}
//-(void)cellKeyHight:(CGFloat)hight
//{
//    if (self.backScrollView.frame.size.height==kHeight-hight-44-44) {
//        return;
//    }
//    CGRect frame=self.backScrollView.frame;
//    frame.size.height=kHeight-hight-44-44;
//    self.backScrollView.frame=frame;
//}
-(void)hidingKey
{
    if (self.nowTextField) {
        [self.nowTextField resignFirstResponder];
    }
//    if (self.backScrollView.frame.size.height==kHeight-44-44) {
//        return;
//    }
//    CGRect frame=self.backScrollView.frame;
//    frame.size.height=kHeight-44-44;
//    self.backScrollView.frame=frame;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hidingKey];
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
