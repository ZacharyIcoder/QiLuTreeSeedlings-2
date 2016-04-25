//
//  BaseTabBarController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/1/28.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "BaseTabBarController.h"
#import "UINavController.h"
#import "HomePageTViewController.h"
#import "UserCenterViewController.h"
#import "UIDefines.h"
#import "LoginViewController.h"
#define kTABBARH 50
@interface BaseTabBarController ()
@property UIView *BTabBar;
@property BOOL TabBarHiden;

@end

@implementation BaseTabBarController


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.TabBarHiden=NO;
    [self MakeUI];
    //添加隐藏和显示自定义标签栏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenTabBar) name:@"HidenTabBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabBar) name:@"showTabBar" object:nil];
//    UIButton
    // Do any additional setup after loading the view.
}
//隐藏标签栏
-(void)hidenTabBar
{
    if (self.TabBarHiden==NO) {
        self.TabBarHiden=YES;
        self.BTabBar.hidden=YES;
    }
}

-(void)showTabBar
{
    if (self.TabBarHiden==YES) {
        self.TabBarHiden=NO;
        self.BTabBar.hidden=NO;
    }
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
    self.homePageBtn=PageViewBtn;
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
    self.homePageLab=hompageLab;
    [self.BTabBar addSubview:hompageLab];
     [self.BTabBar addSubview:pageActionBtn];
    
    UIButton *UserViewBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-(kWidth-34*3)/6-44, 3, 28, 28)];
    self.userInfoBtn=UserViewBtn;
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
    self.userLab=userLab;
    [self.BTabBar addSubview:userLab];
    [self.BTabBar addSubview:userActionBtn];

    UIButton *fabuBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2-25, -5, 50, 50)];
    [fabuBtn setImage:[UIImage imageNamed:@"fabuBTN"] forState:UIControlStateNormal];
    [fabuBtn addTarget:self action:@selector(FaBuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.BTabBar addSubview:fabuBtn];
    
    HomePageTViewController *homePageVC=[[HomePageTViewController alloc]init];
    UINavController *homePageNav=[[UINavController alloc]initWithRootViewController:homePageVC];
    
    UserCenterViewController *userCenterVC=[[UserCenterViewController alloc]init];
    UINavController *userCenterNav=[[UINavController alloc]initWithRootViewController:userCenterVC];
    
    self.viewControllers=@[homePageNav,userCenterNav];
}
//标签栏的用户和首页的按钮点击
-(void)ButtonSelect:(UIButton *)sender
{
    if (sender.tag==1) {
        self.selectedIndex=0;
        self.homePageBtn.selected=YES;
        [self.homePageLab setTextColor:NavColor];
        [self.userLab setTextColor:[UIColor lightGrayColor]];
        self.userInfoBtn.selected=NO;
    }else
    {
//        if (![APPDELEGATE isNeedLogin]) {
//            LoginViewController *loginViewController=[[LoginViewController alloc]init];
//            
//            UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
//            
//            [self presentViewController:navVC animated:YES completion:^{
//                
//            }];
//            return;
       // }
        [self.userLab setTextColor:NavColor];
        [self.homePageLab setTextColor:[UIColor lightGrayColor]];
        self.selectedIndex=1;
        self.userInfoBtn.selected=YES;
        self.homePageBtn.selected=NO;
    }

}
//发布按钮的点击
-(void)FaBuButtonAction:(UIButton *)sender
{
   // NSLog(@"%ld",(long)sender.tag);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"fabuBtnAction" object:nil];
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
