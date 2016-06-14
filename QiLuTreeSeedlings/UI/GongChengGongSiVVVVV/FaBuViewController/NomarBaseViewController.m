//
//  NomarBaseViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/14.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "NomarBaseViewController.h"
#import "UIDefines.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
#define titleFont [UIFont systemFontOfSize:20]
@interface NomarBaseViewController ()
@property (nonatomic,strong) UILabel *titleLab;
@end

@implementation NomarBaseViewController
@synthesize titleLab;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBackView =[self makeNavView];
    [self.view addSubview:self.navBackView];
    // Do any additional setup after loading the view.
}
-(UIView *)makeNavView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, 64)];
    [view setBackgroundColor:NavYellowColor];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(17, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdgeWithTop:15 right:30 bottom:10 left:10];
    [view addSubview:backBtn];
    self.backBtn=backBtn;
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-80,26, 160, 30)];
    [titleLab setTextColor:[UIColor whiteColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setFont:titleFont];
    [view addSubview:titleLab];
    return view;
}
-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setVcTitle:(NSString *)vcTitle {
    _vcTitle = vcTitle;
    titleLab.text = vcTitle;
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
