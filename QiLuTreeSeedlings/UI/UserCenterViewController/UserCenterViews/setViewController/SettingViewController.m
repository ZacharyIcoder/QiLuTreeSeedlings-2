//
//  SettingViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/4/7.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "SettingViewController.h"
#import "AbountUsViewController.h"
#import "YLDFeedbackViewController.h"
#import "ToastView.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"设置";
     UIButton *yijianBTN=[self creatViewWithTitle:@"意见反馈" andY:70];
    [yijianBTN addTarget:self action:@selector(yijianfankuiBtn:) forControlEvents:UIControlEventTouchUpInside];
     UIButton *abuotUS = [self creatViewWithTitle:@"关于我们" andY:119.5];
    [abuotUS addTarget:self action:@selector(abountUSBtn:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
-(void)yijianfankuiBtn:(UIButton *)button
{
    if ([APPDELEGATE isNeedLogin]) {
        YLDFeedbackViewController *feedbackVC=[[YLDFeedbackViewController alloc]init];
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }else{
        [ToastView showTopToast:@"请先登录"];
    }
 
}

-(void)abountUSBtn:(UIButton *)button
{
    button.backgroundColor = [UIColor lightGrayColor];
    double delayInSeconds = 0.05;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        button.backgroundColor = [UIColor whiteColor];
    });

    //NSLog(@"关于我们");
    AbountUsViewController *abountUnsVC=[[AbountUsViewController alloc]init];
    [self.navigationController pushViewController:abountUnsVC animated:YES];
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
    [btn setTitleColor:detialLabColor forState:UIControlStateHighlighted];
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
