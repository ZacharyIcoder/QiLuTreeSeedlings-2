//
//  SettingViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/4/7.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"设置";
     UIButton *yijianBTN=[self creatViewWithTitle:@"意见反馈" andY:70];
    [yijianBTN addTarget:self action:@selector(yijianfankuiBtn) forControlEvents:UIControlEventTouchUpInside];
     UIButton *abuotUS = [self creatViewWithTitle:@"关于我们" andY:119.5];
    [abuotUS addTarget:self action:@selector(abountUSBtn) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
-(void)yijianfankuiBtn
{
     NSLog(@"意见反馈");
}
-(void)abountUSBtn
{
    NSLog(@"关于我们");
}
-(UIButton *)creatViewWithTitle:(NSString *)title andY:(CGFloat)Y
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, Y, kWidth, 50)];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.layer.masksToBounds=YES;
    view.layer.borderColor=kLineColor.CGColor;
    view.layer.borderWidth=0.5;
    UIButton *btn=[[UIButton alloc]initWithFrame:view.bounds];
    [btn setTitleColor:titleLabColor forState:UIControlStateNormal];
    [view addSubview:btn];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];

    [self.view addSubview:view];
        return btn;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
