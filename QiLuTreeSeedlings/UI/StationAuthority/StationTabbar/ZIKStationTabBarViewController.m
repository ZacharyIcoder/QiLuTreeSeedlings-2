//
//  ZIKStationTabBarViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationTabBarViewController.h"

#import "ZIKOrderViewController.h"             //工程订单
#import "ZIKStationBuyViewController.h"        //站长求购
#import "ZIKWorkstationViewController.h"       //工作站
#import "ZIKMyOfferViewController.h"           //我的报价
#import "ZIKStationCenterTableViewController.h"//站长中心

#import "ZIKHelpfulHintsViewController.h"

@interface ZIKStationTabBarViewController ()<UITabBarControllerDelegate>
{
    BOOL _isTiao;
}
@property(readonly, nonatomic) NSUInteger lastSelectedIndex;

@end

@implementation ZIKStationTabBarViewController

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    _isTiao = YES;
    //获得选中的item
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
    if (tabIndex != self.selectedIndex) {
        //设置最近一次变更
        _lastSelectedIndex = self.selectedIndex;
        //        CLog(@"2 OLD:%lu , NEW:%lu",(unsigned long)self.lastSelectedIndex,(unsigned long)tabIndex);
    }
    if (tabIndex == 3 || tabIndex == 4) {
        if (APPDELEGATE.userModel.goldsupplierStatus == 5 || APPDELEGATE.userModel.goldsupplierStatus == 6) {
            _isTiao = YES;//是苗企，可以进入苗企中心
        } else {
            _isTiao = NO;//不是苗企，不可进入苗企中心
            ZIKHelpfulHintsViewController *helpfulVC = [[ZIKHelpfulHintsViewController alloc] initWithNibName:@"ZIKHelpfulHintsViewController" bundle:nil];
            helpfulVC.qubie = @"站长中心";
            [self.navigationController pushViewController:helpfulVC animated:YES];
        }
    }
}

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
    orderVC.tabBarItem.image = [[UIImage imageNamed:@"底部菜单-工程订单off(1)"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    orderVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"底部菜单-工程订单on(1)"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    //站长求购
    ZIKStationBuyViewController *buyVC = [[ZIKStationBuyViewController alloc] initWithNibName:@"ZIKStationBuyViewController" bundle:nil];
    UINavigationController *buyNav = [[UINavigationController alloc] initWithRootViewController:buyVC];
    buyNav.viewControllers = @[buyVC];
    buyNav.tabBarItem.enabled = YES;
    buyVC.vcTitle = @"站长求购";
    buyVC.tabBarItem.title = @"站长求购";
    buyVC.navigationController.navigationBar.hidden = YES;
    buyVC.tabBarItem.image = [[UIImage imageNamed:@"底部菜单-站长求购off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    buyVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"底部菜单-站长求购on"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];


    //工作站
    ZIKWorkstationViewController *workVC = [[ZIKWorkstationViewController alloc] init];
    UINavigationController *workNav = [[UINavigationController alloc] initWithRootViewController:workVC];
    workNav.viewControllers = @[workVC];
    workNav.tabBarItem.enabled = YES;
    workVC.vcTitle = @"工作站";
    workVC.tabBarItem.title = @"工作站";
    workVC.navigationController.navigationBar.hidden = YES;
    workVC.tabBarItem.image = [[UIImage imageNamed:@"底部菜单-工作站off(1)"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    workVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"底部菜单-工作站on(2)"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    //我的报价
    ZIKMyOfferViewController *offerVC = [[ZIKMyOfferViewController alloc] init];
    UINavigationController *offerNav = [[UINavigationController alloc] initWithRootViewController:offerVC];
    offerNav.viewControllers = @[offerVC];
    offerNav.tabBarItem.enabled = YES;
    offerVC.vcTitle = @"我的报价";
    offerVC.tabBarItem.title = @"我的报价";
    offerVC.navigationController.navigationBar.hidden = YES;
    offerVC.tabBarItem.image = [[UIImage imageNamed:@"底部菜单-我的报价off(1)"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    offerVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"底部菜单-我的报价on(1)"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    //站长中心
    ZIKStationCenterTableViewController *stationVC = [[ZIKStationCenterTableViewController alloc] init];
    UINavigationController *stationNav = [[UINavigationController alloc] initWithRootViewController:stationVC];
    stationNav.viewControllers  = @[stationVC];
    stationNav.tabBarItem.enabled = YES;
//    stationVC.vcTitle = @"站长中心";
    stationVC.tabBarItem.title = @"站长中心";
    stationVC.navigationController.navigationBar.hidden = YES;

    stationVC.tabBarItem.image = [[UIImage imageNamed:@"底部菜单-站长中心off(1)"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    stationVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部菜单-站长中心on(1)"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];


    NSMutableArray *list = [[NSMutableArray alloc] initWithObjects:workNav,buyNav,orderVC,offerNav,stationNav,nil];
    self.viewControllers = list;
    self.delegate = self;
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

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return _isTiao;
}

@end
