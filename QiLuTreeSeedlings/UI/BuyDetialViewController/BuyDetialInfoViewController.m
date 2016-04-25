//
//  BuyDetialInfoViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/7.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "BuyDetialInfoViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "BuyUserInfoTableViewCell.h"
#import "BuyOtherInfoTableViewCell.h"
#import "QIYeMessageTableViewCell.h"
#import "BuySearchTableViewCell.h"
#import "HotBuyModel.h"
#import "BuySearchTableViewCell.h"
#import "BuyDetialModel.h"
#import "buyFabuViewController.h"
#import "UIButton+ZIKEnlargeTouchArea.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>


@interface BuyDetialInfoViewController ()<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UILabel *navTitleLab;
@property (nonatomic,strong)UIButton *collectionBtn;
@property (nonatomic,strong)NSDictionary *infoDic;
@property (nonatomic,strong)NSArray *specAry;
@property (nonatomic,strong)NSArray *recommendeAry;
@property (nonatomic,strong)NSString *uid;
@property (nonatomic) NSInteger type;
@property (nonatomic,strong)BuyDetialModel *model;
@end

@implementation BuyDetialInfoViewController
-(id)initWithSaercherInfo:(NSString *)uid
{
    self=[super init];
    if (self) {
        self.uid=uid;
        self.type=1;
      //  NSLog(@"%@",uid);
        [HTTPCLIENT buyDetailWithUid:uid WithAccessID:APPDELEGATE.userModel.access_id
         WithType:@"0" WithmemberCustomUid:@""                             Success:^(id responseObject) {
            //NSLog(@"%@",responseObject);
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            self.infoDic=dic;
             self.model=[BuyDetialModel creatBuyDetialModelByDic:[dic objectForKey:@"detail"]];
             self.model.uid=uid;
            [self reloadMyView];
        } failure:^(NSError *error) {
            
        }];
        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-50) style:UITableViewStyleGrouped];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        [self.view addSubview:self.tableView];
        UIView *navView =  [self makeNavView];
        [self.view addSubview:navView];
    }
    return self;
}
-(id)initMyDetialWithSaercherInfo:(NSString *)uid
{
    self=[super init];
    if (self) {
        self.uid=uid;
        //  NSLog(@"%@",uid);
        [HTTPCLIENT buyDetailWithUid:uid WithAccessID:APPDELEGATE.userModel.access_id
                            WithType:@"0" WithmemberCustomUid:@""                             Success:^(id responseObject) {
                                //NSLog(@"%@",responseObject);
                                NSDictionary *dic=[responseObject objectForKey:@"result"];
                                self.infoDic=dic;
                                self.model=[BuyDetialModel creatBuyDetialModelByDic:[dic objectForKey:@"detail"]];
                                self.model.uid=uid;
                                [self reloadMyView];
                            } failure:^(NSError *error) {
                                
                            }];
        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStyleGrouped];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.type=2;
        [self.view addSubview:self.tableView];
        UIView *navView =  [self makeNavView];
        
        [self.view addSubview:navView];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BGColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (self.type==1) {
        UIButton *messageBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, kHeight-50, kWidth/2, 50)];
        [messageBtn setTitle:@"短信留言" forState:UIControlStateNormal];
        [messageBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
        messageBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
        [messageBtn addTarget:self action:@selector(meaageAction) forControlEvents:UIControlEventTouchUpInside];
        [messageBtn setImage:[UIImage imageNamed:@"shotMessageImage"] forState:UIControlStateNormal];
        //[messageBtn setBackgroundColor:[UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1]];
        [self.view addSubview:messageBtn];
        UIButton *phoneBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2, kHeight-50, kWidth/2, 50)];
        [phoneBtn setTitle:@"联系商家" forState:UIControlStateNormal];
        [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        phoneBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
        [phoneBtn setImage:[UIImage imageNamed:@"phoneImage"] forState:UIControlStateNormal];
        [phoneBtn setBackgroundColor:NavColor];
        [phoneBtn addTarget:self action:@selector(CallAction) forControlEvents:UIControlEventTouchUpInside];
        //[messageBtn setBackgroundColor:[UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1]];
        [self.view addSubview:phoneBtn];
    }
    

    // Do any additional setup after loading the view.
}
-(void)CallAction
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[[self.infoDic objectForKey:@"detail"] objectForKey:@"phone"]];
                //NSLog(@"str======%@",[[self.infoDic objectForKey:@"detail"] objectForKey:@"phone"]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
