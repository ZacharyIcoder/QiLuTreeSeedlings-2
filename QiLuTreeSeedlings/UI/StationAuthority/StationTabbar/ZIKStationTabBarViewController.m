//
//  ZIKStationTabBarViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationTabBarViewController.h"
#import "ZIKOrderViewController.h"        //工程订单
#import "ZIKWorkstationViewController.h"  //工作站
#import "ZIKMyOfferViewController.h"      //我的报价
#import "ZIKStationCenterViewController.h"//站长中心


@interface ZIKStationTabBarViewController ()

@end

@implementation ZIKStationTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backHome) name:@"ZIKBackHome" object:nil];

    //工程订单
    ZIKOrderViewController *orderVC = [[ZIKOrderViewController alloc] init];
    UINavigationController *orderNav = [[UINavigationController alloc] initWithRootViewController:orderVC];
    orderNav.viewControllers = @[orderVC];
    orderNav.tabBarItem.enabled = YES;
    orderVC.vcTitle = @"工程订单";
    orderVC.tabBarItem.title = @"工程订单";
    orderVC.navigationController.navigationBar.hidden = YES;
    orderVC.tabBarItem.image = [[UIImage imageNamed:@"底部菜单-工程订单off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    orderVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"底部菜单-工程订单on"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];


    //工作站
    ZIKWorkstationViewController *workVC = [[ZIKWorkstationViewController alloc] init];
    UINavigationController *workNav = [[UINavigationController alloc] initWithRootViewController:workVC];
    workNav.viewControllers = @[workVC];
    workNav.tabBarItem.enabled = YES;
    workVC.vcTitle = @"工作站";
    workVC.tabBarItem.title = @"工作站";
    workVC.navigationController.navigationBar.hidden = YES;
    workVC.tabBarItem.image = [[UIImage imageNamed:@"底部菜单-工作站off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    workVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"底部菜单-工作站on"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    //我的报价
    ZIKMyOfferViewController *offerVC = [[ZIKMyOfferViewController alloc] init];
    UINavigationController *offerNav = [[UINavigationController alloc] initWithRootViewController:offerVC];
    offerNav.viewControllers = @[offerVC];
    offerNav.tabBarItem.enabled = YES;
    offerVC.vcTitle = @"我的报价";
    offerVC.tabBarItem.title = @"我的报价";
    offerVC.navigationController.navigationBar.hidden = YES;
    offerVC.tabBarItem.image = [[UIImage imageNamed:@"底部菜单-我的报价off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    offerVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"底部菜单-我的报价on"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    //站长中心
    ZIKStationCenterViewController *stationVC = [[ZIKStationCenterViewController alloc] init];
    UINavigationController *stationNav = [[UINavigationController alloc] initWithRootViewController:stationVC];
    stationNav.viewControllers  = @[stationVC];
    stationNav.tabBarItem.enabled = YES;
    stationVC.vcTitle = @"站长中心";
    stationVC.tabBarItem.title = @"站长中心";
    stationVC.navigationController.navigationBar.hidden = YES;

    stationVC.tabBarItem.image = [[UIImage imageNamed:@"底部菜单-站长中心off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    stationVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部菜单-站长中心on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];


    NSMutableArray *list = [[NSMutableArray alloc] initWithObjects:orderNav,workNav,offerNav,stationNav,nil];
    self.viewControllers = list;

    UIColor *normalColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       normalColor,           NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName,
                                                       nil] forState:UIControlStateNormal];
    // UIColor *titleHighlightedColor = [UIColor colorWithRed:43/255.0 green:41/255.0 blue:56/255.0 alpha:1];
    UIColor *titleHighlightedColor = NavColor;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName,
                                                       nil] forState:UIControlStateSelected];
}

- (void)backHome {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ZIKBackHome" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
