//
//  YLDBaseViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDBaseViewController.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
#define titleFont [UIFont systemFontOfSize:20]
@interface YLDBaseViewController ()
@property (nonatomic,strong) UILabel *titleLab;
@end

@implementation YLDBaseViewController
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
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(17, 26, 60, 30)];
     [backBtn setTitle:@"苗信通" forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YLDBackMiaoXinTong" object:nil];
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
