//
//  ZIKArrowViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/22.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKArrowViewController.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
#define titleFont [UIFont systemFontOfSize:20]
@interface ZIKArrowViewController ()
{
    UILabel *titleLab;
}
@end

@implementation ZIKArrowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self initNav];
    self.navBackView =[self makeNavView];
    [self.view addSubview:self.navBackView];
    
}
-(UIView *)makeNavView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, 64)];
    [view setBackgroundColor:NavColor];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(17, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdgeWithTop:15 right:60 bottom:10 left:10];
    [view addSubview:backBtn];
    self.backBtn=backBtn;
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-100,26, 200, 30)];
    [titleLab setTextColor:[UIColor whiteColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    //[titleLab setText:self.vcTitle];
    //titleLab.text = self.vcTitle;
    [titleLab setFont:titleFont];
    [view addSubview:titleLab];
    return view;
}

-(void)setVcTitle:(NSString *)vcTitle {
    _vcTitle = vcTitle;
    titleLab.text = vcTitle;
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