-(void)meaageAction
{
//    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"sms://%@",[[self.infoDic objectForKey:@"detail"] objectForKey:@"phone"]];
//
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    [self showMessageView:[NSArray arrayWithObjects:[[self.infoDic objectForKey:@"detail"] objectForKey:@"phone"], nil] title:@"苗木求购" body:[NSString stringWithFormat:@"我对您在齐鲁苗木网APP发布的供应信息:%@很感兴趣",[[self.infoDic objectForKey:@"detail"] objectForKey:@"productName"]]];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
        {
            [ToastView showToast:@"消息发送成功" withOriginY:250 withSuperView:self.view];
        }

            break;
        case MessageComposeResultFailed:
            //信息传送失败
        {
            [ToastView showToast:@"消息发送失败" withOriginY:250 withSuperView:self.view];
        }

            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
        {
            [ToastView showToast:@"取消发送" withOriginY:250 withSuperView:self.view];
        }

            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];

}

-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = self;

        // You can specify one or more preconfigured recipients.  The user has
        // the option to remove or add recipients from the message composer view
        // controller.
         picker.recipients = phones;

        // You can specify the initial message text that will appear in the message
        // composer view controller.
        picker.body = body;

        [self presentViewController:picker animated:YES completion:NULL];
//        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
//        controller.recipients = phones;
//        controller.navigationBar.tintColor = [UIColor redColor];
//        controller.body = body;
//        controller.messageComposeDelegate = self;
//        [self presentViewController:controller animated:YES completion:nil];
        [[[[picker viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}


-(void)reloadMyView
{
    NSString *titleStr=[[self.infoDic objectForKey:@"detail"] objectForKey:@"productName"];
    [self.navTitleLab setText:[NSString stringWithFormat:@"求购：%@",titleStr]];
    
    if ([[[self.infoDic objectForKey:@"detail"] objectForKey:@"collect"] integerValue]) {
        self.collectionBtn.selected=YES;
    }
    self.specAry=[[self.infoDic objectForKey:@"detail"]objectForKey:@"spec"];
    NSArray *rocomAry=[self.infoDic objectForKey:@"list"];
    self.recommendeAry = [HotBuyModel creathotBuyModelAryByAry:rocomAry];
     [self.tableView reloadData];
    
}
-(UIView *)makeNavView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, 64)];
    [view setBackgroundColor:NavColor];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdgeWithTop:10 right:25 bottom:10 left:10];
    [view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setEnlargeEdgeWithTop:10 right:25 bottom:10 left:10];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-80,26, 160, 30)];
    [titleLab setTextColor:[UIColor whiteColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setText:@"求购："];
    [titleLab setFont:[UIFont systemFontOfSize:21]];
    self.navTitleLab=titleLab;
    [view addSubview:titleLab];
    if (self.type==2) {
         UIButton *editingBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-60, 26, 50, 30)];
        [editingBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editingBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [editingBtn addTarget:self action:@selector(editingBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:editingBtn];
    }else
    {
        UIButton *collectionBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-40, 26, 30, 30)];
        [collectionBtn setEnlargeEdgeWithTop:0 right:5 bottom:0 left:15];
        self.collectionBtn = collectionBtn;
        [collectionBtn setImage:[UIImage imageNamed:@"collectionN"] forState:UIControlStateNormal];
        [collectionBtn setImage:[UIImage imageNamed:@"collectionT"] forState:UIControlStateSelected];
        [collectionBtn addTarget:self action:@selector(collectionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:collectionBtn];
    }
    
    return view;
}
-(void)editingBtn:(UIButton *)sender
{
    if (self.model.state==0||self.model.state==1||self.model.state==5) {
        [ToastView showTopToast:@"该条求购不可编辑"];
        return;
    }
    self.model.uid=self.uid;
    buyFabuViewController *buyFabuVC=[[buyFabuViewController alloc]initWithModel:self.model];
    
    [self.navigationController pushViewController:buyFabuVC animated:YES];
}
-(void)collectionBtn:(UIButton *)sender
{
    if (sender.selected==NO) {
        [HTTPCLIENT collectBuyWithSupplyID:self.uid Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"收藏成功"];
                sender.selected=YES;
                [HTTPCLIENT buyDetailWithUid:self.uid WithAccessID:APPDELEGATE.userModel.access_id
                 WithType:@"0" WithmemberCustomUid:@""
                                     Success:^(id responseObject) {
                    if ([[responseObject objectForKey:@"success"] integerValue]) {
                        self.infoDic=[responseObject objectForKey:@"result"];
                    }else{
                        [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                    }
                } failure:^(NSError *error) {
                    
                }];
            }
        } failure:^(NSError *error) {
            
        }];
        return;
    }
    
    
    if (sender.selected) {
        [HTTPCLIENT deletesenderCollectWithIds:[[self.infoDic objectForKey:@"detail"] objectForKey:@"collectUid"] Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                sender.selected=NO;
                [ToastView showTopToast:@"取消收藏成功"];
            }else
            {
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }

   // NSLog(@"collectionBtnAction");
}
-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.type==2) {
        return 4;
    }
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==4) {
        return self.recommendeAry.count;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        BuyUserInfoTableViewCell *cell=[[BuyUserInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 100)];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.infoDic) {
            cell.dic=[self.infoDic objectForKey:@"detail"];
        }
        return cell;
    }else if(indexPath.section==1)
    {
        BuyOtherInfoTableViewCell *cell=[[BuyOtherInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, self.specAry.count*30+40) andName:self.model.productName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.specAry) {
            cell.ary=self.specAry;
        }
        return cell;
    }else if (indexPath.section==2)
    {
        QIYeMessageTableViewCell *cell=[[QIYeMessageTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 140)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.infoDic) {
            cell.dic=[self.infoDic objectForKey:@"detail"];
        }
        return cell;
    }else if(indexPath.section==3)
    {
        
        NSString *labelText=[[self.infoDic objectForKey:@"detail"] objectForKey:@"description"];
        if (labelText.length==0) {
            labelText=@"暂无";
        }
      CGFloat height = [self getHeightWithContent:labelText width:kWidth-40 font:13];
      
        UITableViewCell *cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, kWidth, height+20)];
        UILabel *cellLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, kWidth-40, height)];
        [cellLab setFont:[UIFont systemFontOfSize:13]];
        cellLab.numberOfLines=0;
        [cell addSubview:cellLab];
        [cellLab setText:labelText];
        return cell;

    }
    if (indexPath.section==4) {
        BuySearchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[BuySearchTableViewCell IDStr]];
        if (!cell) {
            cell=[[BuySearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[BuySearchTableViewCell IDStr]  WithFrame:CGRectMake(0, 0, kWidth, 60)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        HotBuyModel *model=self.recommendeAry[indexPath.row];
        cell.hotBuyModel=model;
        return cell;
    }
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 100;
    }
    if (indexPath.section==1) {
        if (self.specAry) {
            return self.specAry.count*30+40;
        }
    }if (indexPath.section==2) {
        return 140;
    }
    if(indexPath.section==3)
    {
        NSString *labelText=[[self.infoDic objectForKey:@"detial"] objectForKey:@"description"];
        if (labelText) {
            return  [self getHeightWithContent:labelText width:kWidth-40 font:13]+20;
        }
        else{
            return 40;
        }
       
    }
    if (indexPath.section==4) {
        return 60;
    }
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view=[[UIView alloc]init];
            return view;
    }
    if (section==4) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
        [view setBackgroundColor:BGColor];
        UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 24.25, kWidth, 0.5)];
        [lineView setBackgroundColor:kLineColor];
        [view addSubview:lineView];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-35, 0, 70, 50)];
        [titleLab setTextColor:titleLabColor];
        [titleLab setBackgroundColor:BGColor];
        [titleLab setTextAlignment:NSTextAlignmentCenter];
        [titleLab setText:@"猜你喜欢"];
        [view addSubview:titleLab];
        return view;
    }
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    [view setBackgroundColor:BGColor];
    UIImageView *linImag=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 2.3, 16)];
    [linImag setBackgroundColor:NavColor];
    [view addSubview:linImag];
    UILabel *messageLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 5, 60, 20)];
    [messageLab setFont:[UIFont systemFontOfSize:13]];
    [messageLab setTextColor:detialLabColor];
    [view addSubview:messageLab];
    if (section==1) {
        messageLab.text=@"苗木信息";
    }else if (section==2){
        messageLab.text=@"其他信息";
    }else if (section==3){
        messageLab.text=@"备注";
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.01;
    }
    if (section==4) {
        return 50;
    }else{
    return 30;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==4) {
        HotBuyModel *model=self.recommendeAry[indexPath.row];
        BuyDetialInfoViewController *vc=[[BuyDetialInfoViewController alloc]initWithSaercherInfo:model.uid];
        [self.navigationController pushViewController:vc animated:YES];
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
@end
