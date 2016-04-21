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
@interface FaBuViewController ()

@end

@implementation FaBuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [APPDELEGATE requestBuyRestrict];
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
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdgeWithTop:10 right:25 bottom:0 left:3];
    [view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-80,26, 160, 30)];
    [titleLab setTextColor:[UIColor whiteColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setText:@"选择发布类型"];
    [titleLab setFont:[UIFont systemFontOfSize:21]];
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
        [ToastView showTopToast:@"您没有求购发布权限"];
        return;
    }
    if ([APPDELEGATE isNeedCompany]==NO) {
        [ToastView showTopToast:@"请完善公司信息"];
        return;
    }
    ZIKSupplyPublishVC *supplyLishVC=[[ZIKSupplyPublishVC alloc]init];
    [self.navigationController pushViewController:supplyLishVC animated:YES];
}
-(void)fabuBuyMessage
{
    if (APPDELEGATE.isCanPublishBuy==NO)
    {
        [ToastView showTopToast:@"您没有求购发布权限"];
        return;
    }
    if ([APPDELEGATE isNeedCompany]==NO) {
        [ToastView showTopToast:@"请完善公司信息"];
        return;
    }
        buyFabuViewController *fabuVC=[[buyFabuViewController alloc]init];
        [self.navigationController pushViewController:fabuVC animated:YES];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
