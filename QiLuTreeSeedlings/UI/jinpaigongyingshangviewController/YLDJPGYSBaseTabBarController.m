//
//  YLDJPGYSBaseTabBarController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/8.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDJPGYSBaseTabBarController.h"
#import "YLDJPGYSListViewController.h"
#import "YLDJinPaiGYViewController.h"
#import "ZIKMyOfferViewController.h"
#import "ZIKOrderViewController.h"
#import "UINavController.h"
@interface YLDJPGYSBaseTabBarController ()

@end

@implementation YLDJPGYSBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backHome) name:@"ZIKBackHome" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backHome) name:@"YLDBackMiaoXinTong" object:nil];
    //金牌供应商
    YLDJPGYSListViewController *JPGYSListVC = [[YLDJPGYSListViewController alloc] init];
    UINavigationController *JPGYSListNav = [[UINavigationController alloc] initWithRootViewController:JPGYSListVC];
    //JPGYSListNav.viewControllers = @[JPGYSListVC];
//    JPGYSListNav.tabBarItem.enabled = YES;
    JPGYSListVC.vcTitle = @"金牌供应商";
    JPGYSListVC.tabBarItem.title = @"金牌供应商";
    JPGYSListVC.navigationController.navigationBar.hidden = YES;
    JPGYSListVC.tabBarItem.image = [[UIImage imageNamed:@"底部菜单金牌供应商off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    JPGYSListVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"底部菜单金牌供应商on"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //金牌供应
    YLDJinPaiGYViewController *jinpaigongyingVC=[[YLDJinPaiGYViewController alloc]init];
    UINavigationController *JPGYListNav = [[UINavigationController alloc] initWithRootViewController:jinpaigongyingVC];
  
    JPGYListNav.tabBarItem.enabled = YES;
    jinpaigongyingVC.vcTitle = @"金牌供应";
    jinpaigongyingVC.tabBarItem.title = @"金牌供应";
    jinpaigongyingVC.navigationController.navigationBar.hidden = YES;
    jinpaigongyingVC.tabBarItem.image = [[UIImage imageNamed:@"底部菜单-站长供应off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    jinpaigongyingVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"底部菜单-站长供应On"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
 
 
    //我的报价
    ZIKMyOfferViewController *offerVC = [[ZIKMyOfferViewController alloc] init];
    UINavController *offerNav = [[UINavController alloc] initWithRootViewController:offerVC];
    offerNav.viewControllers = @[offerVC];
    offerNav.tabBarItem.enabled = YES;
    offerVC.vcTitle = @"我的报价";
    offerVC.title = @"我的报价";
    offerVC.navigationController.navigationBar.hidden = YES;
    offerVC.tabBarItem.image = [[UIImage imageNamed:@"底部菜单-报价管理Off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    offerVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"底部菜单-报价管理On"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [offerVC.navView setBackgroundColor:NavYellowColor];
    
    //金牌订单
        ZIKOrderViewController *orderVC = [[ZIKOrderViewController alloc] init];
        UINavController *orderNav = [[UINavController alloc] initWithRootViewController:orderVC];
    orderVC.navigationController.navigationBar.hidden=YES;
    orderVC.title=@"金牌订单";
    orderVC.vcTitle=@"金牌订单";
    orderVC.tabBarItem.image = [[UIImage imageNamed:@"jpwodedingdanoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    orderVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"jpwodedingdanon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.viewControllers = @[JPGYSListNav,JPGYListNav,orderNav,offerNav];
    UIColor *normalColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       normalColor,           NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Helvetica" size:12.0], NSFontAttributeName,
                                                       nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = NavYellowColor;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Helvetica" size:12.0], NSFontAttributeName,
                                                       nil] forState:UIControlStateSelected];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backHome {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ZIKBackHome" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"YLDBackMiaoXinTong" object:nil];
    
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
