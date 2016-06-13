//
//  KeFuViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/31.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "KeFuViewController.h"
#import "YLDUserHelpViewController.h"
#import "YLDKeFuTableViewCell.h"
#import "UIDefines.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "HttpClient.h"
#import "MJRefresh.h"
#define PageSize @"15"
@interface KeFuViewController ()<UITableViewDelegate,UITableViewDataSource,YLDKeFuTableViewCellDelegate,MFMessageComposeViewControllerDelegate>
@property (nonatomic,strong)UILabel *nameLab;
@property (nonatomic,copy) NSString *phoneStr;
@property (nonatomic,strong) NSMutableArray *dataAry;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic)NSInteger pageNum;
@end

@implementation KeFuViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"客服系统";
    self.dataAry=[NSMutableArray array];
    self.pageNum=1;
    UIView *topview=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth,110-64)];
    [topview setBackgroundColor:NavColor];
    [self.view addSubview:topview];
    UIImageView *iamgeV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2-30, topview.frame.size.height-30, 60,60)];
    [iamgeV setImage:[UIImage imageNamed:@"kefutouxiang"]];
    [topview addSubview:iamgeV];
    UILabel* ZZZlAB=[[UILabel alloc]initWithFrame:CGRectMake(0, 110+35, kWidth, 30)];
    [ZZZlAB setFont:[UIFont systemFontOfSize:15]];
    [ZZZlAB setTextAlignment:NSTextAlignmentCenter];
    [ZZZlAB setTextColor:titleLabColor];
    [self.view addSubview:ZZZlAB];
    self.nameLab=ZZZlAB;
    
    [HTTPCLIENT kefuXiTongWithPage:PageSize WithPageNumber:@"1" WithIsLoad:@"0" Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            NSInteger type=[[dic objectForKey:@"type"] integerValue];
            if (type==2) {
                NSDictionary *dic2=[dic objectForKey:@"kehu"];
                self.nameLab.text=[dic2 objectForKey:@"name"];
                [self normalViewWithDic:dic2];
            }
            if (type==1) {
               NSDictionary *dic3=[dic objectForKey:@"kehu"];
                NSInteger allNum=[[dic3 objectForKey:@"allKehu"] integerValue];
                NSInteger unchongzhiNum=[[dic3 objectForKey:@"rechargeKehu"] integerValue];
                NSString *allStr=[NSString stringWithFormat:@"%ld",allNum];
                NSString *unchongzhiStr=[NSString stringWithFormat:@"%ld",unchongzhiNum];
                NSString *ssssStr=[NSString stringWithFormat:@"当前服务会员%@人，尚有%@人未进行充值",allStr,unchongzhiStr];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:ssssStr];
                
                [str addAttribute:NSForegroundColorAttributeName value:NavColor range:NSMakeRange(6,allStr.length)]; //设置字体颜色
                
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:25.0] range:NSMakeRange(6,allStr.length)]; //设置字体字号和字体类别
                
                [str addAttribute:NSForegroundColorAttributeName value:NavYellowColor range:NSMakeRange(10+allStr.length, unchongzhiStr.length)]; //设置字体颜色
                
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:25.0] range:NSMakeRange(10+allStr.length, unchongzhiStr.length)];
                self.nameLab.attributedText = str;
                [self.dataAry addObjectsFromArray:[dic3 objectForKey:@"infoList"]];
                 [self kefupersonViewWithDic:dic3];
                [self.tableView reloadData];
            
            }
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)kefupersonViewWithDic:(NSDictionary *)normalDic{
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 175, kWidth, kHeight-175)];
    self.tableView=tableView;
    tableView.delegate=self;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.dataSource=self;
    __weak typeof(self) weakSelf=self;
    [tableView addHeaderWithCallback:^{
        weakSelf.pageNum=1;
        [weakSelf getDataList];
    }];
    [tableView addFooterWithCallback:^{
        weakSelf.pageNum+=1;
        [weakSelf getDataList];
    }];
    [self.view addSubview:tableView];
}
-(void)getDataList
{
    [HTTPCLIENT kefuXiTongWithPage:PageSize WithPageNumber:[NSString stringWithFormat:@"%ld",self.pageNum] WithIsLoad:@"1" Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            NSDictionary *infoDic=[dic objectForKey:@"kehu"];
            NSArray *dddAry=[infoDic objectForKey:@"infoList"];
            if (dddAry.count>0) {
                
                if (self.pageNum==1) {
                    [self.dataAry removeAllObjects];
                    [self.dataAry addObjectsFromArray:dddAry];
                    [self.tableView reloadData];
                }else{
                    NSDictionary *oldDic=[self.dataAry lastObject];
                    NSDictionary *newDic=[dddAry lastObject];
                    NSString *oldStr=[oldDic objectForKey:@"uid"];
                    NSString *newStr=[newDic objectForKey:@"uid"];
                    if ([newStr isEqualToString:oldStr]) {
                       [ToastView showTopToast:@"已无更多信息"];
                        self.pageNum-=1;
                        if (self.pageNum<=1) {
                            self.pageNum=1;
                        }
                    }else{
                      [self.dataAry addObjectsFromArray:dddAry];
                        [self.tableView reloadData];
                    }
                }
            }else{
                [ToastView showTopToast:@"已无更多信息"];
                self.pageNum-=1;
                if (self.pageNum<=1) {
                    self.pageNum=1;
                }
            }
          
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    } failure:^(NSError *error) {
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLDKeFuTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDKeFuTableViewCell"];
    if (!cell) {
        cell=[YLDKeFuTableViewCell yldKeFuTableViewCell];
        cell.delegate=self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.messageDic=self.dataAry[indexPath.row];
    return cell;
}
-(UIView *)normalViewWithDic:(NSDictionary *)normalDic
{
    UIView *normalView =[[UIView alloc]initWithFrame:CGRectMake(0, 200, kWidth, kHeight-170)];
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 5, kWidth, 50)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    UIImageView *phoneLogoV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    [phoneLogoV setImage:[UIImage imageNamed:@"kefuphone"]];
    [view1 addSubview:phoneLogoV];
    UILabel *phoneNameLab=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 130, 30)];
    [phoneNameLab setFont:[UIFont systemFontOfSize:15]];
    [phoneNameLab setTextColor:titleLabColor];
    [phoneNameLab setText:@"客服电话"];
    [view1 addSubview:phoneNameLab];
    UILabel *phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-130, 10, 120, 30)];
    [phoneLab setTextColor:detialLabColor];
    [phoneLab setFont:[UIFont systemFontOfSize:14]];
    [phoneLab setTextAlignment:NSTextAlignmentRight];
    phoneLab.text=[normalDic objectForKey:@"phone"];
    self.phoneStr=[normalDic objectForKey:@"phone"];
    [view1 addSubview:phoneLab];
    
    [normalView addSubview:view1];
    
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0, 65, kWidth, 50)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    UIImageView *weixinLogoV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    [weixinLogoV setImage:[UIImage imageNamed:@"kefuweixin"]];
    [view2 addSubview:weixinLogoV];
    UILabel *weixinNameLab=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 130, 30)];
    [weixinNameLab setFont:[UIFont systemFontOfSize:15]];
    [weixinNameLab setTextColor:titleLabColor];
    [weixinNameLab setText:@"客服微信号"];
    [view2 addSubview:weixinNameLab];
    UILabel *weixinLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-130, 10, 120, 30)];
    [weixinLab setTextColor:detialLabColor];
    weixinLab.text=[normalDic objectForKey:@"weixin"];
    [weixinLab setFont:[UIFont systemFontOfSize:14]];
    [weixinLab setTextAlignment:NSTextAlignmentRight];
    [view2 addSubview:weixinLab];
    
    [normalView addSubview:view2];
    
    UIButton *phoneBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2-55, 130, 110, 25)];
    [phoneBtn setImage:[UIImage imageNamed:@"callkefuBtn"] forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(phoneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [phoneBtn addTarget:self action:@selector(phoneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [normalView addSubview:phoneBtn];
    UIButton *bangzhuBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2-55, 165, 110, 25)];
    [bangzhuBtn addTarget:self action:@selector(bangzhuBtnAciotn:) forControlEvents:UIControlEventTouchUpInside];
    [bangzhuBtn setImage:[UIImage imageNamed:@"shiyongbangzhu"] forState:UIControlStateNormal];
    [normalView addSubview:bangzhuBtn];
    
    [self.view addSubview:normalView];
    return normalView;
}
-(void)bangzhuBtnAciotn:(UIButton *)sender
{
    YLDUserHelpViewController *lydUserHelpVC=[[YLDUserHelpViewController alloc]init];
    [self.navigationController pushViewController:lydUserHelpVC animated:YES];
}
-(void)phoneBtnAction:(UIButton *)sender
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.phoneStr];
    //NSLog(@"str======%@",[[self.infoDic objectForKey:@"detail"] objectForKey:@"phone"]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)senderMessageWithDic:(NSDictionary *)dic
{
    NSString *messageStr=[dic  objectForKey:@"message"];

    
    [self showMessageView:[NSArray arrayWithObjects:[dic  objectForKey:@"phone"], nil] title:@"客服短信" body:messageStr];
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
   // [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
        {
            [ToastView showTopToast:@"消息发送成功"];
        }
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
        {
            //[ToastView showToast:@"消息发送失败" withOriginY:250 withSuperView:self.view];
            [ToastView showTopToast:@"消息发送失败"];
        }
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
        {
            //[ToastView showToast:@"取消发送" withOriginY:250 withSuperView:self.view];
            [ToastView showTopToast:@"取消发送"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
