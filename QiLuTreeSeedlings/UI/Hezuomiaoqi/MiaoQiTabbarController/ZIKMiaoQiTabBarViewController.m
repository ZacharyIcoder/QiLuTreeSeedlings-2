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

#import "ZIKHelpfulHintsViewController.h"
@interface ZIKMiaoQiTabBarViewController ()<UITabBarControllerDelegate>
{
    BOOL _isTiao;
}
@property(readonly, nonatomic) NSUInteger lastSelectedIndex;

@end

@implementation ZIKMiaoQiTabBarViewController

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
    if (tabIndex == 3 ) {
        if (APPDELEGATE.userModel.goldsupplierStatus == 8) {
            _isTiao = YES;//是苗企，可以进入苗企中心
        } else {
            _isTiao = NO;//不是苗企，不可进入苗企中心
            ZIKHelpfulHintsViewController *helpfulVC = [[ZIKHelpfulHintsViewController alloc] initWithNibName:@"ZIKHelpfulHintsViewController" bundle:nil];
            helpfulVC.qubie = @"苗企中心";
            [self.navigationController pushViewController:helpfulVC animated:YES];
        }
    }
}

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
    stationVC.tabBarItem.title = @"苗企中心";
    stationVC.navigationController.navigationBar.hidden = YES;

    stationVC.tabBarItem.image = [[UIImage imageNamed:@"底部菜单-工程中心off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    stationVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部菜单-工程中心onn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];


    NSMutableArray *list = [[NSMutableArray alloc] initWithObjects:orderNav,buyNav,workNav,stationNav,nil];
    self.viewControllers = list;
    self.delegate = self;
    UIColor *normalColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       normalColor,           NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Helvetica" size:12.0], NSFontAttributeName,
                                                       nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = NavColor;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Helvetica" size:12.0], NSFontAttributeName,
                                                       nil] forState:UIControlStateSelected];
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return _isTiao;
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
