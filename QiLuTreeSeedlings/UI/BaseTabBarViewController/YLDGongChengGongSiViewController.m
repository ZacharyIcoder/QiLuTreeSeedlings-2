//
//  YLDGongChengGongSiViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/1.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDGongChengGongSiViewController.h"
#import "UIDefines.h"
#define kTABBARH 50

@interface YLDGongChengGongSiViewController ()
@property UIView *BTabBar;
@property BOOL TabBarHiden;
@end

@implementation YLDGongChengGongSiViewController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.TabBarHiden=NO;
    //[self MakeUI];
    //添加隐藏和显示自定义标签栏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenTabBar) name:@"HidenTabBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabBar) name:@"showTabBar" object:nil];

    // Do any additional setup after loading the view.
}
//构建标签栏
- (void)MakeUI {
    //    CGFloat kWidth=[UIScreen mainScreen].bounds.size.width;
    //    CGFloat kheigh=[UIScreen mainScreen].bounds.size.height;
    CGFloat Height =[UIScreen mainScreen].bounds.size.height;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.BTabBar=[[UIView alloc]initWithFrame:CGRectMake(0, Height-kTABBARH, kWidth, kTABBARH)];
    [self.view addSubview:self.BTabBar];
    [self.BTabBar setBackgroundColor:[UIColor whiteColor]];
    self.tabBar.hidden=YES;
    UIImageView *tabMageV1=[[UIImageView alloc]initWithFrame:CGRectMake(0, -7, kWidth, 50)];
    [self.BTabBar addSubview:tabMageV1];
    [tabMageV1 setImage:[UIImage imageNamed:@"tabbarBackImage1"]];
    UIImageView *tabMageV2=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2-55, -7, 110, 50)];
    [tabMageV2 setImage:[UIImage imageNamed:@"tabbarBackImage2"]];
    [self.BTabBar addSubview:tabMageV2];
    
    //
    UIButton *PageViewBtn=[[UIButton alloc]initWithFrame:CGRectMake((kWidth-34*3)/6, 3, 28, 28)];
    PageViewBtn.tag=1;
    //self.homePageBtn=PageViewBtn;
    UIButton *pageActionBtn=[[UIButton alloc]initWithFrame:CGRectMake((kWidth-34*3)/6-30, 0, 90, 50)];
    pageActionBtn.tag=1;
    
    [pageActionBtn addTarget:self action:@selector(ButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [PageViewBtn setBackgroundImage:[UIImage imageNamed:@"homePageNomer"] forState:UIControlStateNormal];
    [PageViewBtn setBackgroundImage:[UIImage imageNamed:@"homePageGreen"] forState:UIControlStateSelected];
    PageViewBtn.selected=YES;
    [self.BTabBar addSubview:PageViewBtn];
    UILabel *hompageLab=[[UILabel alloc]initWithFrame:CGRectMake((kWidth-34*3)/6, 30, 30, 25)];
    [hompageLab setFont:[UIFont systemFontOfSize:12.5]];
    [hompageLab setTextAlignment:NSTextAlignmentCenter];
    [hompageLab setTextColor:NavColor];
    [hompageLab setText:@"首页"];
    //self.homePageLab=hompageLab;
    [self.BTabBar addSubview:hompageLab];
    [self.BTabBar addSubview:pageActionBtn];
    
    UIButton *UserViewBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-(kWidth-34*3)/6-44, 3, 28, 28)];
    //self.userInfoBtn=UserViewBtn;
    UIButton *userActionBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-(kWidth-34*3)/6-74, 0, 90,50)];
    userActionBtn.tag=2;
    
    [userActionBtn addTarget:self action:@selector(ButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    UserViewBtn.tag=2;
    // [UserViewBtn setBackgroundColor:[UIColor redColor]];
    [self.BTabBar addSubview:UserViewBtn];
    [UserViewBtn setBackgroundImage:[UIImage imageNamed:@"userInfoNomer"] forState:UIControlStateNormal];
    [UserViewBtn setBackgroundImage:[UIImage imageNamed:@"userInfoGreen"] forState:UIControlStateSelected];
    UILabel *userLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-(kWidth-34*3)/6-44-15, 30, 60, 25)];
    [userLab setFont:[UIFont systemFontOfSize:12.5]];
    [userLab setTextAlignment:NSTextAlignmentCenter];
    [userLab setTextColor:[UIColor lightGrayColor]];
    [userLab setText:@"个人中心"];
    //self.userLab=userLab;
    [self.BTabBar addSubview:userLab];
    [self.BTabBar addSubview:userActionBtn];
    
    UIButton *fabuBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2-25, -5, 50, 50)];
    [fabuBtn setImage:[UIImage imageNamed:@"fabuBTN"] forState:UIControlStateNormal];
    [fabuBtn addTarget:self action:@selector(FaBuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.BTabBar addSubview:fabuBtn];
    
}
-(void)FaBuButtonAction:(UIButton *)sender
{
    
}
//标签栏的用户和首页的按钮点击
-(void)ButtonSelect:(UIButton *)sender
{
    
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
