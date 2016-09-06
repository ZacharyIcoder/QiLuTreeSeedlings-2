//
//  ZIKMiaoQiTabBarViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/5.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMiaoQiTabBarViewController.h"

#import "ZIKHeZuoMiaoQiViewController.h"//合作苗企
#import "ZIKMiaoQiGongYingViewController.h"//苗企供应
#import "ZIKMiaoQiQiuGouViewController.h"//苗企求购
#import "ZIKMiaoQiZhongXinTableViewController.h"//苗企中心
@interface ZIKMiaoQiTabBarViewController ()

@end

@implementation ZIKMiaoQiTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backHome) name:@"ZIKMiaoQiBackHome" object:nil];


    //合作苗企
    ZIKHeZuoMiaoQiViewController *orderVC = [[ZIKHeZuoMiaoQiViewController alloc] initWithNibName:@"ZIKHeZuoMiaoQiViewController" bundle:nil];
    UINavigationController *orderNav = [[UINavigationController alloc] initWithRootViewController:orderVC];
    orderNav.viewControllers = @[orderVC];
    orderNav.tabBarItem.enabled = YES;
    orderVC.vcTitle = @"合作苗企";
    orderVC.tabBarItem.title = @"合作苗企";
    orderVC.navigationController.navigationBar.hidden = YES;
    orderVC.tabBarItem.image = [[UIImage imageNamed:@"底部菜单-合作苗企off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    orderVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"底部菜单-合作苗企点击on"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    //苗企供应
    ZIKMiaoQiGongYingViewController *buyVC = [[ZIKMiaoQiGongYingViewController alloc] initWithNibName:@"ZIKMiaoQiGongYingViewController" bundle:nil];
    UINavigationController *buyNav = [[UINavigationController alloc] initWithRootViewController:buyVC];
    buyNav.viewControllers = @[buyVC];
    buyNav.tabBarItem.enabled = YES;
    buyVC.vcTitle = @"苗企供应";
    buyVC.tabBarItem.title = @"苗企供应";
    buyVC.navigationController.navigationBar.hidden = YES;
    buyVC.tabBarItem.image = [[UIImage imageNamed:@"底部菜单-苗企供应off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    buyVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"底部菜单-苗企供应on"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];


    //苗企求购
    ZIKMiaoQiQiuGouViewController *workVC = [[ZIKMiaoQiQiuGouViewController alloc] initWithNibName:@"ZIKMiaoQiQiuGouViewController" bundle:nil];
    UINavigationController *workNav = [[UINavigationController alloc] initWithRootViewController:workVC];
    workNav.viewControllers = @[workVC];
    workNav.tabBarItem.enabled = YES;
    workVC.vcTitle = @"苗企求购";
    workVC.tabBarItem.title = @"苗企求购";
    workVC.navigationController.navigationBar.hidden = YES;
    workVC.tabBarItem.image = [[UIImage imageNamed:@"底部菜单-苗企求购off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    workVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"底部菜单-苗企求购on"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    //苗企中心
    ZIKMiaoQiZhongXinTableViewController *stationVC = [[ZIKMiaoQiZhongXinTableViewController alloc] initWithNibName:@"ZIKMiaoQiZhongXinTableViewController" bundle:nil];
    UINavigationController *stationNav = [[UINavigationController alloc] initWithRootViewController:stationVC];
    stationNav.viewControllers  = @[stationVC];
    stationNav.tabBarItem.enabled = YES;
    //    stationVC.vcTitle = @"站长中心";
    stationVC.tabBarItem.title = @"站长中心";
    stationVC.navigationController.navigationBar.hidden = YES;

    stationVC.tabBarItem.image = [[UIImage imageNamed:@"底部菜单-工程中心off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    stationVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部菜单-工程中心On"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];


    NSMutableArray *list = [[NSMutableArray alloc] initWithObjects:orderNav,buyNav,workNav,stationNav,nil];
    self.viewControllers = list;

    UIColor *normalColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       normalColor,           NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Helvetica" size:12.0], NSFontAttributeName,
                                                       nil] forState:UIControlStateNormal];
    // UIColor *titleHighlightedColor = [UIColor colorWithRed:43/255.0 green:41/255.0 blue:56/255.0 alpha:1];
    UIColor *titleHighlightedColor = NavColor;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Helvetica" size:12.0], NSFontAttributeName,
                                                       nil] forState:UIControlStateSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backHome {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ZIKMiaoQiBackHome" object:nil];
}

@end
