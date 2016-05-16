//
//  FaBuViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/15.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "FaBuViewController.h"
#import "UIDefines.h"
#import "buyFabuViewController.h"
#import "ZIKSupplyPublishVC.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
#import "BuyMessageAlertView.h"
#import "NuseryDetialViewController.h"
#import "HttpClient.h"
@interface FaBuViewController ()

@end

@implementation FaBuViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    HttpClient *httpClient=[HttpClient sharedClient];
    //供求发布限制
    ShowActionV();
    [httpClient getSupplyRestrictWithToken:APPDELEGATE.userModel.access_token  withId:APPDELEGATE.userModel.access_id withClientId:nil withClientSecret:nil withDeviceId:nil withType:@"1" success:^(id responseObject) {
        RemoveActionV();
        NSDictionary *dic=[responseObject objectForKey:@"result"];
        if ( [dic[@"count"] integerValue] == 0) {// “count”: 1	--当数量大于0时，表示可发布；等于0时，不可发布
            APPDELEGATE.isCanPublishBuy = NO;
            BuyMessageAlertView *buyMessageAlertV=[BuyMessageAlertView addActionViewMiaoPuWanShan];
            [buyMessageAlertV.rightBtn addTarget:self action:@selector(miaopudetialAction) forControlEvents:UIControlEventTouchUpInside];
            return;
        }
        else {
            APPDELEGATE.isCanPublishBuy = YES;
        }
    } failure:^(NSError *error) {
        RemoveActionV();
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     UIView *navView=[self makeNavView];
    [self.view addSubview:navView];
    [self.view setBackgroundColor:BGColor];
    UIView *backview=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 100)];
    [self.view addSubview:backview];
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 100)];
    view1.center=CGPointMake(kWidth/4.f, 50);
    [backview setBackgroundColor:[UIColor whiteColor]];
    [backview addSubview:view1];
    UIImageView *imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(10, 25, 50, 50)];
    [imageView1 setImage:[UIImage imageNamed:@"supplyImageV"]];
    [view1 addSubview:imageView1];
    UILabel *titleLab1=[[UILabel alloc]initWithFrame:CGRectMake(72, 27, 70, 20)];
    UIButton *supplyBtn=[[UIButton alloc]initWithFrame:view1.bounds];
    [supplyBtn addTarget:self action:@selector(fabuSupplyMessage) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:supplyBtn];
    [titleLab1 setTextColor:NavColor];
    [titleLab1 setText:@"发布供应"];
    [view1 addSubview:titleLab1];
    UILabel *detialLab1=[[UILabel alloc]initWithFrame:CGRectMake(70, 50, 80, 40)];
    detialLab1.numberOfLines=2;
    [detialLab1 setTextColor:detialLabColor];
    [detialLab1 setFont:[UIFont systemFontOfSize:13]];
    detialLab1.text = @"填写您要出售的苗木种类";
    [view1 addSubview:detialLab1];
    UIImageView *lineImageV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2, 20, 0.5, 60)];
    [lineImageV setBackgroundColor:kLineColor];
    [backview addSubview:lineImageV];
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 100)];
    view2.center=CGPointMake(kWidth/4.f*3, 50);
    [backview addSubview:view2];
    UIButton *buyBtn=[[UIButton alloc]initWithFrame:view2.bounds];
    [buyBtn addTarget:self action:@selector(fabuBuyMessage) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:buyBtn];
    UIImageView *imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(10, 25, 50, 50)];
    [imageView2 setImage:[UIImage imageNamed:@"buyImageV"]];
    [view2 addSubview:imageView2];
    UILabel *titleLab2=[[UILabel alloc]initWithFrame:CGRectMake(72, 27, 70, 20)];
    [titleLab2 setTextColor:[UIColor colorWithRed:246/255.f green:192/255.f blue:115/255.f alpha:1]];
    [titleLab2 setText:@"发布求购"];
    [view2 addSubview:titleLab2];
    UILabel *detialLab2=[[UILabel alloc]initWithFrame:CGRectMake(70, 50, 80, 40)];
    detialLab2.numberOfLines=2;
    [detialLab2 setTextColor:detialLabColor];
    [detialLab2 setFont:[UIFont systemFontOfSize:13]];
    detialLab2.text = @"填写您需要的苗木种类";
    [view2 addSubview:detialLab2];
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
    [titleLab setText:@"选择发布类型"];
    [titleLab setFont:[UIFont systemFontOfSize:NavTitleSize]];
    [view addSubview:titleLab];
    return view;
}
-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)fabuSupplyMessage
{
    if (APPDELEGATE.isCanPublishBuy==NO)
    {
        [ToastView showTopToast:@"您还没有供应发布权限,请先完善苗圃信息"];
        NuseryDetialViewController *nuseryDetialVC=[[NuseryDetialViewController alloc]init];
        [self.navigationController pushViewController:nuseryDetialVC animated:YES];
        return;
    }
    ZIKSupplyPublishVC *supplyLishVC=[[ZIKSupplyPublishVC alloc]init];
    [self.navigationController pushViewController:supplyLishVC animated:YES];
}
-(void)fabuBuyMessage
{
   
    if (APPDELEGATE.isCanPublishBuy==NO)
    {
        [ToastView showTopToast:@"您还没有求购发布权限,请先完善苗圃信息"];
        NuseryDetialViewController *nuseryDetialVC=[[NuseryDetialViewController alloc]init];
        [self.navigationController pushViewController:nuseryDetialVC animated:YES];
        return;
    }
        buyFabuViewController *fabuVC=[[buyFabuViewController alloc]init];
        [self.navigationController pushViewController:fabuVC animated:YES];
}
-(void)miaopudetialAction
{
   
    NuseryDetialViewController *nuseryDetialVC=[[NuseryDetialViewController alloc]init];
    [self.navigationController pushViewController:nuseryDetialVC animated:YES];
     [BuyMessageAlertView removeActionView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
