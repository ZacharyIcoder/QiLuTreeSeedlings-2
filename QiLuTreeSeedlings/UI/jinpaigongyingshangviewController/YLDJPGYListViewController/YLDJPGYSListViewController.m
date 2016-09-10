//
//  YLDJPGYSListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/8.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDJPGYSListViewController.h"
#import "HttpClient.h"
@interface YLDJPGYSListViewController ()

@end

@implementation YLDJPGYSListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"金牌供应商";
    
    // Do any additional setup after loading the view.
}
-(UIView *)cityView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 50)];
    UIButton *shengBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth/3, 50)];
    [shengBtn setTitle:@"全国" forState:UIControlStateNormal];
    [shengBtn setTitleColor:DarkTitleColor forState:UIControlStateNormal];
    [shengBtn setImage:[UIImage imageNamed:@"工程订单_排序off"] forState:UIControlStateNormal];
    [view addSubview:shengBtn];
    [self.view addSubview:view];
    return view;
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
