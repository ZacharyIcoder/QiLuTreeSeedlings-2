//
//  KeFuViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/31.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "KeFuViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
@interface KeFuViewController ()
@property (nonatomic,strong)UILabel *nameLab;
@property (nonatomic,copy) NSString *phoneStr;
@end

@implementation KeFuViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"客服系统";
    UIView *topview=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth,130-64)];
    [topview setBackgroundColor:NavColor];
    [self.view addSubview:topview];
    UIImageView *iamgeV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2-30, topview.frame.size.height-30, 60,60)];
    [iamgeV setImage:[UIImage imageNamed:@"kefutouxiang"]];
    [topview addSubview:iamgeV];
    UILabel* ZZZlAB=[[UILabel alloc]initWithFrame:CGRectMake(0, 130+35, kWidth, 30)];
    [ZZZlAB setFont:[UIFont systemFontOfSize:14]];
    [ZZZlAB setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:ZZZlAB];
    self.nameLab=ZZZlAB;
    
    [HTTPCLIENT kefuXiTongWithPage:@"1" WithPageNumber:@"15" WithIsLoad:@"0" Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            NSInteger type=[[dic objectForKey:@"type"] integerValue];
            if (type==2) {
                NSDictionary *dic2=[dic objectForKey:@"kehu"];
                self.nameLab.text=[dic2 objectForKey:@"name"];
                [self normalViewWithDic:dic2];
            }
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
