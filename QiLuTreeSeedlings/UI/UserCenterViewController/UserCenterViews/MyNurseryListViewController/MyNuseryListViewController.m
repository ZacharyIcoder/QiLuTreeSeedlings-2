//
//  MyNuseryListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/22.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "MyNuseryListViewController.h"
#import "UIDefines.h"
#import "PullTableView.h"
@interface MyNuseryListViewController ()
@property (nonatomic,strong) PullTableView *pullTableView;
@end

@implementation MyNuseryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *navView=[self makeNavView];
    [self.view addSubview:navView];
    // Do any additional setup after loading the view.
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
    [titleLab setText:@"企业信息"];
    [titleLab setFont:[UIFont systemFontOfSize:15]];
    
    UIButton *editingBtnz=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-60, 26, 50, 30)];
    [editingBtnz setTitle:@"编辑" forState:UIControlStateNormal];
    [editingBtnz setTitle:@"取消" forState:UIControlStateSelected];
    [editingBtnz addTarget:self action:@selector(editingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
   // editingBtn=editingBtnz;
    [view addSubview:editingBtnz];
    [view addSubview:titleLab];
    return view;
}
-(void)editingBtnAction:(UIButton *)sender
{
   
}

-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
